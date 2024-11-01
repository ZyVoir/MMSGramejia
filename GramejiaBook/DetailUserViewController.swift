import UIKit
import CoreData

class DetailUserViewController : UIViewController {
    
    func showAlert(title : String, msg : String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default){ _ in
            if title == "Success"{
                self.dismiss(animated: true, completion: nil)
            }
            
        }
      
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
    @IBOutlet weak var IV_cover: UIImageView!
    
    @IBOutlet weak var lbl_title: UILabel!
    
    @IBOutlet weak var lbl_author: UILabel!
    
    @IBOutlet weak var lbl_rating: UILabel!
    
    @IBOutlet weak var lbl_numPages: UILabel!
    
    @IBOutlet weak var lbl_language: UILabel!
    
    @IBOutlet weak var lbl_publisher: UILabel!
    
    @IBOutlet weak var lbl_synopsis: UILabel!
    
    @IBOutlet weak var lbl_price: UILabel!
    
    
    var selectedBook : bookModel?
    var context : NSManagedObjectContext!
    
    override func viewDidLoad() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        initBookDetailInfo()
    }
    
    func initBookDetailInfo(){
        if let url = URL(string: selectedBook?.imgLInk ?? ""){
            IV_cover.loadImage(from: url)
        }
        lbl_title.text = selectedBook?.title ?? ""
        lbl_author.text = selectedBook?.author ?? ""
        lbl_rating.text = String(selectedBook?.rating ?? 0) + "/5"
        lbl_numPages.text = String(selectedBook?.numPages ?? 0)
        lbl_language.text = selectedBook?.language ?? ""
        lbl_publisher.text = selectedBook?.publisher ?? ""
        lbl_synopsis.text = selectedBook?.synopsis ?? ""
        lbl_price.text = "$ " + String(selectedBook?.price ?? 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @IBAction func btn_OnClickBtnCart(_ sender: Any) {
        // TODO : Add book
        
        let email = SharedValue.shared.signedInEmail
        let title = selectedBook?.title ?? ""
        let author = selectedBook?.author ?? ""
        let imgLInk = selectedBook?.imgLInk ?? ""
        let qty = 1
        let basePrice = selectedBook?.price ?? 0.0
        let isSelected = true
        
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        req.predicate = NSPredicate(format: "email == %@ AND title == %@ AND author == %@", email,title,author)
        
        do {
            let res = try context.fetch(req) as! [NSManagedObject]
            
            if res.first != nil {
                showAlert(title: "ERROR", msg: "This book already exist in the cart")
                return
            }
        } catch {
            print("Failed to check existing cart")
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "Cart", in: context)
        let newCart = NSManagedObject(entity: entity!, insertInto: context)
        
        newCart.setValue(author, forKey: "author")
        newCart.setValue(basePrice, forKey: "basePrice")
        newCart.setValue(email, forKey: "email")
        newCart.setValue(imgLInk, forKey: "imgLink")
        newCart.setValue(isSelected, forKey: "isSelected")
        newCart.setValue(qty, forKey: "qty")
        newCart.setValue(title, forKey: "title")
        
        do {
            try context.save()
            showAlert(title: "Success", msg: "\(title) successfully added to cart")
        } catch{
            print("error at adding book to cart")
        }
    }
    
}
