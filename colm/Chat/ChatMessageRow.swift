import SwiftUI

struct ChatMessageRow: View {
    @EnvironmentObject var loggedInUser: UserProfile
    @State var chatMessage: ChatMessage
    
    var rowBackgrounColor: Color {
        chatMessage.sender != loggedInUser.profileId ? Color.blue : Color.green
    }
    
    var body: some View {
        HStack {
            if chatMessage.sender == loggedInUser.profileId {
                Spacer()
            }
            
            ZStack {
                Text(chatMessage.textContent)
            }
            .padding(8)
            .background(rowBackgrounColor.opacity(0.4))
            .cornerRadius(8)
            
            if chatMessage.sender != loggedInUser.profileId {
                Spacer()
            }
        }.padding(4)
    }
}

struct ChatMessageRow_Previews: PreviewProvider {
    static var previews: some View {
        ChatMessageRow(chatMessage: ChatMessage.mock)
            .environmentObject(UserProfile.mockUser())
    }
}
