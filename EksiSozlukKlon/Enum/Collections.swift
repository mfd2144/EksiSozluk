//
//  Collections.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 29.03.2021.
//

import UIKit


enum Collections:String,RawRepresentable{
    case bugun = "bugün"
    case gundem = "gündem"
    case debe = "debe"
    case takip = "takip"
    case caylak = "çaylak"


    var value: Int{
        switch self {
        case .bugun:
            return 0
        case .gundem:
            return 1
        case .debe:
            return 2
        case .takip:
            return 3
        case .caylak:
            return 4
        }
    }
    init?(value: Int) {
        switch value {
        case 0:self = .bugun
        case 1:self = .gundem
        case 2:self = .debe
        case 3:self = .takip
        case 4:self = .caylak
        default : return nil
            
        }
    }
    var view:UIView{
        switch self {
        case .bugun:return BugunView()
        case .gundem:return GundemView()
        case.debe:return DebeView()
        case.takip:return TakipView()
        default: return RookieView()
    
        }
    }
   
    
}
