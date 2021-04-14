//
//  UIview.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 9.04.2021.
//

import UIKit

extension UIView{
    
    func addViewWithAnimation(_ view:UIView){
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .push
        transition.subtype = .fromRight
        self.layer.add(transition, forKey: "searcBarAnimation")
        self.addSubview(view)
}
}
