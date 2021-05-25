//
//  MostLikedStruct.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 4.05.2021.
//

import Foundation


struct MostLikedStruct{
    let category:String
    var entries:[EntryStruct]
}


extension MostLikedStruct{
    init?(dic:[String:Any]) {
        guard let category = dic[category_string] as? String,
              let entries = dic["entries"] as? [EntryStruct] else {return nil}
        self.init(category: category, entries: entries)
    }
}



