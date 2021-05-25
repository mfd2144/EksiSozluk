//
//  UpdateModel.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 17.05.2021.
//

import Foundation


class UpdateModel:NSObject{
    let firebaseService = FirebaseService()
    
    override init() {
        super.init()
        adjustUserFollowedDate()
    }
    
    func adjustUserFollowedDate(){
        firebaseService.resetUserLastUpdateDate(){error in
            if let error = error{
                print(error)
            }
        }
    }
    
}
