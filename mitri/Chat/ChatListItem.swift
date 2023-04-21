import SwiftUI

struct ChatListItem: View {
    @EnvironmentObject var loggedInUser: UserProfile
    var chat: Chat
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 2) {
                Text(chat.title(loggedInUserProfileId: loggedInUser.profileId))
                if chat.lastMessageContent != nil {
                    Text(chat.lastMessageContent!).fontWeight(.thin)
                }
            }
            Spacer()
            VStack(alignment: .trailing) {
                ElapsedTimeView(elapsedTimeMilliseconds: chat.lastActivityTimeMilliseconds).font(.footnote)
            }
        }
        // This allows the whole area clickable
        .contentShape(Rectangle())
    }
}

struct ChatListItem_Previews: PreviewProvider {
    static var previews: some View {
        ChatListItem(chat: Chat.mock)
            .environmentObject(UserProfile.mockUser())
            .previewLayout(PreviewLayout.fixed(width: 200, height: 40))
    }
}
