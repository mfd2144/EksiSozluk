//
//  TabBar.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 29.03.2021.
//

import UIKit

class TabBar: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedIndex = 0
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadTabBar()
        self.tabBar.tintColor = .systemGreen
    }
    
    
    func loadTabBar(){
        let tab1 = Tabbar.mainPage.controller
        let tabItem1 = UITabBarItem(title: nil, image: Tabbar.mainPage.image, selectedImage: Tabbar.mainPage.selectedImage)
        tab1.tabBarItem = tabItem1
        
        let tab2 = Tabbar.searchPage.controller
        let tabItem2 = UITabBarItem(title: nil, image: Tabbar.searchPage.image, selectedImage: Tabbar.searchPage.selectedImage)
        tab2.tabBarItem = tabItem2
        
        let tab5 = Tabbar.updatePage.controller
        let tabItem5 = UITabBarItem(title: nil, image: Tabbar.updatePage.image, selectedImage: Tabbar.updatePage.selectedImage)
        tab5.tabBarItem = tabItem5
        
        let tab4 = Tabbar.userControlPage.controller
        let tabItem4 = UITabBarItem(title: nil, image: Tabbar.userControlPage.image, selectedImage: Tabbar.userControlPage.selectedImage)
        tab4.tabBarItem = tabItem4
        
        let tab3 = Tabbar.messagePage.controller
        let tabItem3 = UITabBarItem(title: nil, image: Tabbar.messagePage.image, selectedImage: Tabbar.messagePage.selectedImage)
        tab3.tabBarItem = tabItem3
        
        let controllers = [tab1,tab2,tab3,tab4,tab5]
        self.setViewControllers(controllers, animated: true)
        }
       
        
        
    }
    
    



