//
//  RowsOfPosts.swift
//  mitri
//
//  Created by Tofunmi Ogungbaigbe on 15/12/2022.
//

import SwiftUI

struct RowsOfPosts: View {
    let posts: [Post]
    let onPostDeletion: () -> Void
    
    var body: some View {
        LazyVStack(alignment: .leading) {
            ForEach(posts) { post in
                PostListItem(post: post, onPostDeletion: onPostDeletion)
            }
        }
    }
}

struct RowsOfPosts_Previews: PreviewProvider {
    static var previews: some View {
        RowsOfPosts(posts: [Post.mock, Post.mock], onPostDeletion: {return})
    }
}
