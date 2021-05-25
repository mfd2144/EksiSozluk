//
//  CautionView.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 22.05.2021.
//

import UIKit


class CautionView:UIView{
  
    var cautionText: String?
    
    lazy var stringView:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.alpha = 2
        view.backgroundColor = .systemGreen
        let label = UILabel()
        label.text = cautionText?.uppercased()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = .none
        label.numberOfLines = 0
        
        label.textAlignment = .center
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                        label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                        label.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.98),
                                        label.heightAnchor.constraint(equalToConstant: 80)])
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        backgroundColor = .clear
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissVC))
        addGestureRecognizer(tapGesture)
        addSubview(stringView)
        NSLayoutConstraint.activate([
            stringView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stringView.centerYAnchor.constraint(equalTo: centerYAnchor,constant: -120),
            stringView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            stringView.heightAnchor.constraint(equalToConstant: 100)
        ])
     
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func dismissVC(){
        removeFromSuperview()
    }
    
    
}
