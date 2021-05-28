//
//  MutualAlertView.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 27.05.2021.
//

import UIKit


class MutualAlertViewController:NSObject{
    var message:String?
    var controller:UIViewController?
    init(message:String,_ viewController:UIViewController) {
        super.init()
        self.message = message
        self.controller = viewController
        self.createAlertView()
      
    }

    private func createAlertView(){
        let alertView = UIAlertController(title: "Bildiri", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
        alertView.addAction(action)
        controller?.present(alertView, animated: true, completion: nil)
    }
    
}
