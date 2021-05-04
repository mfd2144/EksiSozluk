//
//  CustomaAlertCell.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 12.04.2021.
//

import UIKit

class CustomaAlertCell:UITableViewCell{
    var delegate :AlertCellDelegate?
    
    let labelText:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var swcth:UISwitch = {
        let swtch = UISwitch()
        swtch.addTarget(self, action: #selector(switchChanged(_ :)), for: .touchUpInside)
        swtch.translatesAutoresizingMaskIntoConstraints = false
        return swtch
    }()
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        addSubview(labelText)
        addSubview(swcth)
        NSLayoutConstraint.activate([
            labelText.centerYAnchor.constraint(equalTo: centerYAnchor),
            swcth.centerYAnchor.constraint(equalTo: centerYAnchor),
            labelText.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 10),
            swcth.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -10)
            
        ])
    }
    
    func setCell(_ text:String,_ setting:Bool,_ delegate:AlertCellDelegate){
        labelText.text = text
        self.delegate = delegate
        swcth.isOn = setting
        
    }
 
    @objc private func switchChanged(_ sender:UISwitch){
        delegate?.senderChanged(sender,(labelText.text)!)
        
    }
    
    
}

protocol  AlertCellDelegate {
    func senderChanged(_ sender:UISwitch,_ text:String)
}
