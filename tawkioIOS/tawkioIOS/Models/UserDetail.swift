//
//  Users.swift
//  TawkioIOS
//
//  Created by Mac on 29/04/21.
//

import Foundation

struct UserDetail : Codable{
    var login: String? = nil
    var id: Int? = nil
    var node_id: String? = nil
    var avatar_url: String? = nil

}

struct UserBioDetail : Codable{
    var login: String? = nil
    var id: Int? = nil
    var node_id: String? = nil
    var avatar_url: String? = nil
    var name: String? = nil
    var company: String? = nil
    var blog: String? = nil
    var bio: String? = nil
    var followers: Int? = nil
    var following: Int? = nil
}
