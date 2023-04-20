import SwiftUI

struct NotificationsView: View {
    @EnvironmentObject var loggedInUser: UserProfile
    @State private var notifications = [Notification]()
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(notifications) { notification in
                        NotificationListItem(notification: notification)
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
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
            .environmentObject(UserProfile.mockUser())
    }
}
