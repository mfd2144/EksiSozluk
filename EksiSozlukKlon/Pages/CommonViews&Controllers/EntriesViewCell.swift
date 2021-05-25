//
//  BugunViewCell.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 2.04.2021.
//

import UIKit


class EntriesViewCell:UITableViewCell{
    static let cellID = "EntriesCell"
    
    private let cellStack:UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let entityLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    }()
    
    private let numberOfComments:UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .systemGray4
        return label
    }()
        
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setStackView()
        
        
    }
    
    private func setStackView(){
        cellStack.addArrangedSubview(entityLabel)
        cellStack.addArrangedSubview(numberOfComments)
        addSubview(cellStack)
        NSLayoutConstraint.activate([
            cellStack.topAnchor.constraint(equalTo: topAnchor),
            cellStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            cellStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            cellStack.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func setCellValues(text:[String],number:Int){
        var entryString :String = ""
        text.forEach({entryString += ($0+" ") })
        entityLabel.text = entryString
        numberOfComments.text = String(number)
    }
    
    
}
