//
//  MainViewController.swift
//  TableViewLesson2
//
//  Created by Ильдар Залялов on 01/10/2018.
//  Copyright © 2018 Ильдар Залялов. All rights reserved.
//

import UIKit

//MARK: - working with table
class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CustomCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    var dataManager: PostDataProtocol!
    

    /// Константы
    fileprivate let cellIdentifier = "cell"
    fileprivate let detailSegue = "detailSegue"
    fileprivate let shareSegue = "shareSegue"
    fileprivate let addErrorMessage = "Assync adding failed"
    fileprivate let refreshedMessage = "Обновлено!"
    fileprivate let rowHeight:CGFloat = 400
    
    /// массив постов для таблицы
    var postsArray = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager = DataManager()
        ///заполняем массив постами
        postsArray = dataManager.getAllPostsSync()
        
        /// Делаем размер ячейки динамичным
        tableView.estimatedRowHeight = rowHeight
        
        /// Добавляю рефрешер в таблице
        tableView.addSubview(refreshControl)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! CustomTableViewCell
        cell.configureCell(post: postsArray[indexPath.row],index: indexPath.row, delegate: self)
        return cell
    }
    
    //click listener для кнопки добавления
    @IBAction func addPost(_ sender: Any) {
        //добавляем новый пост в таблицу, используя асинхронный метод из dataManager'a
        dataManager.addPostAsync(post: Post(postId: dataManager.getCount() + 1, authorAvatar: #imageLiteral(resourceName: "iv1"), postImage: #imageLiteral(resourceName: "iv2"), authorName: "Timur Badretdinov", postDate: "02.04.1998", postText: "Although these classes actually can support the display of arbitrary amounts of text, labels and text fields are intended to be used for relatively small amounts of text, typically a single line. Text views, on the other hand, are meant to display large amounts of text."),
                                 completionBlock: { (isSuccess)  in
                                                    if !isSuccess {
                                                        print(self.addErrorMessage)
                                                                    }
                                                    })
    }
    
    
    // MARK: - Refreshing
    /// обаботчик свайпа таблицы
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(MainViewController.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.gray
        
        return refreshControl
    }()

    /// метод вызывающийся при свайпе таблицы
    ///
    /// - Parameter refreshControl: UIRefreshControl
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        //получаем массив постов
        self.postsArray = dataManager.getAllPostsSync()
        DispatchQueue.main.async { [unowned self] in
            self.tableView.reloadData()
            refreshControl.endRefreshing()
            self.showToast(message: self.refreshedMessage)
        }
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

    // MARK: - Navigation
    /// обработчик нажатия на элемент таблицы
    ///
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: detailSegue, sender: postsArray[indexPath.row])
        
    }
    
    /// Обработка нажатия на шэринг кнопку
    ///
    /// - Parameter index: индекс элемента
    func didPressInfoButton(index: Int) {
          performSegue(withIdentifier: shareSegue, sender: postsArray[index])
    }
    
    /// подктовка объектов класса для отправки
    ///
    /// - Parameters:
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == detailSegue, let post = sender as? Post {
            let destinationController = segue.destination as! PostViewController
            destinationController.postId = post.postId
        }
        
        if segue.identifier == shareSegue, let post = sender as? Post {
            let destinationController = segue.destination as! ShareViewController
            destinationController.postId = post.postId
        }
    }
}
