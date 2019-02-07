//
//  Post.swift
//  Instagram
//
//  Created by Ronen on 03/01/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import FirebaseAuth

class Post {
    var caption: String?
    var photoUrl: String?
    var uid: String?
    var id: String?
    var likeCount: Int?
    var likes: Dictionary<String, Any>?
    var isLiked: Bool?
    var ratio:CGFloat?
    var timestamp: Int?
}

// Extension to Post which will replace inits for more clear coding instead of overriding inits
extension Post {
    // Static func to let us use this transform without creating Post instance
    static func transformPostPhoto(dict: [String: Any], key: String) -> Post {
        let post = Post()
        post.id = key
        post.caption = dict["caption"] as? String // The extracted caption from Firebase Database
        post.photoUrl = dict["photoUrl"] as? String // The extracted photoUrl from Firebase Database
        post.uid = dict["uid"] as? String // The extracted UID from Firebase Database
        post.likeCount = dict["likeCount"] as? Int
        post.likes = dict["likes"] as? Dictionary<String, Any>
        post.ratio = dict["ratio"] as? CGFloat
        post.timestamp = dict["timestamp"] as? Int
        if let currentUserId = Auth.auth().currentUser?.uid {
            if post.likes != nil {
                post.isLiked = post.likes![currentUserId] != nil
            }
        }
        return post
    }
    
    static func transformPostVideo() {
    }
}
