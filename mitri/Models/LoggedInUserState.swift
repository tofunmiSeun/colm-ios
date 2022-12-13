//
//  LoggedInUserProfile.swift
//  mitri
//
//  Created by Tofunmi Ogungbaigbe on 30/11/2022.
//

import Foundation
import SwiftUI

class LoggedInUserState: ObservableObject {
    @AppStorage("userId") var userId: String?
    @AppStorage("profileId") var profileId: String?
    @AppStorage("username") var username: String = ""
    @AppStorage("email") var email: String = ""
    @AppStorage("name") var name: String = ""
    
    func isLoggedIn() -> Bool {
        return isUserSetup() && isProfileSetUp()
    }
    
    func isUserSetup() -> Bool {
        return userId != nil
    }
    
    func isProfileSetUp() -> Bool {
        return profileId != nil
    }
    
    func clearSavedUserProfile() {
        self.userId = nil
        self.email = ""
        self.name = ""
        self.profileId = nil
        self.username = ""

    }
    
    func saveUserDetails(userId: String, email: String, name: String) {
        DispatchQueue.main.async {
            self.userId = userId
            self.email = email
            self.name = name
        }
    }
    
    func saveProfileDetails(profileId: String, username: String) {
        DispatchQueue.main.async {
            self.profileId = profileId
            self.username = username
        }
    }
}
