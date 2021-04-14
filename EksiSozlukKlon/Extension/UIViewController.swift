//
//  UIViewController.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 7.04.2021.
//

import UIKit


extension UIViewController{
    
    func presentToRight(_ vc:UIViewController){
        let transition = CATransition()
        transition.type = .push
        transition.subtype = .fromRight
        transition.duration = 0.3
        self.view.window?.layer.add(transition, forKey: "pushRightAnimation")
        self.present(vc, animated: false, completion: nil)
    }
    func dissmisToLeft(){
        let transition = CATransition()
        transition.type = .push
        transition.subtype = .fromLeft
        transition.duration = 0.3
        self.view.window?.layer.add(transition, forKey: "pushLeftAnimation")
        self.dismiss(animated: false, completion: nil)
    }
}
