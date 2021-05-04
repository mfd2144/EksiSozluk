//
//  Tabbar.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 29.03.2021.
//

import UIKit
import FirebaseAuth


enum Tabbar{
    
    
    case mainPage
    case searchPage
    case updatePage
    case userControlPage
    case messagePage
    
    var controller:UIViewController{
        switch self {
        case .mainPage: return MainPageController()
        case .searchPage:return SearchView()
        case.messagePage: return  Auth.auth().currentUser != nil ? MessageNavController() : MessageUnsigned()
        case.userControlPage:return  Auth.auth().currentUser != nil ? UIViewController() : UserControlUnsigned()
        case.updatePage:return UpdateUnsigned()
        }
    }
    var image:UIImage{
        switch self {
        case .mainPage: return UIImage(systemName: "drop")!
        case .searchPage:return UIImage(systemName: "magnifyingglass")!
        case.messagePage: return UIImage(systemName: "bubble.right")!
        case.userControlPage:return UIImage(systemName: "bell")!
        case.updatePage:return UIImage(systemName: "person")!
            
        }
    }
    var selectedImage:UIImage{
        switch self {
        case .mainPage: return UIImage(systemName: "drop.fill")!
        case .searchPage:return UIImage(systemName: "magnifyingglass.circle.fill")!
        case.messagePage: return UIImage(systemName: "bubble.right.fill")!
        case.userControlPage:return UIImage(systemName: "bell.fill")!
        case.updatePage:return UIImage(systemName: "person.fill")!
            
        }
    }

}
