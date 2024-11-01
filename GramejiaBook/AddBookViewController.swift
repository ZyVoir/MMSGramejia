import UIKit
import CoreData


class AddBookViewController : UIViewController{
    
    var context : NSManagedObjectContext!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func showAlert(title : String, msg : String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default)
       
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
    func showSuccessAlert(title : String, msg : String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default){ _ in
            self.dismiss(animated: true, completion: nil)
        }
        // add action to alert
      
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
    @IBOutlet weak var TF_imglink: UITextField!
    
    @IBOutlet weak var TF_bookTitle: UITextField!
    
    @IBOutlet weak var TF_bookAuthor: UITextField!
    
    @IBOutlet weak var TF_bookPublisher: UITextField!
    
    @IBOutlet weak var TF_bookLanguage: UITextField!
    
    @IBOutlet weak var TF_numPages: UITextField!
    
    @IBOutlet weak var TF_bookSynopsis: UITextField!
    
    @IBOutlet weak var TF_bookPrice: UITextField!
    
    @IBAction func btn_onClickAddBook(_ sender: Any) {
        let imgLink = TF_imglink.text ?? ""
        var isImageValid : Bool = false
        
        let title = TF_bookTitle.text ?? ""
        let author = TF_bookAuthor.text ?? ""
        let publisher = TF_bookPublisher.text ?? ""
        let language = TF_bookLanguage.text ?? ""
        let numPagesString = TF_numPages.text ?? ""
        let synopsis = TF_bookSynopsis.text ?? ""
        let priceString = TF_bookPrice.text ?? ""
        
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
        else if title.count < 5 {
            showAlert(title: "ERROR!", msg: "title should be at least 5 characters long!")
            return
        }
        else if author.count < 5 {
            showAlert(title: "ERROR!", msg: "author should be at least 5 characters long!")
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
                showAlert(title: "ERROR!", msg: "Title and Author already exist!")
                return
            }
        }catch {
            print("failed to check unique books")
        }
        
        let rating = SharedValue.shared.randomRating()
        // TODO : ADD BOOK
        let entity = NSEntityDescription.entity(forEntityName: "Book", in: context)
        let newBook = NSManagedObject(entity: entity!, insertInto: context)
        newBook.setValue(title, forKey: "title")
        newBook.setValue(author, forKey: "author")
        newBook.setValue(imgLink, forKey: "imgLink")
        newBook.setValue(numPages, forKey: "numberPages")
        newBook.setValue(price, forKey: "price")
        newBook.setValue(language, forKey: "language")
        newBook.setValue(publisher, forKey: "publisher")
        newBook.setValue(synopsis, forKey: "synopsis")
        newBook.setValue(rating, forKey: "rating")
        do {
            try context.save()
            showSuccessAlert(title: "Success!", msg: "Book Added Successfully!")
        }catch {
            print("Save Book Data Failed!")
        }
        
    }
    
    override func viewDidLoad() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
}
