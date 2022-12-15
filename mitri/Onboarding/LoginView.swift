//
//  LoginView.swift
//  mitri
//
//  Created by Tofunmi Ogungbaigbe on 18/11/2022.
//

import SwiftUI
import GoogleSignInSwift

struct LoginView: View {
    @ObservedObject var loggedInUserState: LoggedInUserState
    
    var body: some View {
        VStack {
            VStack {
                Text("Mitri")
                    .font(.title)
                Text("Not just another bird app")
                    .font(.subheadline)
            }.padding(.top, 100)
            Spacer()
            VStack {
                GoogleSignInButton(action: onGoogleSignInButtonClicked)
            }.padding(.bottom, 100)
        }.padding()
    }
    
    func onGoogleSignInButtonClicked() {
        UserAuth.authUserViaGoogle { userSetupResponse in
            onUserSuccessfullySetup(userSetupResponse: userSetupResponse)
        }
    }
    
    func onUserSuccessfullySetup(userSetupResponse: UserAuth.UserSetupResponse) {
        loggedInUserState.saveUserDetails(userId: userSetupResponse.userId, email: userSetupResponse.email, name: userSetupResponse.name)
        if userSetupResponse.profiles.count > 0 {
            let profileId = userSetupResponse.profiles[0].id
            let username = userSetupResponse.profiles[0].username
            loggedInUserState.saveProfileDetails(profileId: profileId, username: username)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(loggedInUserState: LoggedInUserState())
    }
}
