//
//  UserModel.swift
//  MultithreadingProject
//
//  Created by Тимур Бадретдинов on 17/11/2018.
//  Copyright © 2018 Ильдар Залялов. All rights reserved.
//
import UIKit
import Foundation

class Post: NSObject, NSCoding {

    @objc var postId: Int
    @objc var authorAvatar: UIImage
    @objc var postImage: UIImage
    @objc var authorName: String
    @objc var postDate: String
    @objc var postText: String
    
    init(postId: Int, authorAvatar: UIImage, postImage: UIImage, authorName: String, postDate: String, postText: String) {
        self.postId = postId
        self.authorAvatar = authorAvatar
        self.postImage = postImage
        self.authorName = authorName
        self.postDate = postDate
        self.postText = postText
    }
    
    //кодирование модели для дальнейшей возможности добавления в UserDefaults
    func encode(with aCoder: NSCoder) {
        aCoder.encode(postId, forKey: #keyPath(Post.postId))
        aCoder.encode(authorAvatar, forKey: #keyPath(Post.authorAvatar))
        aCoder.encode(postImage, forKey: #keyPath(Post.postImage))
        aCoder.encode(authorName, forKey: #keyPath(Post.authorName))
        aCoder.encode(postDate, forKey: #keyPath(Post.postDate))
        aCoder.encode(postText, forKey: #keyPath(Post.postText))
    }
    
    //декодирование модели для возможности изъятия из UserDefaults
    required init?(coder aDecoder: NSCoder) {
        postId = aDecoder.decodeInteger(forKey: #keyPath(Post.postId))
        authorAvatar = aDecoder.decodeObject(forKey: #keyPath(Post.authorAvatar)) as! UIImage
        postImage = aDecoder.decodeObject(forKey: #keyPath(Post.postImage)) as! UIImage
        authorName = aDecoder.decodeObject(forKey: #keyPath(Post.authorName)) as! String
        postDate = aDecoder.decodeObject(forKey: #keyPath(Post.postDate)) as! String
        postText = aDecoder.decodeObject(forKey: #keyPath(Post.postText)) as! String
    }
}
