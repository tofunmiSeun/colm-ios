import SwiftUI

struct ChatMessagesView: View {
    @EnvironmentObject var loggedInUser: UserProfile
    @Binding var navPath: NavigationPath
    
    @State var chat: Chat
    @State var chatMessages = [ChatMessage]()
    
    @State private var newChatMessage = ""
    @FocusState private var focusOnTextField: Bool
    
    var body: some View {
        VStack {
            ScrollViewReader { scrollView in
                ScrollView(showsIndicators: false) {
                    LazyVStack(alignment: .leading, spacing: 0) {
                        ForEach(chatMessages.reversed()) { message in
                            ChatMessageRow(chatMessage: message)
                                .id(message.id)
                        }
                    }
                    .padding()
                }
                .onChange(of: chatMessages) { _ in
                    if chatMessages.count > 0 {
                        scrollView.scrollTo(chatMessages.first!.id)
                    }
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
            Divider()
            ZStack {
                HStack {
                    TextField(text: $newChatMessage) {
                        Text("Say something...")
                    }
                    .appTextFieldStyle()
                    .focused($focusOnTextField)
                    
                    Button {
                        if chat.id != Chat.templateId {
                            sendMessage()
                        } else {
                            createChatThenSendMessage()
                        }
                    } label: {
                        Text("Send")
                    }
                    .appButtonStyle()
                    .disabled(newChatMessage.count == 0)
                    
                }
            }.padding(8)
        }
        .navigationTitle(chat.title(loggedInUserProfileId: loggedInUser.profileId))
        .onAppear {
            if chat.id != Chat.templateId {
                loadChatMessages()
            }
        }
        .toolbar {
            if chat.id != Chat.templateId {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(role: .destructive) {
                            leaveChat()
                        } label: {
                            Text("Leave chat")
                        }
                    } label: {
                        Label("Actions", systemImage: "ellipsis")
                            .labelStyle(.iconOnly)
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
    
    func loadChatMessages() {
        Api.get(uri: "/chat/\(chat.id)/message?profileId=\(loggedInUser.profileId)") { data in
            DispatchQueue.main.async {
                if let response: [ChatMessage] = Api.Utils.decodeAsObject(data: data) {
                    chatMessages = response
                }
            }
        }
    }
    
    func createChatThenSendMessage() {
        let inviteesProfileIds = chat.participants.map { $0.id }.joined(separator: "&")
        Api.post(uri: "/chat?profileId=\(loggedInUser.profileId)&invitees=\(inviteesProfileIds)") { data in
            DispatchQueue.main.async {
                if let response: Chat = Api.Utils.decodeAsObject(data: data) {
                    chat = response
                    sendMessage()
                }
            }
        }
    }
    
    func sendMessage() {
        var uploads = [UploadableMediaContent]()
        uploads.append(UploadableMediaContent(name: "text", data: Data(newChatMessage.utf8)))
        
        Api.upload(uri: "/chat/\(chat.id)/message?profileId=\(loggedInUser.profileId)",
                   uploads: uploads) { data in
            DispatchQueue.main.async {
                newChatMessage = ""
                loadChatMessages()
            }
        }
    }
    
    func leaveChat() {
        Api.delete(uri: "/chat/\(chat.id)/leave?profileId=\(loggedInUser.profileId)") { data in
            DispatchQueue.main.async {
                navPath.removeLast()
            }
        }
    }
    
    func hideKeyboard() {
        focusOnTextField = false
    }
}

struct ChatMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ChatMessagesView(navPath: Binding.constant(NavigationPath()), chat: Chat.mock, chatMessages: [ChatMessage.mock])
                .environmentObject(UserProfile.mockUser())
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
