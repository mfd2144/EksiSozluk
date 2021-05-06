//
//  FirebaseService-MostFollowedEntries.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 4.05.2021.
//

import Foundation





extension FirebaseService{
    
    func fetchMostFollowedEntries(handler:@escaping([MostFollowedStruct])->()){

        callMostFollowedByCategory(categoryName: "sport") { [self] mostFollowedSport in
            guard let sports = mostFollowedSport else {return}
            mostFollowed.append(sports)
            handler(mostFollowed)
        }
        callMostFollowedByCategory(categoryName: "relation") { [self] mostFollowedRelation in
            guard let relations = mostFollowedRelation else {return}
            mostFollowed.append(relations)
            handler(mostFollowed)
        }
        callMostFollowedByCategory(categoryName: "political") { [self] mostFollowedPolitical in
            guard let politics = mostFollowedPolitical else {return}
            mostFollowed.append(politics)
            handler(mostFollowed)
        }
        callMostFollowedByCategory(categoryName: "other") { [self] mostFollowedOther in
            guard let others = mostFollowedOther else {return}
            mostFollowed.append(others)
            handler(mostFollowed)
        }
        callMostFollowedByCategory(categoryName: "entertainment") { [self] mostFollowedEntertainment in
            guard let entertainments = mostFollowedEntertainment else {return}
            mostFollowed.append(entertainments)
            handler(mostFollowed)
        }
        
        
        
        func callMostFollowedByCategory(categoryName:String,completionHandler:@escaping  (MostFollowedStruct?)->()){
            var mostFollowed:MostFollowedStruct?
            self.entryCollection.whereField(category_string, isEqualTo: categoryName)
                .order(by: follow_number, descending: true)
                .limit(to: 10).getDocuments { querySnapshot, error in
                    if let error = error{
                        print(error)
                        completionHandler(mostFollowed)
                        return
                    }else{
                        guard let mostFollowedSnap = querySnapshot?.documents else { return }
                        var entries = [EntryStruct]()
                        for doc in mostFollowedSnap{
                            let entry = EntryStruct(querySnapshot: doc, documentID: doc.documentID)
                            entries.append(entry)
                            
                        }
                        
                        mostFollowed = MostFollowedStruct(category: categoryName, entries: entries)
                       print(mostFollowed)
                       return completionHandler(mostFollowed)
                    }
                    
                }
           
        }
        
        
    }
    
    
}
