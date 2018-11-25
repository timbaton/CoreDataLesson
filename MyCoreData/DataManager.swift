//
//  DataManager.swift
//  MultithreadingProject
//
//  Created by Тимур Бадретдинов on 17/11/2018.
//  Copyright © 2018 Ильдар Залялов. All rights reserved.
//

import UIKit

class DataManager: PostDataProtocol  {
    
    //constant for post key
    static var postKey = "key_post"
    
    // MARK: - Operation queues
    private lazy var getPostOperationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "Search queue"
        
        return queue
    }()
    
    private lazy var addOperationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "Add post queue"
        return queue
    }()
    
    private lazy var getAllPostsOperationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "Get all posts queue"
        return queue
    }()

    // MARK: - Realization of methods
    /// Returns post by id
    ///
    /// - Parameter id: post's id
    func getPostSync(by id: Int) -> Post? {
        let postsArray = (self.getAllPostsSync().filter{ post in post.postId == id})
        return postsArray.first
    }
    
    /// Returns post by id asynchronously
    ///
    /// - Parameter id: post's id, competionBlock: block for returning data
    func getPostAsync(by id: Int, completionBlock: @escaping (Post?) -> Void) {
        getPostOperationQueue.addOperation{ [weak self] in
            guard let strongSelf = self else { return }
            completionBlock(strongSelf.getPostSync(by: id))
        }
    }
    
    /// Adding new post
    ///
    /// - Parameter post: new post to add
    func addPostSync(post: Post) {
        var allPosts:[Post] = self.getAllPostsSync()
        allPosts.append(post)
        let archiver = NSKeyedArchiver.archivedData(withRootObject: allPosts)
        UserDefaults.standard.set(archiver, forKey: DataManager.postKey)
        UserDefaults.standard.synchronize()
    }
    
    /// Adding new post asynchronously
    ///
    /// - Parameter post: new post to add, competionBlock: block for returning data
    func addPostAsync(post: Post, completionBlock: @escaping (Bool) -> Void) {
        addOperationQueue.addOperation {
            self.addPostSync(post: post)
            completionBlock(true)
        }
    }
    
    /// Returns all posts
    ///
    ///
    func getAllPostsSync() -> [Post] {
        if let posts = UserDefaults.standard.data(forKey: DataManager.postKey){
            guard let myposts = NSKeyedUnarchiver.unarchiveObject(with: posts) as? [Post] else { return [] }
            return myposts
        }
        return []
    }
    
    /// Returns all posts asynchronously
    ///
    /// - Parameter competionBlock: block for returning data
    func getAllPostsAsync(completionBlock: @escaping ([Post]) -> Void) {
        getAllPostsOperationQueue.addOperation{ [weak self] in
            guard let strongSelf = self else { return }
            completionBlock(strongSelf.getAllPostsSync())
        }
    }
    
    /// Returns count of posts
    ///
    ///
    func getCount() -> Int {
        if let posts = UserDefaults.standard.data(forKey: DataManager.postKey){
            guard let posts = NSKeyedUnarchiver.unarchiveObject(with: posts) as? [Post] else { return 0 }
            return posts.count
        }
        return 0
    }
}
