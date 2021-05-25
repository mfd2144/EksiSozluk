//
//  ViewController.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 3.04.2021.
//

import UIKit

class CommentNavController: UINavigationController {

    var entry:EntryStruct?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let commentVC = CommentsTableViewController()
        commentVC.entry = entry
        viewControllers = [commentVC]
    }

}
