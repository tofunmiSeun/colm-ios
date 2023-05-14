//
//  LoggedInUserProfile.swift
//  mitri
//
//  Created by Tofunmi Ogungbaigbe on 30/11/2022.
//

import Foundation
import SwiftUI

enum AuthState {
    case none
    case authorized
    case registered
}

enum StorageKeys: String, CaseIterable {
    case userId = "userId";
    case profileId = "profileId";
    case username = "username";
    case email = "email";
    case name = "name";
}

class LoggedInUserState: ObservableObject {
    @AppStorage(StorageKeys.userId.rawValue) var userId: String?
    @AppStorage(StorageKeys.profileId.rawValue) var profileId: String?
    @AppStorage(StorageKeys.username.rawValue) var username: String = ""
    @AppStorage(StorageKeys.email.rawValue) var email: String = ""
    @AppStorage(StorageKeys.name.rawValue) var name: String = ""
    
    @Published var authState: AuthState = .none
    
    init() {
        self.updateAuthState()
    }
    
    func saveUserDetails(userId: String, email: String, name: String) {
        DispatchQueue.main.async {
            self.userId = userId
            self.email = email
            self.name = name
            self.updateAuthState()
        }
    }
    
    func saveProfileDetails(profileId: String, username: String) {
        DispatchQueue.main.async {
            self.profileId = profileId
            self.username = username
            self.updateAuthState()
        }
    }
    
    func clearSavedUserProfile() {
        DispatchQueue.main.async {
            self.userId = nil
            self.profileId = nil
            self.username = ""
            self.name = ""
            self.email = ""
            self.updateAuthState()
        }
    }
    
    func updateAuthState() {
        if userId != nil && profileId != nil {
            authState = .registered
        } else if userId != nil {
            authState = .authorized
        } else {
            authState = .none
        }
    }
}
