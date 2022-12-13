//
//  UserProfile.swift
//  mitri
//
//  Created by Tofunmi Ogungbaigbe on 30/11/2022.
//

import Foundation
import SwiftUI

class UserProfile: ObservableObject {
    let userId: String
    let profileId: String
    let username: String
    let name: String
    let email: String
    
    init(userId: String, profileId: String, username: String, name: String, email: String) {
        self.userId = userId
        self.profileId = profileId
        self.username = username
        self.name = name
        self.email = email
    }
    
    static func currentLoggedInUser() -> UserProfile {
        @AppStorage("userId") var userId: String = ""
        @AppStorage("profileId") var profileId: String = ""
        @AppStorage("username") var username: String = ""
        @AppStorage("name") var name: String = ""
        @AppStorage("email") var email: String = ""
        
        return UserProfile(userId: userId, profileId: profileId, username: username, name: name, email: email)
    }
    
    static func mockUser() -> UserProfile {
        return UserProfile(userId: "user123", profileId: "profile123", username: "tofunmi_og", name: "Tofunmi", email: "tofunmiseun@gmail.com")
    }
}
