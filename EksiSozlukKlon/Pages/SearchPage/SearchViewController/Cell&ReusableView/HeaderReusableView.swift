//
//  HeaderReusableView.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 6.05.2021.
//

import UIKit

class HeaderReusableView: UICollectionReusableView  {

    static let headerReusableIdentifier = "HeaderReusableCell"
    var sectionName:String?
    

private let categoryLabel: UILabel = {
    let title = UILabel()
    title.text = "other"
    title.textColor = .none
    title.font = UIFont(name: "Montserrat", size: 20)
    title.translatesAutoresizingMaskIntoConstraints = false
    return title
}()

func setupHeaderViews()   {
    addSubview(categoryLabel)
    categoryLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    categoryLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
  
}
   private func configure(){
        self.layer.cornerRadius = 10
    backgroundColor = .systemGray3
        setupHeaderViews()
    categoryLabel.text = sectionName?.lowercased() ?? ""
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configure()
    }

}
