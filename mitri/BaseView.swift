//
//  BaseView.swift
//  mitri
//
//  Created by Tofunmi Ogungbaigbe on 29/11/2022.
//

import SwiftUI



struct BaseView: View {
    @State private var initialisingPage: Bool = true
    @StateObject var loggedInUserState = LoggedInUserState()
    
    var body: some View {
        VStack {
            if initialisingPage {
                Text("Splash...")
            } else {
                if loggedInUserState.isLoggedIn() {
                    LoggedInUserView()
                } else if loggedInUserState.isUserSetup() {
                    ProfileSetupView(loggedInUserState: loggedInUserState)
                } else {
                    LoginView(loggedInUserState: loggedInUserState)
                }
            }
        }.task {
            await checkUserAuthStatus()
        }
    }
    
    func checkUserAuthStatus() async {
        withAnimation(.linear(duration: 2)) {
            initialisingPage = false
        }
    }
}

struct BaseView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView()
    }
}
