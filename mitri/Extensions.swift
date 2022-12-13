//
//  Extensions.swift
//  mitri
//
//  Created by Tofunmi Ogungbaigbe on 09/12/2022.
//

import SwiftUI

extension View {
    func imageViewHeight(imagesCount: Int) -> some View {
        self
            .frame(height: imagesCount == 1 ? 450 : 200)
    }
}

extension Text {
    func promptText() -> Text {
        self
            .font(.title2)
    }
    
    func styleAsUsername() -> Text {
        self
            .fontWeight(.semibold)
    }
    
    func styleAsPostText() -> Text {
        self
            .fontWeight(.thin)
    }
}

extension TabView {
    func styleAsMediaContentCarousel() -> some View {
        self
            .tabViewStyle(.page(indexDisplayMode: .always))
            .frame(height: 250)
            .background(.gray)
            .background(.ultraThinMaterial)
            .cornerRadius(4)
    }
}
