//
//  SearchPageNavController.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 6.05.2021.
//

import UIKit

class SearchPageNavController: UINavigationController {
    
    
    public override init(rootViewController: UIViewController = SearchViewController()) {
        super.init(rootViewController: rootViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
    }
    
    
}
