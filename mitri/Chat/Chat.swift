import Foundation

struct Chat: Identifiable, Hashable, Codable {
    var id: String;
    var creator: Profile?
    var participants: [Profile];
    var lastActivityTimeMilliseconds: Int;
    var lastMessageContent: String?;
    
    func title(loggedInUserProfileId: String) -> String {
        let otherParticipantNames = participants.filter {$0.id != loggedInUserProfileId}.map {$0.username}
        return otherParticipantNames.compactMap { $0 }.joined(separator: ", ")
    }
    
    static let templateId = "CHAT_TEMPLATE_ID"
    
    static func templateForNewChat(creator: Profile, invitees: [Profile]) -> Chat {
        return Chat(id: templateId, creator: creator, participants: invitees, lastActivityTimeMilliseconds: 0)
    }
    
    static let mock = Chat(id: "chat_11", creator: Profile.mock,
                           participants: [Profile.mock, Profile.mock_2],
                           lastActivityTimeMilliseconds: 1671065342710,
                           lastMessageContent: "Jerrrryyyyyy, Helloooo!!")
}
