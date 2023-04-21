import Foundation

struct ChatMessage: Identifiable, Equatable, Codable {
    var id: String;
    var chatId: String;
    var sender: String;
    var sentOn: String;
    var textContent: String;
    var seenBy: [String];
    
    static func == (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
        return lhs.id == rhs.id
    }
    
    static let mock = ChatMessage(id: "chat_msg_222", chatId: Chat.mock.id,
                                  sender: Profile.mock.id,
                                  sentOn: "1671065342710",
                                  textContent: "Jerrrryyyyyy, Helloooo!!", seenBy: [String]())
}
