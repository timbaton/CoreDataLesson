//
//  ShareViewController.swift
//  TableViewLesson2
//
//  Created by Тимур Бадретдинов on 07.10.2018.
//  Copyright © 2018 Ильдар Залялов. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController {
    
    /// Константы
    fileprivate let savedMessage = "saved to clipboard"
    
    @IBOutlet weak var tvSharedText: UILabel!
    var dataManager: PostDataProtocol!
    
    var post: Post!
    var postId: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //инициализация менеджера через класс, реализующий протокол
        dataManager = DataManager()
        //достаем пост, по айди, переданного с предыдущего окна
        post = dataManager.getPostSync(by: postId)
        ///отображение теста для шэринга
        tvSharedText.text = post.postText
        ///сохранение текста в буфер обмена
        UIPasteboard.general.string = post.postText
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ///выводим на экран сообщение о сохранении
        showToast(message: savedMessage)
    }
    
    /// Отображение сообщения
    ///
    /// - Parameter message: String text
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
