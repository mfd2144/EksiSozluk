//
//  FirebaseService-MostFollowedEntries.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 4.05.2021.
//

import Foundation





extension FirebaseService{
    
    func fetchMostLikedEntries(handler:@escaping([MostLikedStruct])->()){

        callMostLikedByCategory(categoryName: "sport") { [self] mostFollowedSport in
            guard let sports = mostFollowedSport else {return}
            mostFollowed.append(sports)
            handler(mostFollowed)
        }
        callMostLikedByCategory(categoryName: "relation") { [self] mostFollowedRelation in
            guard let relations = mostFollowedRelation else {return}
            mostFollowed.append(relations)
            handler(mostFollowed)
        }
        callMostLikedByCategory(categoryName: "political") { [self] mostFollowedPolitical in
            guard let politics = mostFollowedPolitical else {return}
            mostFollowed.append(politics)
            handler(mostFollowed)
        }
        callMostLikedByCategory(categoryName: "other") { [self] mostFollowedOther in
            guard let others = mostFollowedOther else {return}
            mostFollowed.append(others)
            handler(mostFollowed)
        }
        callMostLikedByCategory(categoryName: "entertainment") { [self] mostFollowedEntertainment in
            guard let entertainments = mostFollowedEntertainment else {return}
            mostFollowed.append(entertainments)
            handler(mostFollowed)
        }
        
        
        
        func callMostLikedByCategory(categoryName:String,completionHandler:@escaping  (MostLikedStruct?)->()){
            var mostLiked:MostLikedStruct?
            self.entryCollection.whereField(category_string, isEqualTo: categoryName)
                .order(by: likes_number, descending: true)
                .limit(to: 10).getDocuments { querySnapshot, error in
                    if let error = error{
                        print(error)
                        completionHandler(mostLiked)
                        return
                    }else{
                        guard let mostLikedSnap = querySnapshot?.documents else { return }
                        var entries = [EntryStruct]()
                        for doc in mostLikedSnap{
                            let entry = EntryStruct(querySnapshot: doc, documentID: doc.documentID)
                            entries.append(entry)
                            
                        }
                        
                        mostLiked = MostLikedStruct(category: categoryName, entries: entries)
                       return completionHandler(mostLiked)
                    }
                    
                }
           
        }
        
        
    }
    
    
}
