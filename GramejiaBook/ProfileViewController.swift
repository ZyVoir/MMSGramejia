//
//  ProfileViewController.swift
//  GramejiaBook
//
//  Created by prk on 24/09/24.
//

import UIKit
import CoreData


class ProfileViewController : UIViewController {
    
    var context : NSManagedObjectContext!
    
    func logOut(){
        SharedValue.shared.logOut()
        dismiss(animated: true, completion: nil)
    }
    
    func isNumeric(str : String) -> Bool {
        
        if str.contains("-"){
            return true
        }
        
        let numberSet = CharacterSet.decimalDigits
        return str.rangeOfCharacter(from: numberSet.inverted) == nil
    }
    
    func logOutAlert(msg : String){
        let alert = UIAlertController(title: "Log Out?", message: msg, preferredStyle: .alert)

        let LogOutAction = UIAlertAction(title: "Log Out", style: .default) { _ in
            self.logOut()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)

        alert.addAction(cancelAction)
        alert.addAction(LogOutAction)
        
        
        present(alert, animated: true)
        
    }
    
    @IBOutlet weak var BalanceContainer: UIView!
    
    func showAlert(title : String, msg : String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default)
    
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
    @IBAction func btn_TopUp(_ sender: Any) {
        let alertController = UIAlertController(title: "Top Up", message: "Enter Amount ($)", preferredStyle: .alert)
        
        alertController.addTextField{ textField in
            textField.placeholder = "Enter Amount"
            textField.keyboardType = .numberPad
        }
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { action in
            if let textField = alertController.textFields?.first {
                let enteredText = textField.text ?? ""
                
                
                // TODO : Validate the value and the datatype
                if enteredText == "" {
                    self.showAlert(title: "ERROR", msg: "Balance must be filled!")
                    
                }else if !self.isNumeric(str: enteredText){
                    self.showAlert(title: "ERROR", msg: "Please enter a number!")
                }
                else if Double(enteredText)! <= 0 {
                    self.showAlert(title: "ERROR", msg: "must be more than $0")
                }
                else {
                    let newBalance : Double = SharedValue.shared.signedInBalance + Double(enteredText)!
                    
                    
                    let req = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
                    
                    req.predicate = NSPredicate(format: "email == %@", SharedValue.shared.signedInEmail)
                    
                    do {
                        let res = try self.context.fetch(req) as! [NSManagedObject]
                        
                        for data in res {
                            data.setValue(newBalance, forKey: "balance")
                        }
                        
                        try self.context.save()
                        self.lbl_balance.text = "$ " + String(newBalance)
                        SharedValue.shared.signedInBalance = newBalance
                        
                        self.showAlert(title: "Success", msg: "Top up Succesfull!")
                    } catch{
                        print("Top up Failed!")
                    }
                    
                }
                
                
                
            }
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        
        
        present(alertController, animated: true)
        
        
    }
    
    @IBAction func btn_LogOut(_ sender: Any) {
        logOutAlert(msg: "Are you sure?")
    }
    
    
    @IBOutlet weak var lbl_nameTop: UILabel!
    
    @IBOutlet weak var lbl_email: UILabel!
    
    @IBOutlet weak var lbl_nameContainer: UILabel!
    
    @IBOutlet weak var lbl_balance: UILabel!
    
    override func viewDidLoad() {
        initRoundedContainer()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        lbl_nameTop.text = SharedValue.shared.signedInUsername
        lbl_email.text = SharedValue.shared.signedInEmail
        lbl_nameContainer.text = SharedValue.shared.signedInUsername
        lbl_balance.text = "$ " + String(SharedValue.shared.signedInBalance)
    }
 
    override func viewWillAppear(_ animated: Bool) {
        lbl_balance.text = "$ \(SharedValue.shared.signedInBalance)"
    }
    func initRoundedContainer(){
        BalanceContainer.layer.cornerRadius = 15
    }
}
