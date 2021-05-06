//
//  SearchViewControllerModel.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 6.05.2021.
//

import Foundation


class SearchViewControllerModel:NSObject{
    let firebaseService = FirebaseService()
    
    override init() {
        super.init()
    }
    
    func searchEntries(with keyWord:String,handler:@escaping ([MostFollowedStruct])->()){
        var entries = [MostFollowedStruct]()
        firebaseService.searchInEntries(with: keyWord) { mostFollowedStruct, error in
            
            if let error = error {
                print("searc entry error : \(error)")
                handler(entries)
            }else{
               entries = mostFollowedStruct
            }
        }
       handler(entries)
    }
    
    
    
}
