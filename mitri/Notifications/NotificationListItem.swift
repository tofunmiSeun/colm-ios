//
//  NotificationListItem.swift
//  mitri
//
//  Created by Tofunmi Ogungbaigbe on 21/12/2022.
//

import SwiftUI

struct NotificationListItem: View {
    @EnvironmentObject var loggedInUser: UserProfile
    @State var notification: Notification
    
    var body: some View {
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
            ElapsedTimeView(elapsedTimeMilliseconds: notification.happenedOnMilliseconds)
        }
        .padding()
        .background(notification.recipientHasBeenNotified ?
            .white : .blue.opacity(0.1))
        .onAppear {
            markNotificationAsRead()
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
    
    func markNotificationAsRead() {
        if notification.recipientHasBeenNotified {
            return
        }
        
        let uri = "/notification/\(notification.id)/mark-as-read?profileId=\(loggedInUser.profileId)"
        Api.post(uri: uri) { _ in
            DispatchQueue.main.async {
                withAnimation(.easeOut.delay(1)) {
                    notification.recipientHasBeenNotified = true
                }
            }
        }
    }
}

struct NotificationListItem_Previews: PreviewProvider {
    static var previews: some View {
        NotificationListItem(notification: Notification.mock)
            .environmentObject(UserProfile.mockUser())
        
    }
}
