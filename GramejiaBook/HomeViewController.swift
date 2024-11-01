import UIKit
import CoreData


class HomeViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var HomeTableView: UITableView!
    
    @IBOutlet weak var SB_UserSearchBar: UISearchBar!
        
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            BookList = allBookList
        } else {
            BookList = allBookList.filter {$0.title.lowercased().contains(searchText.lowercased())}
        }
        HomeTableView.reloadData()
    }
    
    var context : NSManagedObjectContext!
    
    var BookList = [bookModel]()
    
    var allBookList = [bookModel]()
    
    var selectedBook : bookModel?
    
    @IBOutlet weak var lbl_username: UILabel!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BookList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = HomeTableView.dequeueReusableCell(withIdentifier: "homeViewCell", for: indexPath) as! HomeTableViewCell
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedBook = BookList[indexPath.row]
        performSegue(withIdentifier: "GoToDetail", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToDetail"{
            let dest = segue.destination as! DetailUserViewController
            dest.selectedBook = selectedBook
        }
    }
    
    @IBAction func Btn_OnClickCartBtn(_ sender: Any) {
        print("Go To Cart")
        performSegue(withIdentifier: "GoToCart", sender: self)
    }
    
    
    @IBOutlet weak var HomeTopContainer: UIView!
    
    
    let spaceBetweenSection = 20
    
    override func viewDidLoad() {
        initializeHomeTopContainerRounded()
        
        HomeTableView.delegate = self
        HomeTableView.dataSource = self
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        lbl_username.text = "Hi, " + SharedValue.shared.signedInUsername + " !"
        
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
            allBookList = BookList
            HomeTableView.reloadData()
        } catch{
            print("error in fetching book data")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        selectedBook = nil
        loadListBookData()
    }
    
    @IBAction func unwindToHome(_ unwindSegue: UIStoryboardSegue) {
        if let src = unwindSegue.source as? CartViewController {
            
        }
    }
    
    func initializeHomeTopContainerRounded(){
        HomeTopContainer.layer.cornerRadius = 15
        
        HomeTopContainer.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        HomeTopContainer.layer.masksToBounds = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
