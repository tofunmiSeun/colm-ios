//
//  StartChatView.swift
//  mitri
//
//  Created by Tofunmi Ogungbaigbe on 20/04/2023.
//

import SwiftUI

struct StartChatView: View {
    @EnvironmentObject var loggedInUser: UserProfile

    var onProfilesSelected: ([Profile]) -> Void
    
    @State private var profiles = [Profile]()
    @State private var searchQuery = ""
    @State private var filteredProfiles = [Profile]()
    @State private var selection: String?
    
    var body: some View {
        NavigationView {
            List(filteredProfiles, id: \.id, selection: $selection) { profile in
                HStack(spacing: 12) {
                    Image(systemName: selection == profile.id ? "checkmark.circle.fill"
                          : "checkmark.circle").foregroundColor(Color.accentColor)
                    ProfileListItem(username: profile.username, name: profile.name)
                }
            }
            .listStyle(.plain)
            .navigationTitle("DM someone new")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                getProfilesEligibleForDMs()
            }
            .searchable(text: $searchQuery)
            .onChange(of: searchQuery) { _ in
                filterProfiles()
            }
            .toolbar {
                Button {
                    let selectedProfiles = profiles.filter { [selection!].contains($0.id) }
                    onProfilesSelected(selectedProfiles)
                } label: {
                    Text("Next")
                }.disabled(selection == nil)
            }
        }
    }
    
    func getProfilesEligibleForDMs() {
        Api.get(uri: "/profile/followers?profileId=\(loggedInUser.profileId)") { data in
            DispatchQueue.main.async {
                if let response: [Profile] = Api.Utils.decodeAsObject(data: data) {
                    profiles = response
                    filterProfiles()
                }
            }
        }
    }
    
    func filterProfiles() {
        if searchQuery.isEmpty {
            filteredProfiles = profiles
        } else {
            filteredProfiles = profiles.filter {
                $0.username.localizedCaseInsensitiveContains(searchQuery)
            }
        }
    }
}

struct StartChatView_Previews: PreviewProvider {
    static var previews: some View {
        StartChatView(onProfilesSelected: {_ in
            
        })
    }
}
