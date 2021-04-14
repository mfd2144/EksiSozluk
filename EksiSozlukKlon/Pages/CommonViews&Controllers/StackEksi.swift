//
//  stackEksi.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 31.03.2021.
//

import UIKit

class EksiStack:UIStackView{
    
    private let imageEksi :UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage.init(systemName: "drop.fill")
        imageView.tintColor = .systemGreen
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let labelEksi:UILabel={
       let label = UILabel()
        label.text = "ekşi"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    private let labelSozluk:UILabel={
       let label = UILabel()
        label.text = "sözlük"
        label.textColor = .systemGreen
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        alignment = .fill
        axis = .horizontal
        distribution = .fill
        spacing = 0
        setCenterStack()
    }
    required init(coder: NSCoder) {
        super.init(coder: coder)
     
    }
    private func  setCenterStack(){
        addArrangedSubview(imageEksi)
        addArrangedSubview(labelEksi)
        addArrangedSubview(labelSozluk)
        
        
        NSLayoutConstraint.activate([
            imageEksi.heightAnchor.constraint(equalToConstant:30),
            imageEksi.widthAnchor.constraint(equalToConstant:22)

        ])
        
    }
    
}




