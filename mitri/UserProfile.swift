//
//  UserProfile.swift
//  mitri
//
//  Created by Tofunmi Ogungbaigbe on 30/11/2022.
//

import Foundation
import SwiftUI

struct UserProfile {
    let userId: String
    let profileId: String
    let username: String
    let name: String
    let email: String
    
    static func currentLoggedInUser() -> UserProfile {
        @AppStorage("userId") var userId: String = ""
        @AppStorage("profileId") var profileId: String = ""
        @AppStorage("username") var username: String = ""
        @AppStorage("name") var name: String = ""
        @AppStorage("email") var email: String = ""
        
        return UserProfile(userId: userId, profileId: profileId, username: username, name: name, email: email)
    }
}
