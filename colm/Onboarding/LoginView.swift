//
//  LoginView.swift
//  mitri
//
//  Created by Tofunmi Ogungbaigbe on 18/11/2022.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var loggedInUserState: LoggedInUserState
    
    var body: some View {
        VStack {
            VStack(spacing: 4) {
                Text("Mitri")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                Text("Not just another bird app")
                    .font(.title)
            }.padding(.top, UIScreen.main.bounds.midY / 4)
            Spacer()
            VStack {
                Button {
                    onGoogleSignInButtonClicked()
                } label: {
                    Label {
                        Text("Continue with Google")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    } icon: {
                        Image("GoogleLogo")
                            .resizable()
                            .frame(width: 32.0, height: 32.0)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: .infinity)
                        .stroke(.black))
                    .background(.white)
                    .cornerRadius(.infinity)
                }
            }.padding(.bottom, 10)
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
        LoginView()
            .environmentObject(LoggedInUserState())
    }
}

