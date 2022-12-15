//
//  DiscoverView.swift
//  mitri
//
//  Created by Tofunmi Ogungbaigbe on 05/12/2022.
//

import SwiftUI

struct DiscoverView: View {
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
    
    @State private var selectedTab: DiscoverViewTab = .topPosts
    private var tabs: [DiscoverViewTab] = [.topPosts, .people]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                HStack(spacing: 4) {
                    ForEach(tabs, id: \.self) { tab in
                        Text("\(tab.labelText)")
                            .onTapGesture {
                                selectedTab = tab
                            }
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .foregroundColor(textColorForTabLabel(tab))
                            .background(.gray.opacity(backgrounOpacityForTabLabel(tab)))
                            .cornerRadius(25)
                    }
                    Spacer()
                }
                TabView(selection: $selectedTab) {
                    PostsToDiscoverView().tag(DiscoverViewTab.topPosts)
                    ProfilesToDiscoverView().tag(DiscoverViewTab.people)
                }.tabViewStyle(.page(indexDisplayMode: .never))
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Discover")
        }
    }
    
    func textColorForTabLabel(_ tabForLabel: DiscoverViewTab) -> Color {
        return tabForLabel == selectedTab ? .primary : .gray
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
