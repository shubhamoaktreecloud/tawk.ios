//
//  ViewController.swift
//  tawkioIOS
//
//  Created by Mac on 29/04/21.
//

import UIKit
import CoreData
import ProgressHUD
import KRPullLoader

class ViewController: UIViewController, KRPullLoadViewDelegate {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var userTV: UITableView!
    let serviceManger = JsonParsing()
    var usersArr = [Users]()

    private let reuseIdentifier = "UserCustomCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "UsersCell", bundle: nil)
        self.userTV.register(nib, forCellReuseIdentifier: reuseIdentifier)
        
        let refreshView = KRPullLoadView()
        refreshView.delegate = self
        userTV.addPullLoadableView(refreshView, type: .loadMore)
       
        // Do any additional setup after loading the view.
        let checkData = serviceManger.entityIsEmpty()
        if(checkData){
            ProgressHUD.show("One time Load only...")
            serviceManger.jsonParsingforUserslist(pageCount: 0)
        }else{
            self.usersArr = self.serviceManger.fetchData()
            self.userTV.reloadData()
            
        }
        onSave = { (data) in
            self.usersArr = self.serviceManger.fetchData()
            self.userTV.reloadData()
            ProgressHUD.dismiss()
        }
    }
    
    func pullLoadView(_ pullLoadView: KRPullLoadView, didChangeState state: KRPullLoaderState, viewType type: KRPullLoaderType) {
        
        if(type == .loadMore)
        {
            ProgressHUD.show("Loading...")
            serviceManger.jsonParsingforUserslist(pageCount: 1)
        }
    }
 
}

extension ViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text else { return }
            if searchText.isEmpty {
               // userTV.reloadData()
               DispatchQueue.main.async {
                  searchBar.resignFirstResponder()
               }
            } else {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
               let request : NSFetchRequest<Users> = Users.fetchRequest()
                request.predicate = NSPredicate(format: "login CONTAINS [cd] %@", searchBar.text!)
               request.sortDescriptors = [NSSortDescriptor(key: "login", ascending: true)]
               do {
                usersArr = try context.fetch(request)
               } catch {
                   print(error)
               }
                userTV.reloadData()
            }
    }
}

extension ViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = userTV.dequeueReusableCell(withIdentifier: "UserCustomCell", for: indexPath) as! UsersCell
        
        let indexvalue = usersArr[indexPath.row]
        cell.usernameLbl.text = indexvalue.login
        cell.userImgView.load(urlString: indexvalue.avatar_url!)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UserDetailController") as! UserDetailController
        vc.username = usersArr[indexPath.row].login!
        navigationController?.pushViewController(vc, animated: true)
    
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
    
    
}

extension UIImageView {
    func load(urlString : String) {
        guard let url = URL(string: urlString)else {
            return
        }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
