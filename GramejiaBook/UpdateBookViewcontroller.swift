import UIKit
import CoreData

class UpdateBookViewcontroller : UIViewController {
    
    var context : NSManagedObjectContext!
    var isUpdated : Bool = false
    var oldBook : bookModel?

    
    @IBOutlet weak var iv_imgLink: UITextField!
    
    @IBOutlet weak var lbl_title: UITextField!
    
    @IBOutlet weak var lbl_author: UITextField!
    
    @IBOutlet weak var lbl_publisher: UITextField!
    
    @IBOutlet weak var lbl_language: UITextField!
    
    @IBOutlet weak var lbl_numPages: UITextField!
    
    @IBOutlet weak var lbl_synopsis: UITextField!
    
    @IBOutlet weak var lbl_price: UITextField!

    
    func showAlert(title : String, msg : String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default)
       
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
    @IBAction func btn_onUpdateBook(_ sender: Any) {
        let imgLink = iv_imgLink.text ?? ""
        var isImageValid : Bool = false
        
        let title = lbl_title.text ?? ""
        let author = lbl_author.text ?? ""
        let publisher = lbl_publisher.text ?? ""
        let language = lbl_language.text ?? ""
        let numPagesString = lbl_numPages.text ?? ""
        let synopsis = lbl_synopsis.text ?? ""
        let priceString = lbl_price.text ?? ""
        
        if imgLink == "" || title == "" || author == "" || publisher == "" || language == "" || numPagesString == "" || synopsis == "" || priceString == "" {
            showAlert(title: "ERROR!", msg: "All field must be filled!")
            return
        }
        else if let url = URL(string: imgLink){
            do {
                let data = try Data(contentsOf: url)
                
                if UIImage(data: data) != nil{
                    isImageValid = true
                }
                else {
                    showAlert(title: "ERROR!", msg: "Image is not valid!")
                    return
                }
            } catch{
                showAlert(title: "ERROR!", msg: "Image is not valid!")
                return
            }
        }
        
        let numPages = Int(numPagesString) ?? -1
        let price = Double(priceString) ?? -1
        
        if !isImageValid {
            return
        }
        else if publisher.count < 5 {
            showAlert(title: "ERROR!", msg: "publisher should be at least 5 characters long!")
            return
        }
        else if numPages <= 0 {
            showAlert(title: "ERROR!", msg: "number of pages should be greater than 0!")
            return
        }
        else if synopsis.count < 15 {
            showAlert(title: "ERROR!", msg: "synopsis should be at least 15 characters long!")
            return
        }
        else if price <= 0 {
            showAlert(title: "ERROR!", msg: "Price should be greater than 0!")
            return
        }
        
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
        
        req.predicate = NSPredicate(format: "title == %@ AND author == %@", title,author)
        
        
        
        do {
            let res = try context.fetch(req) as! [NSManagedObject]
            
            
            if res.first != nil {
                let data = res.first!
                data.setValue(title, forKey: "title")
                data.setValue(author, forKey: "author")
                data.setValue(imgLink, forKey: "imgLink")
                data.setValue(numPages, forKey: "numberPages")
                data.setValue(price, forKey: "price")
                data.setValue(language, forKey: "language")
                data.setValue(publisher, forKey: "publisher")
                data.setValue(synopsis, forKey: "synopsis")
            }
            
            
            
        }catch {
            print("failed to update book!")
        }
        
        do {
            try context.save()
            
            
        }catch {
            print("Save Book Data Failed!")
        }
        
        let req2 = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        req2.predicate = NSPredicate(format: "title == %@ AND author == %@", title, author)
        do {
            let res2 = try context.fetch(req2) as! [NSManagedObject]
            
            if res2.first != nil {
                let data = res2.first!
                data.setValue(price, forKey: "basePrice")
                data.setValue(imgLink, forKey: "imgLink")
            }
        } catch{
            print("Failed to update cart")
        }
        
        do {
            try context.save()
            
        } catch {
            print("error to update data")
        }
        isUpdated = true
    }
    
    
    override func viewDidLoad() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        
        lbl_title.isUserInteractionEnabled = false
        lbl_author.isUserInteractionEnabled = false
        
        iv_imgLink.text = oldBook?.imgLInk
        lbl_title.text = oldBook?.title
        lbl_author.text = oldBook?.author
        lbl_publisher.text = oldBook?.publisher
        lbl_language.text = oldBook?.language
        lbl_numPages.text = String(oldBook?.numPages ?? 0)
        lbl_synopsis.text = oldBook?.synopsis
        lbl_price.text = String(oldBook?.price ?? 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
}
