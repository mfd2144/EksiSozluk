//
//  Firebase.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 9.04.2021.
//

import Foundation
import Firebase

extension Query{
    func newTodayWhereQuery()->Query{
        let dateCompanent = Calendar.current.dateComponents([.year,.month,.day], from: Date())
            let today = Calendar.current.date(from: dateCompanent)
            let nextDay = Calendar.current.date(byAdding: .hour, value:24, to: today!)
        return whereField(create_date, isGreaterThanOrEqualTo: today!).whereField(create_date, isLessThanOrEqualTo: nextDay!)
        
    }

    func newYesterdayWhereQuery()->Query?{

        let dateCompanent = Calendar.current.dateComponents([.year,.month,.day], from: Date())
        let today = Calendar.current.date(from: dateCompanent)!
        let yesterday = Calendar.current.date(byAdding: .hour, value:-24, to: today)
//        let dayBeforeYesterday =  Calendar.current.date(byAdding: .hour, value:-24, to: yesterday!)
        return whereField(create_date, isGreaterThanOrEqualTo: yesterday!).whereField(create_date, isLessThan:today).limit(to: 30)
        
    }
}
