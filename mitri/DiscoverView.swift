//
//  DiscoverView.swift
//  mitri
//
//  Created by Tofunmi Ogungbaigbe on 05/12/2022.
//

import SwiftUI

enum DiscoverViewTab: String {
    case topPosts;
    case people;
    
    var labelText: String {
        switch self {
        case .topPosts:
            return "Top posts"
        case .people:
            return "People"
        }
    }
}

struct DiscoverView: View {
    @State private var selectedTab: DiscoverViewTab = .topPosts
    private var tabs: [DiscoverViewTab] = [.topPosts, .people]
    
    var body: some View {
        VStack {
            HStack(spacing: 12) {
                ForEach(tabs, id: \.self) { tab in
                    Text("\(tab.labelText)")
                        .onTapGesture {
                            selectedTab = .topPosts
                        }
                        .fontWeight(.semibold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .foregroundColor(textColorForTabLabel(tab))
                        .background(.gray.opacity(backgrounOpacityForTabLabel(tab)))
                        .cornerRadius(25)
                }
                Spacer()
            }.padding()
            TabView(selection: $selectedTab) {
                Text("Hello, World!").tag(DiscoverViewTab.topPosts)
                Text("Bye, World!").tag(DiscoverViewTab.people)
            }.tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
    
    func textColorForTabLabel(_ tabForLabel: DiscoverViewTab) -> Color {
        return tabForLabel == selectedTab ? .black : .gray
    }
    
    func backgrounOpacityForTabLabel(_ tabForLabel: DiscoverViewTab) -> Double {
        return tabForLabel == selectedTab ? 0.25 : 0
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
