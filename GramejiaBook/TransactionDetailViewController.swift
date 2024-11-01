import UIKit
import CoreData

class TransactionDetailViewController : UIViewController,UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        transactionDetailList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TV_TransactionDetail.dequeueReusableCell(withIdentifier: "TransactionDetailViewCell", for: indexPath) as! TransactionDetailTableViewCell
        
        let instance = transactionDetailList[indexPath.row]
        
        if let url = URL(string: instance.image) {
            cell.IV_BookCover.loadImage(from: url)
        }else {
            cell.IV_BookCover.image = UIImage(named: "DetaultIcon")
        }
        
        cell.Lbl_BookTitle.text = instance.title
        
        cell.Lbl_QtyXPrice.text = "\(instance.quantity) x $ \(instance.price)"
        
        cell.Lbl_Subtotal.text = "$ \(Double(instance.quantity) * instance.price)"
        
        return cell
    }
    
    
    var context : NSManagedObjectContext!
    var selectedUUID : UUID?
    var transactionDetailList = [TransactionModel]()
    
    var totalPrice : Double = 0
    var date : Date = Date()
    
    @IBOutlet weak var lbl_email: UILabel!
    
    @IBOutlet weak var lbl_date: UILabel!
    
    @IBOutlet weak var lbl_uuid: UILabel!
    
    @IBOutlet weak var lbl_totalPrice: UILabel!
    
    @IBOutlet weak var TV_TransactionDetail: UITableView!
    
    
    func renderNonTableViewUI() {
        lbl_email.text = "Email : " + SharedValue.shared.signedInEmail
        lbl_date.text = "Date : " + SharedValue.shared.formatDateToString(date: date)
        lbl_uuid.text = "ID : " + selectedUUID!.uuidString
        lbl_totalPrice.text = "$ " + String(totalPrice)
    }
    
    func LoadDetailData(){
        transactionDetailList.removeAll()
        totalPrice = 0
        
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "Transaction")
        
        req.predicate = NSPredicate(format: "uuid == %@", selectedUUID! as CVarArg)
        
        do {
            let res = try context.fetch(req) as! [NSManagedObject]
            
            for data in res {
                let email = data.value(forKey: "email") as! String
                let imgLink = data.value(forKey: "imgLink") as! String
                let price = data.value(forKey: "price") as! Double
                let purchaseDate = data.value(forKey: "purchaseDate") as! Date
                let qty = data.value(forKey: "qty") as! Int
                let title = data.value(forKey: "title") as! String
                let uuid = data.value(forKey: "uuid") as! UUID
                
                transactionDetailList.append(TransactionModel(email: email, UUID: uuid, purchaseDate: purchaseDate, title: title, image: imgLink, quantity: qty, price: price))
                
                date = purchaseDate
                
                totalPrice += price * Double(qty)
            }
        } catch {
            print("error in loading transaction detail")
        }
        
        
    }
    
    override func viewDidLoad() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        TV_TransactionDetail.delegate = self
        TV_TransactionDetail.dataSource = self
        
        LoadDetailData()
        renderNonTableViewUI()
    }
    
}
