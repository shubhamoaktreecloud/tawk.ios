//
//  JsonParsing.swift
//  tawkioIOS
//
//  Created by Mac on 29/04/21.
//
import UIKit
import Foundation
import CoreData

var onSave: ((_ data: String) -> ())?

protocol SenderViewControllerDelegate {
    func messageData(data: UserBioDetail)
}

struct JsonParsing {
    
    var delegate: SenderViewControllerDelegate?
    
    func jsonParsingforUserslist(pageCount:Int){
        let service = URL(string: "https://api.github.com/users?since=\(pageCount)")
        
        URLSession.shared.dataTask(with: service!){ data,responce,error in
            if error != nil{
                print(error!)
                return
            }
            do{
                
                let result = try JSONDecoder().decode([UserDetail].self, from: data!)
                
                savingDatainCoreData(result: result)
                
            }catch{
                
            }
            
        }.resume()
    }
    
    func jsonparsingForSingleUserDetail(username: String){
        let service = URL(string: "https://api.github.com/users/\(username)")
        
        URLSession.shared.dataTask(with: service!){ data,responce,error in
            if error != nil{
                print(error!)
                return
            }
            do{
                
                let result = try JSONDecoder().decode(UserBioDetail.self, from: data!)
                self.delegate?.messageData(data: result)
               print(result)
                
            }catch{
                
            }
            
        }.resume()
    }
        
    func savingDatainCoreData(result: [UserDetail]){
        
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Users", in: context)
            
            for user in result {
                
                let newUser = NSManagedObject(entity: entity!, insertInto: context)

                newUser.setValue(user.login, forKey: "login")
                newUser.setValue(user.id, forKey: "id")
                newUser.setValue(user.avatar_url, forKey: "avatar_url")
                newUser.setValue(user.node_id, forKey: "node_id")
                
                do {
                   try context.save()
                } catch {
                   print("Failed saving")
                }
            }
            onSave?("Data saved")
                
        }

    }
    
    
    func fetchData()->[Users]{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        do {
            let results   = try context.fetch(fetchRequest)
            let usersArr = results as! [Users]
            return usersArr

        } catch let error as NSError {
          print("Could not fetch \(error)")
        }
        let usersArr = [Users]()
        return usersArr
    }
    
    func entityIsEmpty()->Bool
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Users>(entityName: "Users")

        do {
            let result = try context.fetch(fetchRequest)
            if result.isEmpty {
                print("data not exist")
                return true
            } else {
                print("data exist")
            }
        } catch {
            print(error)
        }
        return false
    }
    
}
