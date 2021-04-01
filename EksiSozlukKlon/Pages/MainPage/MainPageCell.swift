//
//  MainPageCell.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 29.03.2021.
//


import UIKit

class MainPageCell: UICollectionViewCell {
    
    var delegate:MainPageCellDelegate?
    var selectedCell:((Int)->())?
    
    let label:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray2
        label.sizeToFit()
        return label
    }()

    
    let selectedCellLine: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGreen
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTap()
        addViews()
        selectedCell = { [self] (cellNumber) in
            if cellNumber == Collections.init(rawValue: label.text!)!.value{
                label.textColor = .black
                selectedCellLine.isHidden = false
            }else{
                label.textColor = .systemGray2
                selectedCellLine.isHidden = true
            }
            
        }
        
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addTap(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(cellTapped(_:)))
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
    private func addViews(){
        addSubview(label)
        addSubview(selectedCellLine)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            selectedCellLine.bottomAnchor.constraint(equalTo: bottomAnchor),
            selectedCellLine.widthAnchor.constraint(equalTo: widthAnchor),
            selectedCellLine.heightAnchor.constraint(equalToConstant: 3),
            selectedCellLine.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
    }
    
    
    func returnCellName(_ name: String,delegate: MainPageCellDelegate){
        label.text = name
        self.delegate = delegate
        
    }
    
    
    
    
    @objc private func cellTapped(_ gesture:UIGestureRecognizer){
        delegate?.cellPressed(name:label.text!)
        
    }
    
}

protocol MainPageCellDelegate {
    func cellPressed(name:String)
    
}
