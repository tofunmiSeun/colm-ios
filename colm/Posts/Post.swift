//
//  Post.swift
//  mitri
//
//  Created by Tofunmi Ogungbaigbe on 03/12/2022.
//

struct MediaContent: Identifiable, Codable {
    var id: String;
    var mimeType: String;
    
    static var mocks = [MediaContent(id: "id_eee", mimeType: "image/jpeg"),
                        MediaContent(id: "id_yadayada", mimeType: "image/jpeg")]
}

struct Post: Identifiable, Codable {
    var id: String;
    var author: String;
    var content: String?;
    var mediaContents: [MediaContent]?;
    var authorUsername: String;
    var authorName: String?;
    var likedByProfile: Bool;
    var createdAtMilliseconds: Int?;
    
    
    static var mock = Post(id: "id_qww", author: "auth_dd", content: "Mitri, not just another bird app",
                           authorUsername: "tofunmi",  authorName: "Oluwaseun", likedByProfile: true,
                           createdAtMilliseconds: 1671065342710)
    
    static var mockWithMediaContent = Post(id: "id_qww", author: "auth_dd", content: "Mitri, not just another bird app",
                                           mediaContents: MediaContent.mocks,
                                           authorUsername: "tofunmi", authorName: "Oluwaseun", likedByProfile: true,
                                           createdAtMilliseconds: 1671065342710)
    
}
