//
//  DataProtocol.swift
//  MultithreadingProject
//
//  Created by Тимур Бадретдинов on 17/11/2018.
//  Copyright © 2018 Ильдар Залялов. All rights reserved.
//

import UIKit

protocol PostDataProtocol {
    func getPostSync(by id: Int) -> Post?
    func getPostAsync(by id: Int, completionBlock: @escaping (Post?) -> Void)
    
    func addPostSync(post: Post)
    func addPostAsync(post: Post, completionBlock: @escaping (Bool) -> Void)
    
    func getAllPostsSync() -> [Post]
    func getAllPostsAsync(completionBlock: @escaping ([Post]) -> Void) -> Void
    
    func getCount() -> Int
}
