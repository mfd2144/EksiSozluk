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
    case sorunsallar = "sorunsallar"
    case takip = "takip"
    case tarihte_bugun = "tarihte bugün"
    case son = "son"
    case caylak = "çaylak"
    case kenar = "kenar"

    var value: Int{
        switch self {
        case .bugun:
            return 0
        case .gundem:
            return 1
        case .debe:
            return 2
        case .sorunsallar:
            return 3
        case .takip:
            return 4
        case .tarihte_bugun:
            return 5
        case .son:
            return 6
        case .caylak:
            return 7
        case .kenar:
            return 8
        }
    }
    init?(value: Int) {
        switch value {
        case 0:self = .bugun
        case 1:self = .gundem
        case 2:self = .debe
        case 3:self = .sorunsallar
        case 4:self = .takip
        case 5:self = .tarihte_bugun
        case 6:self = .son
        case 7:self = .caylak
        case 8:self = .kenar
        default : return nil
            
        }
    }
    var view:UIView{
        switch self {
        case .bugun:return BugunView()
        case .gundem:return GundemView()
        case.debe:return DebeView()
        case.sorunsallar:return Sorunsallar()
        default: return UIView()
    
        }
    }
   
    
}
