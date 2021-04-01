//
//  Date.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 1.04.2021.
//

import Foundation


extension Date{
    func convertDateToString()->String{
        let formater = DateFormatter()
        formater.locale = Locale(identifier: "tr")
        formater.dateFormat = "dd/MMMM/YYYY"
        let newDate = formater.string(from: self)
        return newDate

    }
}
