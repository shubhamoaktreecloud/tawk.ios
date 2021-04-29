//
//  UserDetailController.swift
//  TawkioIOS
//
//  Created by Mac on 29/04/21.
//

import UIKit
import ProgressHUD

class UserDetailController: UIViewController,SenderViewControllerDelegate {
    
    
    @IBOutlet weak var headLbl: UILabel!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    
    var username : String = ""
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var followerCountLbl: UILabel!
    @IBOutlet weak var followingCountLbl: UILabel!
    @IBOutlet weak var noteImgView: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var companyLbl: UILabel!
    @IBOutlet weak var blogLbl: UILabel!
    @IBOutlet weak var noteTextLbl: UILabel!
    var serviceManger = JsonParsing()
    var userBioArr = UserBioDetail()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.userImgView.layer.cornerRadius = self.userImgView.frame.size.width/2
        self.firstView.layer.shadowColor = UIColor.gray.cgColor
        self.firstView.layer.shadowOffset = CGSize(width: 10, height: 10)
        self.firstView.layer.shadowOpacity = 5
        self.firstView.layer.shadowRadius = 10.0
        
        self.secondView.layer.shadowColor = UIColor.gray.cgColor
        self.secondView.layer.shadowOffset = CGSize(width: 10, height: 10)
        self.secondView.layer.shadowOpacity = 5
        self.secondView.layer.shadowRadius = 10.0

        headLbl.text = username
        ProgressHUD.show("Loading...")
        serviceManger.delegate = self
        serviceManger.jsonparsingForSingleUserDetail(username: username)

                // Do any additional setup after loading the view.
    }
    
    func messageData(data: UserBioDetail) {
        ProgressHUD.dismiss()
        
        userBioArr = data
        
        DispatchQueue.main.async {
            self.userImgView.load(urlString: self.userBioArr.avatar_url!)
            self.followerCountLbl.text = "\(self.userBioArr.followers ?? 100)"
            self.followingCountLbl.text = "\(self.userBioArr.following ?? 100)"
            self.noteImgView.load(urlString: self.userBioArr.avatar_url!)
            self.usernameLbl.text = self.userBioArr.name
            self.companyLbl.text = self.userBioArr.company
            self.blogLbl.text = self.userBioArr.blog
            self.noteTextLbl.text = self.userBioArr.bio
        }
   
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK : Button Actions
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
