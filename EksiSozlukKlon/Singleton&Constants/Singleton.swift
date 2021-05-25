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
    var userDocID:String?
    var mostFollowed:[MostLikedStruct]?
    var followedUsersLastEntries:[EntryStruct]?
    var selectedView:Collections?
}
