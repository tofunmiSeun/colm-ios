//
//  Post.swift
//  mitri
//
//  Created by Tofunmi Ogungbaigbe on 03/12/2022.
//

struct Post: Identifiable, Codable {
    var id: String;
    var content: String;
    var authorUsername: String;
    var authorName: String?;
    var likedByProfile: Bool;
    
    static var mock = Post(id: "id_qww", content: "Mitri, not just another bird app", authorUsername: "tofunmi",
                           authorName: "Oluwaseun", likedByProfile: true)
    
}
