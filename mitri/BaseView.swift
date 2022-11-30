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
                    Text("Home")
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
        try? await Task.sleep(nanoseconds: 5_000_000_000)
        initialisingPage = false
    }
}

struct BaseView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView()
    }
}
