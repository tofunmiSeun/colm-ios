//
//  ProfileSetupView.swift
//  mitri
//
//  Created by Tofunmi Ogungbaigbe on 30/11/2022.
//

import SwiftUI

struct ProfileSetupView: View {
    @EnvironmentObject var loggedInUserState: LoggedInUserState
    
    @State private var username = ""
    @State private var lastCheckedUsername = ""
    @State private var checkedUsernameIsValid = false
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Finish account setup")
                    .font(.title)
                    .padding(.bottom, 4)
                    .padding(.top, 16)
                
                Text("Hello \(loggedInUserState.name), We just need you to pick a username and you're all setup!")
                    .foregroundColor(.secondary)
                    .padding(.bottom, 50)
                
                TextField("Username (at least 3 characters)", text: $username)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .onChange(of: username) { newValue in
                        if newValue.count >= 3 {
                            checkIfUsernameIsAvailable(newValue)
                        }
                    }
                
                if(username.count > 0 && username == lastCheckedUsername) {
                    VStack {
                        if checkedUsernameIsValid {
                            Text("Available")
                                .font(.caption2)
                                .foregroundColor(.green)
                            
                        } else {
                            Text("Taken")
                                .font(.caption2)
                                .foregroundColor(.red)
                            
                        }
                    }.padding(.top, 4)
                }
            }
            Spacer()
            Button {
                Task {
                    setupUserProfile()
                }
            } label: {
                Text("Continue")
                    .padding(4)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(setUpProfileButtonIsDisabled())
            
        }.padding()
    }
    
    func checkIfUsernameIsAvailable(_ username: String) {
        Api.get(uri: "/profile/available?username=\(username)") { data in
            guard let isAvailable = Bool(Api.Utils.decodeAsString(data: data)) else {
                print("Failed to convert")
                return
            }
            
            lastCheckedUsername = username
            checkedUsernameIsValid = isAvailable
        }
    }
    
    func setUpProfileButtonIsDisabled() -> Bool {
        return username != lastCheckedUsername || !checkedUsernameIsValid
    }
    
    func setupUserProfile() {
        Api.post(uri: "/profile?username=\(username)") { data in
            let profileId = Api.Utils.decodeAsString(data: data)
            onProfileSuccessfullySetup(id: profileId, username: username)
        }
    }
    
    func onProfileSuccessfullySetup(id: String, username: String) {
        loggedInUserState.saveProfileDetails(profileId: id, username: username)
    }
}

struct ProfileSetupView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSetupView()
            .environmentObject(LoggedInUserState())
    }
}
