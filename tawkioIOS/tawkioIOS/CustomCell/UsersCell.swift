//
//  UsersCell.swift
//  TawkioIOS
//
//  Created by Mac on 29/04/21.
//

import UIKit

class UsersCell: UITableViewCell {

    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var detailLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.userImgView.layer.cornerRadius = self.userImgView.frame.size.width/2
        // Configure the view for the selected state
    }
    
}
