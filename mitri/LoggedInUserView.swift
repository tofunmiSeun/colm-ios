//
//  LoggedInUserView.swift
//  mitri
//
//  Created by Tofunmi Ogungbaigbe on 30/11/2022.
//

import SwiftUI

struct LoggedInUserView: View {
    private var currentLoggedInUser = UserProfile.currentLoggedInUser()
    
    var body: some View {
        VStack {
            Text("Hello \(currentLoggedInUser.name)")
            Text("Your username is \(currentLoggedInUser.username)")
        }
    }
}

struct LoggedInUserView_Previews: PreviewProvider {
    static var previews: some View {
        LoggedInUserView()
    }
}
