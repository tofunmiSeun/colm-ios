import SwiftUI

extension Array where Element: Comparable {
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
}

struct ChatsView: View {
    @EnvironmentObject var loggedInUser: UserProfile
    @Binding var navPath: NavigationPath
    private let webSocketManager = WebSocketManager(uri: "/chat-update?profileId=\(UserProfile.currentLoggedInUser().profileId)")
    
    @State private var chats = [Chat]()
    @State private var showStartChatView = false
    
    var body: some View {
        NavigationView {
            List(chats) { chat in
                ChatListItem(chat: chat).onTapGesture {
                    navPath.append(chat)
                }
            }
            .listStyle(.plain)
            .refreshable {
                loadChats()
            }
            .onAppear {
                loadChats()
                webSocketManager.setCallBack(loadChats)
            }
            .navigationTitle("Chats")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showStartChatView = true
                    } label: {
                        Label("New chat", systemImage: "plus")
                    }
                }
            }
            .navigationDestination(for: Chat.self) { c in
                ChatMessagesView(navPath: $navPath, webSocketManager: webSocketManager, chat: c)
            }
            .sheet(isPresented: $showStartChatView) {
                StartChatView(onProfilesSelected: { otherParticipants in
                    let chatToOpen = getChatToOpen(otherParticipants: otherParticipants)
                    showStartChatView = false
                    navPath.append(chatToOpen)
                })
            }
        }
    }
    
    
    func loadChats() {
        Api.get(uri: "/chat?profileId=\(loggedInUser.profileId)") { data in
            DispatchQueue.main.async {
                if let response: [Chat] = Api.Utils.decodeAsObject(data: data) {
                    chats = response
                }
            }
        }
    }
    
    func getChatToOpen(otherParticipants: [Profile]) -> Chat {
        let otherParticipantsProfileId = otherParticipants.map { $0.id }
        let allParticipants = otherParticipantsProfileId + [loggedInUser.profileId]
        let existingChat = chats.first { chat in
            let participantsProfileIds = chat.participants.map { $0.id }
            return participantsProfileIds.containsSameElements(as: allParticipants)
        }
        
        return existingChat ?? newChatTemplate(otherParticipants: otherParticipants)
    }
    
    func newChatTemplate(otherParticipants: [Profile]) -> Chat {
        let creatorProfile = Profile(id: loggedInUser.profileId, username: loggedInUser.username)
        return Chat.templateForNewChat(creator: creatorProfile, invitees: otherParticipants)
    }
}

struct ChatsView_Previews: PreviewProvider {
    static var previews: some View {
        ChatsView(navPath: Binding.constant(NavigationPath()))
            .environmentObject(UserProfile.mockUser())
    }
}
