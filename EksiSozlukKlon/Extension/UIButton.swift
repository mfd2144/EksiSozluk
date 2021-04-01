//
//  UIButton.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 29.03.2021.
//

import UIKit

extension UIButton{
    func drawCorner(){
        self.layer.cornerRadius = 15
        self.layer.borderColor = UIColor.systemGray2.cgColor
        self.layer.borderWidth = 2
        
    }
}
