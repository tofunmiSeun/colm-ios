//
//  NotificationsView.swift
//  mitri
//
//  Created by Tofunmi Ogungbaigbe on 15/12/2022.
//

import SwiftUI

struct Notification: Identifiable, Codable {
    
    enum NotificationType: String, Codable {
        case postReaction = "POST_REACTION"
        case postReply = "POST_REPLY"
        case follow = "FOLLOW"
    }
    
    var id: String;
    var happenedOn: String;
    var actor: String;
    var actorUsername: String;
    var type: NotificationType;
    var recipientHasBeenNotified: Bool;
    var postId: String?;
    var replyId: String?;
}

struct NotificationsView: View {
    @EnvironmentObject var loggedInUser: UserProfile
    @State private var notifications = [Notification]()
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(notifications) { notification in
                        HStack(spacing: 4) {
                            NavigationLink {
                                ProfileView(profileId: notification.actor)
                            } label: {
                                Text(notification.actorUsername)
                                    .fontWeight(.semibold)
                            }
                            .buttonStyle(.plain)
                            Text(getDescription(for: notification))
                            Spacer()
                        }
                        .padding()
                        .background(notification.recipientHasBeenNotified ?
                            .white : .blue.opacity(0.1))
                        .onAppear {
                            markNotificationAsRead(n: notification)
                        }
                        Divider()
                    }
                }
            }
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .refreshable {
                getNotificationHistory()
            }
            .task {
                getNotificationHistory()
            }
        }
    }
    
    func getNotificationHistory() {
        Api.get(uri: "/notification?profileId=\(loggedInUser.profileId)") { data in
            DispatchQueue.main.async {
                if let response: [Notification] = Api.Utils.decodeAsObject(data: data) {
                    notifications = response
                }
            }
        }
    }
    
    func getDescription(for notification: Notification) -> String {
        switch notification.type {
        case .follow:
            return "followed you"
        case .postReaction:
            return "liked your posts"
        case .postReply:
            return "replied to your post"
        }
    }
    
    func markNotificationAsRead(n: Notification) {
        if n.recipientHasBeenNotified {
            return
        }
        
        let uri = "/notification/\(n.id)/mark-as-read?profileId=\(loggedInUser.profileId)"
        Api.post(uri: uri) { _ in
            DispatchQueue.main.async {
                withAnimation(.easeIn.delay(0.5)) {
                    //n.recipientHasBeenNotified = true
                }
            }
        }
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
            .environmentObject(UserProfile.mockUser())
    }
}
