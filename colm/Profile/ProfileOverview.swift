//
//  ProfileOverview.swift
//  mitri
//
//  Created by Tofunmi Ogungbaigbe on 15/12/2022.
//

import Foundation

struct ProfileOverview: Identifiable, Codable {
    var id: String;
    var username: String;
    var name: String?;
    var description: String?;
    var postCount: Int;
    var followingCount: Int;
    var followersCount: Int;
    var likesCount: Int;
    var requesterFollowsProfile: Bool;
    
    static var mock = ProfileOverview(id: "aaa_yyy", username: "tofunmi_og",name: "Tofunmi", postCount: 60,
                                      followingCount: 965, followersCount: 1138, likesCount: 722,
                                      requesterFollowsProfile: true)
}
