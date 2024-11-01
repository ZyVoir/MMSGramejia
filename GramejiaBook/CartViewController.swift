import UIKit
import CoreData

class CartViewController : UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    func showAlert(title : String, msg : String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: title == "Are you sure?" ? "BUY" : "OK", style: .default){ _ in
            if title == "Are you sure?"{
                let userBalanace = SharedValue.shared.signedInBalance
                if self.totalPrice > userBalanace {
                    self.showAlert(title: "ERROR", msg: "No enough balance, go to profile to top up")
                } else {
                    self.checkOut()
                }
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "CANCEL", style: .default)
        
        if title != "Success" && title != "ERROR" {
            alert.addAction(cancelAction)
        }
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
    @IBOutlet weak var CartTableView: UITableView!
    
    
    @IBOutlet weak var TotalSelectedItem: UILabel!
    
    var context : NSManagedObjectContext!
    
    var CartList : [CartModel] = []
    
    var selectedCount : Int = 0
    
    @IBOutlet weak var Lbl_totalPrice: UILabel!
    
    var totalPrice : Double = 0.0
    
    func updateTotalPrice(){
        Lbl_totalPrice.text = "Total : $ \(String(format: "%.2f", totalPrice))"
    }
    
    func updateTotalSelectedBook(){
        TotalSelectedItem.text = "Selected Items: (\(selectedCount))"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CartList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CartTableView.dequeueReusableCell(withIdentifier: "cartViewCell", for: indexPath) as! CartTableViewCell
        
        let cartItem = CartList[indexPath.row]
        
        cell.Lbl_CartBookTitle.text = cartItem.title
        if let url = URL(string: cartItem.image) {
            cell.IV_CartBookCover.loadImage(from: url)
        }
        
        cell.Lbl_CartBookPrice.text = String(format: "$%.2f", cartItem.price)
        cell.TF_CartBookQuantity.text = "\(cartItem.quantity)"
        cell.TF_CartBookQuantity.isUserInteractionEnabled = false
        
//        Set the checkbox state
        cell.isSelectedRadio = cartItem.isSelected

        // Add action for the checkbox
        cell.Btn_RadioButton.tag = indexPath.row
        cell.Btn_RadioButton.addTarget(self, action: #selector(RadioButtonClick(_:)), for: .touchUpInside)
        
        cell.quantityChanged = { [weak self] newQuantity in
            let isIncrement = newQuantity > cartItem.quantity
            self?.CartList[indexPath.row].quantity = newQuantity
            
            let email = cartItem.email
            let title = cartItem.title
            let author = cartItem.author
            let isSelected = cartItem.isSelected
            let price = cartItem.price
            
            let req = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
            req.predicate = NSPredicate(format: "email == %@ AND title == %@ AND author == %@", email,title,author)
            
            do {
                let res = try self?.context.fetch(req) as! [NSManagedObject]
                
                if res.first != nil {
                    let data = res.first!
                    data.setValue(newQuantity, forKey: "qty")
                }
            } catch {
                print("failed to update qty")
            }
            
            do {
                try self?.context.save()
                
                
            } catch {
                print("failed to update qty data")
            }
            
            if isSelected {
                self?.totalPrice = isIncrement ? self!.totalPrice + price : self!.totalPrice - price
            }
            
            
            self?.updateTotalPrice()
        }
        
        
        cell.onCartDelete = {
            let email = cartItem.email
            let title = cartItem.title
            let author = cartItem.author
            var isSelected : Bool?
            
            let req = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
            req.predicate = NSPredicate(format: "email == %@ AND title == %@ AND author == %@", email,title,author)
            
            do {
                let res = try self.context.fetch(req) as! [NSManagedObject]
                for data in res {
                    isSelected = (data.value(forKey: "isSelected") as! Bool)
                    self.context.delete(data)
                }
                
                try self.context.save()
            } catch {
                print("delete failed!")
            }
            
            self.selectedCount = isSelected! ? self.selectedCount - 1 : self.selectedCount;
            
            self.loadDataCart()
        }
              
       
        
        return cell
    
    }
    
    
    @IBAction func RadioButtonClick(_ sender: UIButton) {
        
        let index = sender.tag
        let instance = CartList[index]
        CartList[index].isSelected = !instance.isSelected
        
    
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        req.predicate = NSPredicate(format: "email == %@ AND title == %@ AND author == %@",instance.email, instance.title,instance.author)
        
        do {
            let res = try context.fetch(req) as! [NSManagedObject]
            if res.first != nil {
                let data = res.first!
                data.setValue(CartList[index].isSelected, forKey: "isSelected")
            }
        } catch {
            print("error in updating seleted cart")
        }
        
        do {
            try context.save()
        } catch {
          print("failed to update selected cart")
        }
        selectedCount = CartList[index].isSelected ? selectedCount + 1 : selectedCount - 1;

        let subTotal = Double(instance.quantity) * instance.price
        totalPrice = CartList[index].isSelected ? totalPrice + subTotal : totalPrice - subTotal
        
        updateTotalPrice()
        updateTotalSelectedBook()
        
        CartTableView.reloadData()
        
    }
    
    
    @IBOutlet weak var BottomCartShadow: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        loadDataCart()
        
        UIHandler()
        
    }
    
    func UIHandler(){
        BottomCartShadow.layer.cornerRadius = 10
        BottomCartShadow.layer.shadowColor = UIColor.black.cgColor
        BottomCartShadow.layer.shadowOpacity = 0.5
        BottomCartShadow.layer.shadowOffset = CGSize(width: 0, height: 5)
        BottomCartShadow.layer.shadowRadius = 10
        
        CartTableView.delegate = self
        CartTableView.dataSource = self
    }
    
    func loadDataCart(){
        selectedCount = 0
        totalPrice = 0.0
        CartList.removeAll()
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        let email = SharedValue.shared.signedInEmail
        req.predicate = NSPredicate(format: "email == %@", email)
        
        do {
            let res = try context.fetch(req) as! [NSManagedObject]
            for data in res {
                let emailData = data.value(forKey: "email") as! String
                let title = data.value(forKey: "title") as! String
                let author = data.value(forKey: "author") as! String
                let imgLink = data.value(forKey: "imgLink") as! String
                let qty = data.value(forKey: "qty") as! Int
                let basePrice = data.value(forKey: "basePrice") as! Double
                let isSelected = data.value(forKey: "isSelected") as! Bool
                CartList.append(CartModel(title: title, author: author, price: basePrice, quantity: qty, image: imgLink, email: emailData, isSelected: isSelected))
                
                if isSelected {
                    selectedCount += 1
                    let subTotal = basePrice * Double(qty)
                    totalPrice += subTotal
                }
                
                
            }
            CartTableView.reloadData()
            updateTotalPrice()
            updateTotalSelectedBook()
        } catch {
            print("error on loading cart data!")
        }
    }
    
    
    @IBAction func btn_onCheckOut(_ sender: Any) {
        if CartList.count == 0 {
            showAlert(title: "ERROR", msg: "No Items in the cart")
            return
        }
        else if selectedCount == 0 {
            showAlert(title: "ERROR", msg: "No Selected item in the cart")
            return
        }
        
        showAlert(title: "Are you sure?", msg: "\(selectedCount) " + (selectedCount == 1 ? "book" : "books") + " with a total price of $\(String(format: "%.2f", totalPrice))" )
    }
    
    func checkOut(){
        let email = SharedValue.shared.signedInEmail
        let UUID = UUID()
        let purchaseDate = Date()
        
        
        // 1. Update balance
        let newBalance = SharedValue.shared.signedInBalance - totalPrice
        
        var req = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        req.predicate = NSPredicate(format: "email == %@", email)
        
        do {
            let res = try context.fetch(req) as! [NSManagedObject]
            for data in res {
                data.setValue(newBalance, forKey: "balance")
            }
            
            try context.save()
            SharedValue.shared.signedInBalance = newBalance
        } catch {
            print("error updating balance")
        }
        
        
        // 2. Delete selected cart
        req = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        req.predicate = NSPredicate(format: "email == %@ AND isSelected == %@", email, NSNumber(value: true))
        
        do {
            let res = try context.fetch(req) as! [NSManagedObject]
            
            for data in res {
                context.delete(data)
            }
            
            try context.save()
        } catch {
            print("error in deleting selected cart")
        }
        
        // 3. Create transaction
        
        
        for cart in CartList {
            let title = cart.title
            let image = cart.image
            let qty = cart.quantity
            let price = cart.price
            
            if cart.isSelected {
                let entity = NSEntityDescription.entity(forEntityName: "Transaction", in: context)
                
                let newTransaction = NSManagedObject(entity: entity!, insertInto: context)
                
                newTransaction.setValue(email, forKey: "email")
                newTransaction.setValue(UUID, forKey: "uuid")
                newTransaction.setValue(purchaseDate, forKey: "purchaseDate")
                newTransaction.setValue(title, forKey: "title")
                newTransaction.setValue(image, forKey: "imgLink")
                newTransaction.setValue(qty, forKey: "qty")
                newTransaction.setValue(price, forKey: "price")
                
                do {
                    try context.save()
                    showAlert(title: "Success", msg: "Checkout successfull")
                } catch {
                    print("add book failed!")
                }
            }
        }
        
        loadDataCart()
    }
}

