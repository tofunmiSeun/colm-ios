//
//  Notification.swift
//  mitri
//
//  Created by Tofunmi Ogungbaigbe on 21/12/2022.
//

struct Notification: Identifiable, Codable {
    
    enum NotificationType: String, Codable {
        case postReaction = "POST_REACTION"
        case postReply = "POST_REPLY"
        case follow = "FOLLOW"
    }
    
    var id: String;
    var happenedOnMilliseconds: Int;
    var actor: String;
    var actorUsername: String;
    var type: NotificationType;
    var recipientHasBeenNotified: Bool;
    var postId: String?;
    var replyId: String?;
    
    static let mock = Notification(id: "notif_11", happenedOnMilliseconds: 1671065342710,
                                   actor: "profileId_33", actorUsername: "tofunmi",
                                   type: .follow, recipientHasBeenNotified: false)
}
