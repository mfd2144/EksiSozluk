//
//  Singleton.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 15.04.2021.
//

import Foundation


class IdSingleton{
    static let shared = IdSingleton()
    private init(){
        
    }
    var entryID:String?
    var userDocID:String?
}
