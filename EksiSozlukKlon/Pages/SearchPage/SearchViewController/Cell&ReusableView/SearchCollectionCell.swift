//
//  SearchCollectionCell.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 6.05.2021.
//

import UIKit

class SearchCollectionCell: UICollectionViewCell {
    
    static let cellIdentifier = "SearchCellIdentifier"
    var entryStruct:EntryStruct?

    let textLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .none
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .center
        label.font = UIFont.init(name: "Hiragino Sans", size: 15)
        return label
    }()
    

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .systemGray6
        layer.cornerRadius = 10
        configure()
        guard let entry = entryStruct else {return}
        var entryString :String = ""
        entry.entryLabel.forEach({entryString += ($0+" ") })
        textLabel.text = entryString
        
    }
    
    private func configure(){
        addSubview(textLabel)
        textLabel.frame = bounds
    }
    
    
    
    
}
