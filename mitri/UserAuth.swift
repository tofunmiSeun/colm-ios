//
//  UserAuth.swift
//  mitri
//
//  Created by Tofunmi Ogungbaigbe on 23/11/2022.
//

import Foundation
import GoogleSignIn

struct UserAuth {
    
    struct UserSetupResponse: Decodable {
        let userId: String
        let email: String
        let name: String
        let isExistingUser: Bool
        let profiles: [Profile]
        
        struct Profile: Decodable {
            let id: String
            let username: String
            let name: String?
            let description: String?
        }
    }
    
    static let signInConfig = GIDConfiguration(clientID: ProcessInfo.processInfo.environment["google_signin_client_id"]!)
    
    static func maybeSignInUserInBackground(completionHandler: @escaping (UserSetupResponse) -> Void) async {
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn {user, error in
                if error != nil {
                    print("Error")
                }
                onGoogleUserSignedIn(user: user) { userSetupResponse in
                    completionHandler(userSetupResponse)
                }
            }
        }
    }
    
    static func authUserViaGoogle(completionHandler: @escaping (UserSetupResponse) -> Void) {
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {return}
        
        GIDSignIn.sharedInstance.signIn(
            with: signInConfig,
            presenting: presentingViewController) { user, error in
                if error != nil {
                    print("Error")
                }
                onGoogleUserSignedIn(user: user) { userSetupResponse in
                    completionHandler(userSetupResponse)
                }
            }
    }
    
    static func onGoogleUserSignedIn(user: Optional<GIDGoogleUser>, completionHandler: @escaping (UserSetupResponse) -> Void) {
        guard let user = user else { return }
        
        user.authentication.do { authentication, error in
            guard error == nil else { return }
            guard let authentication = authentication else { return }
            
            let authToken = authentication.idToken!
            Api.post(uri: "/user/setup/google", body: ["token": authToken]) {data in
                if let response: UserSetupResponse = Api.Utils.decodeAsObject(data: data) {
                    //TODO: save user information
                    completionHandler(response)
                }
            }
        }
    }
}
