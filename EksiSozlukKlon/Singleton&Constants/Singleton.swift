//
//  Singleton.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 15.04.2021.
//

import Foundation


class AppSingleton{
    static let shared = AppSingleton()
    private init(){
        
    }
    var entryID:String?
    var userDocID:String?
    var mostFollowed:[MostFollowedStruct]?
}
