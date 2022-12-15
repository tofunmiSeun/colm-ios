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
                switch loggedInUserState.authState {
                case .none:
                    LoginView()
                case .authorized:
                    ProfileSetupView()
                case .registered:
                    LoggedInUserView()
                }
            }
        }
        .environmentObject(loggedInUserState)
        .task {
            withAnimation(.linear(duration: 2)) {
                initialisingPage = false
            }
        }
    }
}

struct BaseView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView()
    }
}
