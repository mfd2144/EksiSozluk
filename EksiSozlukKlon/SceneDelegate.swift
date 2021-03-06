//
//  SceneDelegate.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 29.03.2021.
//

import UIKit
import Firebase
import FBSDKCoreKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let firebaseService = FirebaseService()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowsscene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowsscene.coordinateSpace.bounds)
        firebaseService.fetchMostLikedEntries { mostFollowed in
            AppSingleton.shared.mostFollowed = mostFollowed
        }
        window?.windowScene = windowsscene
        let tabBar =  TabBarController()
        
        NotificationCenter.default.addObserver(self, selector: #selector(userDidChangeStatus(_ :)), name: .AuthStateDidChange, object: nil)
        window?.rootViewController = tabBar
        window?.makeKeyAndVisible()

    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }

        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )
    }
    


    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }
  
    @objc func userDidChangeStatus(_ responder:NSNotification){
        let tabBar = TabBarController()
        //for some user's process app write user document ID to singleton
        DispatchQueue.main.async { [self] in
            firebaseService.getUserDocID{
                self.firebaseService.fetchFollowedUserEntry(){ result,_ in
                    AppSingleton.shared.followedUsersLastEntries = result
                    tabBar.updateBadge = result.count
                }
            }
            window?.rootViewController = tabBar
            window?.makeKeyAndVisible()

        }
    }
    
}

