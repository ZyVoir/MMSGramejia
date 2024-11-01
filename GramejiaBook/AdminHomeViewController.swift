
import UIKit
import CoreData


class AdminHomeViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
    
    var context : NSManagedObjectContext!
    
    @IBOutlet weak var adminHomeTableView: UITableView!
       
    var selectedBook : bookModel?
    
    
    @IBOutlet weak var SB_adminSearchBar: UISearchBar!
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            BookList = AllBookList
        }
        else {
            BookList = AllBookList.filter {$0.title.lowercased().contains(searchText.lowercased())}
        }
        adminHomeTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedBook = BookList[indexPath.row]
        performSegue(withIdentifier: "GoToAdminDetail", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToAdminDetail"{
            let dest = segue.destination as! DetailAdminViewController
            dest.selectedBook = selectedBook
            dest.onDismiss = {
                self.loadListBookData()
            }
        }
    }
    
    
    
    @IBOutlet weak var view_container: UIView!
    
    @IBAction func btn_onClickLogOut(_ sender: Any) {
        logOutAlert(msg: "Are you sure?")
    }
    
    @IBOutlet weak var Lbl_name: UILabel!
    
    
    @IBAction func btn_onclickAddBook(_ sender: Any) {
       
        performSegue(withIdentifier: "AddBook", sender: self)
    }
    
    func logOutAlert(msg : String){
        let alert = UIAlertController(title: "Log Out?", message: msg, preferredStyle: .alert)

        let LogOutAction = UIAlertAction(title: "Log Out", style: .default) { _ in
            SharedValue.shared.logOut()
            self.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)

        alert.addAction(cancelAction)
        alert.addAction(LogOutAction)
        
        
        present(alert, animated: true)
        
    }
    
    var BookList = [bookModel]()
    var AllBookList = [bookModel]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BookList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = adminHomeTableView.dequeueReusableCell(withIdentifier: "adminHomeViewCell", for: indexPath) as! AdminHomeTableViewCell
        
        cell.Lbl_BookTitle.text = BookList[indexPath.row].title
        if let url = URL(string: BookList[indexPath.row].imgLInk) {
            cell.IV_BookCover.loadImage(from: url)
        }
        else {
            cell.IV_BookCover.image = UIImage(named: "DefaultIcon")
        }
        
        cell.Lbl_BookAuthor.text = BookList[indexPath.row].author
        cell.Lbl_BookRating.text = String(BookList[indexPath.row].rating)
        cell.Lbl_BookPrice.text = "$ " + String(BookList[indexPath.row].price)
        
        
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initRoundedContainer()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
    
        adminHomeTableView.delegate = self
        adminHomeTableView.dataSource = self
        
        Lbl_name.text = "Hi, " + SharedValue.shared.signedInUsername + " !"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // TODO : Clear out search bar query
        print("loaded")
        loadListBookData()
        selectedBook = nil
    }
    
    func loadListBookData(){
        BookList.removeAll()
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
        
    
        do {
            let res = try context.fetch(req) as! [NSManagedObject]
            
            for data in res {
                let imgLink = data.value(forKey: "imgLink") as! String
                let title = data.value(forKey: "title") as! String
                let author = data.value(forKey: "author") as! String
                let publisher = data.value(forKey: "publisher") as! String
                let language = data.value(forKey: "language") as! String
                let numPages = data.value(forKey: "numberPages") as! Int
                let synopsis = data.value(forKey: "synopsis") as! String
                let price = data.value(forKey: "price") as! Double
                let rating = data.value(forKey: "rating") as! Double
                BookList.append(bookModel(imgLInk: imgLink, title: title, author: author, publisher: publisher, language: language, numPages: numPages, synopsis: synopsis, price: price, rating: rating))
            }
            AllBookList = BookList
            adminHomeTableView.reloadData()
        } catch{
            print("error in fetching book data")
        }
    }
   
    
    @IBAction func unwindToAdminHome(_ unwindSegue: UIStoryboardSegue) {
      
    }
    
    func initRoundedContainer(){
        view_container.layer.cornerRadius = 25
        view_container.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        view_container.layer.masksToBounds = true
    }
}

