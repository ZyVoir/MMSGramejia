import UIKit
import CoreData


class SignUpVIewController : UIViewController {
    
    var context : NSManagedObjectContext!
    
    
    @IBOutlet weak var TF_email: UITextField!
    @IBOutlet weak var TF_username: UITextField!
    @IBOutlet weak var TF_password: UITextField!
    
    
    @IBOutlet var RgsUnderline: UIView!
    
    
    func showAlert(title : String, msg : String, backtoLogin : Bool){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default){ _ in
            if backtoLogin {
                self.dismiss(animated: true, completion: nil)
            }
        }
        // add action to alert
      
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
    func isAlphabet(str : String) -> Bool {
        let alphabetSet = CharacterSet.letters
        return str.rangeOfCharacter(from: alphabetSet.inverted) == nil
    }
    
    func isAlphaNumeric(str : String) -> Bool {
        let alphabetSet = CharacterSet.letters
        let numberSet = CharacterSet.decimalDigits
        return str.rangeOfCharacter(from: alphabetSet.inverted) != nil && str.rangeOfCharacter(from: numberSet.inverted) != nil
    }
    
    @IBAction func btn_OnRegister(_ sender: Any) {
        let email : String = TF_email.text ?? ""
        let username : String = TF_username.text ?? ""
        let password : String = TF_password.text ?? ""
        
        
        // TODO : same email cannot coexist!
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        req.predicate = NSPredicate(format: "email == %@", email)
        do{
            let res = try context.fetch(req) as! [NSManagedObject]
            
            if res.first != nil {
                if res.first != nil {
                    showAlert(title: "ERROR", msg: "Email Already Exist!", backtoLogin: false)
                    return
                }
            }
        } catch {
         print("Login Failed!")
        }
        
        if email == "" || username == "" || password == "" {
            showAlert(title: "Error", msg: "All field must be filled!", backtoLogin: false)
        }
        else if !email.hasSuffix("@gmail.com") {
            showAlert(title: "Error", msg: "email must end with \"@gmail.com\"", backtoLogin: false)
        }
        else if email.count <= 10 {
            showAlert(title: "Error", msg: "Email must has a prefix", backtoLogin: false)
        }
        else if username.count < 7 {
            showAlert(title: "Error", msg: "Username must be at least 7 characters", backtoLogin: false)
        }
        else if !isAlphabet(str: username){
            showAlert(title: "Error", msg: "Username must contain alphabets only", backtoLogin: false)
        }
        else if password.count < 7 {
            showAlert(title: "Error", msg: "Password must be at least 7 characters long", backtoLogin: false)
        }
        else if !isAlphaNumeric(str: password){
            showAlert(title: "Error", msg: "Password must be alphanumeric", backtoLogin: false)
        }
        else {
            let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
            let newUser = NSManagedObject(entity: entity!, insertInto: context)
            newUser.setValue(email, forKey: "email")
            newUser.setValue(password, forKey: "password")
            newUser.setValue(username, forKey: "username")
            newUser.setValue("user", forKey: "role")
            newUser.setValue(0.0, forKey: "balance")
            
            do {
                try context.save()
                showAlert(title: "Successfull", msg: "Register Successfull!", backtoLogin: true)
                
            } catch {
                print("Register Failed!")
            }
        }
    }
    
    func cornerLoginUnderline(){
        RgsUnderline.layer.cornerRadius = RgsUnderline.frame.height/2
        RgsUnderline.translatesAutoresizingMaskIntoConstraints = true
    }
    
    override func viewDidLoad() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }

 
}
