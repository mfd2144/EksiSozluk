//
//  TabBar.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 29.03.2021.
//

import UIKit
import Firebase

class TabBarController: UITabBarController {
    
    var lightMode = UserDefaults.standard.bool(forKey: "lightMode")
   
    

    let firebaseService = FirebaseService()
    var badge:Int = 0
    var updateBadge:Int?{
        didSet{
            if updateBadge  == 0 || updateBadge == nil {
                tabBar.items?[3].badgeValue = nil
            }else{
                tabBar.items?[3].badgeValue = String(updateBadge!)
                tabBar.items?[3].badgeColor = .systemGreen
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedIndex = 0
        lightMode = UserDefaults.standard.bool(forKey: "lightMode")
        
        (UIApplication.shared.windows.first?.windowScene?.delegate as? SceneDelegate)?.window?.overrideUserInterfaceStyle = lightMode ? .dark : .light
        
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadTabBar()
        self.tabBar.tintColor = .systemGreen
        didNewMessageArrive()
    }
    
    
 func didNewMessageArrive(){
    firebaseService.checkNewMessagesForBadge(){ [self] totalBadge,error in
        if  error != nil {
            print("badge fetch error")
        }else{
            badge = totalBadge
            if badge > 0 {
                tabBar.items?[2].badgeValue = String(badge)
                tabBar.items?[2].badgeColor = .systemGreen
            }else {
                tabBar.items?[2].badgeValue = nil
            }
            
        }
        
    }
    }
    
    func loadTabBar(){
        let tab1 = Tabbar.mainPage.controller
        let tabItem1 = UITabBarItem(title: nil, image: Tabbar.mainPage.image, selectedImage: Tabbar.mainPage.selectedImage)
        tab1.tabBarItem = tabItem1
        
        let tab2 = Tabbar.searchPage.controller
        let tabItem2 = UITabBarItem(title: nil, image: Tabbar.searchPage.image, selectedImage: Tabbar.searchPage.selectedImage)
        tab2.tabBarItem = tabItem2
        
        let tab5 = Tabbar.userControlPage.controller
        let tabItem5 = UITabBarItem(title: nil, image: Tabbar.userControlPage.image, selectedImage: Tabbar.userControlPage.selectedImage)
        tab5.tabBarItem = tabItem5
        
        let tab4 = Tabbar.updatePage.controller
        let tabItem4 = UITabBarItem(title: nil, image: Tabbar.updatePage.image, selectedImage: Tabbar.updatePage.selectedImage)
        tab4.tabBarItem = tabItem4
        
        let tab3 = Tabbar.messagePage.controller
        let tabItem3 = UITabBarItem(title: nil, image: Tabbar.messagePage.image, selectedImage: Tabbar.messagePage.selectedImage)
        tab3.tabBarItem = tabItem3
        
        let controllers = [tab1,tab2,tab3,tab4,tab5]
        self.setViewControllers(controllers, animated: true)
        }
       
        
        
    }
    
    



