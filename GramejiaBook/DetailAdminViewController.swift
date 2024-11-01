import UIKit
import CoreData


class DetailAdminViewController : UIViewController {
    var onDismiss: (() -> Void)?
    var selectedBook : bookModel?
    var context : NSManagedObjectContext!
    
    @IBOutlet weak var IV_cover: UIImageView!
    
    @IBOutlet weak var Lbl_title: UILabel!
    
    @IBOutlet weak var Lbl_author: UILabel!
    
    @IBOutlet weak var Lbl_rating: UILabel!
    
    @IBOutlet weak var Lbl_nPages: UILabel!
    
    @IBOutlet weak var Lbl_language: UILabel!
    
    @IBOutlet weak var Lbl_publisher: UILabel!
    
    @IBOutlet weak var Lbl_synopsis: UILabel!
    
    @IBOutlet weak var Lbl_price: UILabel!
    
    func deleteBook(){
        let title = Lbl_title.text ?? ""
        let author = Lbl_author.text ?? ""
        
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
        req.predicate = NSPredicate(format: "title == %@ AND author == %@", title, author)
        
        do {
            let res = try context.fetch(req) as! [NSManagedObject]
            
            for data in res {
                context.delete(data)
            }
            
            try context.save()
            
            let reqCart = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
            
            reqCart.predicate = NSPredicate(format: "title == %@ AND author == %@", title, author)
            
            do {
                let resCart = try context.fetch(reqCart) as! [NSManagedObject]
                
                for data in resCart {
                    context.delete(data)
                }
                
                try context.save()
                dismiss(animated: true, completion: nil)
            } catch {
                
            }
            
            
            
        }catch {
            print("delete book error")
        }
        
        
    }
    
    func deleteAlert(){
        let alert = UIAlertController(title: "Delete?", message: "are you sure you want to delete?", preferredStyle: .alert)

        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.deleteBook()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)

        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        
        present(alert, animated: true)
        
    }
    
    func showSuccessAlert(title : String, msg : String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default){ _ in
        }
        // add action to alert
      
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
    
    @IBAction func btn_onClickDelete(_ sender: Any) {
            deleteAlert()
    }
    
    @IBAction func on_clickUpdate(_ sender: Any) {
        performSegue(withIdentifier: "GoToUpdate", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToUpdate" {
            let dest = segue.destination as! UpdateBookViewcontroller
            dest.oldBook = selectedBook!
            
        }
    }
    
    override func viewDidLoad() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        if let url = URL(string: selectedBook?.imgLInk ?? ""){
            IV_cover.loadImage(from: url)
        }
        else {
            IV_cover.image = UIImage(named: "DefaultIcon")
        }
        
        Lbl_title.text = selectedBook?.title
        Lbl_price.text = "$ " + String(selectedBook?.price ?? 0)
        Lbl_author.text = selectedBook?.author
        Lbl_rating.text = String(selectedBook?.rating ?? 0) + "/5"
        Lbl_nPages.text = String(selectedBook?.numPages ?? 0)
        Lbl_language.text = selectedBook?.language ?? ""
        Lbl_publisher.text = selectedBook?.publisher ?? ""
        Lbl_synopsis.text = selectedBook?.synopsis ?? ""
        
        
        
    }
    
    
    @IBAction func unwindToDetailAdmin(_ unwindSegue: UIStoryboardSegue) {
        if let src = unwindSegue.source as? UpdateBookViewcontroller {
            if src.isUpdated == true {
                if let url = URL(string: src.iv_imgLink.text!){
                    IV_cover.loadImage(from: url)
                }
                else {
                    IV_cover.image = UIImage(named: "DefaultIcon")
                }
                Lbl_title.text = src.lbl_title.text
                Lbl_price.text = "$ " + String(src.lbl_price.text ?? "")
                Lbl_author.text = src.lbl_author.text
                Lbl_rating.text = String(selectedBook?.rating ?? 0) + "/5"
                Lbl_nPages.text = String(src.lbl_numPages.text ?? "")
                Lbl_language.text = src.lbl_language.text
                Lbl_publisher.text = src.lbl_publisher.text
                Lbl_synopsis.text = src.lbl_synopsis.text
                
                
                selectedBook?.title = Lbl_title.text ?? ""
                selectedBook?.price = Double(src.lbl_price.text!) ?? 0
                selectedBook?.author = Lbl_author.text ?? ""
                selectedBook?.imgLInk = src.iv_imgLink.text ?? ""
                selectedBook?.numPages = Int(src.lbl_numPages.text!) ?? 0
                selectedBook?.language = Lbl_language.text ?? ""
                selectedBook?.publisher = Lbl_publisher.text ?? ""
                selectedBook?.synopsis = Lbl_synopsis.text ?? ""
                
                DispatchQueue.main.asyncAfter(deadline: .now()){
                    self.showSuccessAlert(title: "Success!", msg: "Book Updated Successfully!")
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        onDismiss?()
    }
}
