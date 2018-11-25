//
//  PostViewController.swift
//  TableViewLesson2
//
//  Created by Тимур Бадретдинов on 07.10.2018.
//  Copyright © 2018 Ильдар Залялов. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

    @IBOutlet weak var ivPostImage: UIImageView!
    @IBOutlet weak var tvPostText: UILabel!
    
    //менеджер по работе с данными
    var dataManager: PostDataProtocol!
    var postId: Int!
    var post: Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //инициализация менеджера через класс, реализующий протокол
        dataManager = DataManager()

        //достаем пост, по айди, переданного с предыдущего окна
        post = dataManager.getPostSync(by: postId)
        
        //заполнение данными
        ivPostImage.image = post.postImage
        tvPostText.text = post.postText
    }
}
