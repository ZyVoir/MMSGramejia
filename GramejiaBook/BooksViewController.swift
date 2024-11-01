import UIKit
import CoreData

class BooksViewController : UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var view_line: UIView!
    
    func UIHandler(){
        view_line.layer.cornerRadius = 5
    }
    
    @IBOutlet weak var BooksTableView: UITableView!
    var context : NSManagedObjectContext!
    
    var transactionList : [TransactionModel] = []
    var transactionDisctionary : [UUID: (Double, Date)] = [:]
    var transactionTableViewList : [Dictionary<UUID, (Double,Date)>.Element] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionDisctionary.count
        
    }
    
    var selectedUUID : UUID?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedUUID = transactionTableViewList[indexPath.row].key
        performSegue(withIdentifier: "GoToTransactionDetail", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToTransactionDetail" {
            let dest = segue.destination as! TransactionDetailViewController
            dest.selectedUUID = selectedUUID!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = BooksTableView.dequeueReusableCell(withIdentifier: "TransactionViewCell", for: indexPath) as! TransactionTableViewCell

        cell.LB_TransactionID?.text  = transactionTableViewList[indexPath.row].key.uuidString
        
        cell.LB_TotalPrice.text = "$ " + String( transactionTableViewList[indexPath.row].value.0)
        
        
        let currDate = transactionTableViewList[indexPath.row].value.1
       
        cell.LB_TransactionDate.text = SharedValue.shared.formatDateToString(date: currDate)
        
        
        return cell
        
    }
    func loadTransaction(){
        
        transactionList.removeAll()
        transactionDisctionary.removeAll()
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "Transaction")
        req.predicate = NSPredicate(format: "email == %@", SharedValue.shared.signedInEmail)
        
        do{
            let res = try context.fetch(req) as! [NSManagedObject]
            
            for data in res {
                let email = data.value(forKey: "email") as! String
                let imgLink = data.value(forKey: "imgLink") as! String
                let price = data.value(forKey: "price") as! Double
                let date = data.value(forKey: "purchaseDate") as! Date
                let quantity = data.value(forKey: "qty") as! Int
                let title = data.value(forKey: "title") as! String
                let uuid = data.value(forKey: "uuid") as! UUID
                
                transactionList.append(TransactionModel(email: email, UUID: uuid, purchaseDate: date, title: title, image: imgLink, quantity: quantity, price: price))
            }
            
        }catch{
            printContent("error load transaction data")
        }
        
        for transaction in transactionList{
           
            guard let uuid = transaction.UUID else {
                continue
            }
                    
            if transactionDisctionary.keys.contains(uuid){
                transactionDisctionary[transaction.UUID!]!.0 += transaction.price * Double(transaction.quantity)
            }else{
                transactionDisctionary[uuid] = (transaction.price * Double(transaction.quantity), transaction.purchaseDate)
        
            }
        }
        
        transactionTableViewList = transactionDisctionary.sorted{
            $0.value.1 > $1.value.1
        }
        
        BooksTableView.reloadData()
        
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadTransaction()
    }
    
    override func viewDidLoad() {
        BooksTableView.delegate = self
        BooksTableView.dataSource = self
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        UIHandler()
    }
    
    
    @IBAction func unwindToBook(_ unwindSegue: UIStoryboardSegue) {
            
    }
}
