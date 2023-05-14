//
//  ProfileListItem.swift
//  mitri
//
//  Created by Tofunmi Ogungbaigbe on 20/04/2023.
//

import SwiftUI

struct ProfileListItem: View {
    var username: String
    var name: String?
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .foregroundColor(.gray.opacity(0.8))
                .scaledToFit()
                .frame(width: 40)
            VStack(alignment: .leading) {
                Text(username).styleAsUsername()
                if let providedName = name {
                    Text(providedName)
                }
            }
        }
    }
}

struct ProfileListItem_Previews: PreviewProvider {
    static var previews: some View {
        ProfileListItem(username: "magic-bot", name: "Botty boy")
    }
}
