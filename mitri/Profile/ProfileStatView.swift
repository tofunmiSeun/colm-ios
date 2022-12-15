//
//  ProfileStatView.swift
//  mitri
//
//  Created by Tofunmi Ogungbaigbe on 15/12/2022.
//

import SwiftUI

struct ProfileStatView: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack(spacing: 4) {
            Text(value).fontWeight(.semibold)
            Text(label).fontWeight(.thin)
        }
        .padding(4)
        .cornerRadius(16)
        .background(.thickMaterial)
    }
}

struct ProfileStatView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileStatView(label: "Followers", value: "10")
    }
}
