//
//  TableViewCell.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 12.05.2021.
//

import UIKit

class StaticUserCell: UITableViewCell {
       let userTopView = UserTopView()
    var user:UserStruct?{
        didSet{
            SetCell()
        }
    }
        let firebaseService = FirebaseService()
         static let staticCellIdentifier = "StaticCell"
        

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        addTopView()
        
        firebaseService.fetchUserInformation { user, error in
            if let error = error {
                print("user's informations' loading error \(error.localizedDescription) ")
                
            }else{
                self.user = user
            }
        }
    
        
        
        
    }
    
    private func SetCell(){
        guard let user = user else {return}
        userTopView.userName.text = user.nick
        
        switch user.totalEntry {
        case 0...15: userTopView.userLevel.text = "yeni kullanıcı"
            userTopView.userInformation.text = "henüz 15 entry'yi tamamlanmadığınızdan yeni kullanıcı olarak görünüyorsunuz"
        case 16...30: userTopView.userLevel.text = "acemi"
            userTopView.userInformation.text = "acemiliğiniz 30 entry'den sonra sona erecek"
        case 31...100: userTopView.userLevel.text = "kıdemli"
            userTopView.userInformation.text = "kıdemli kademeli kullanıcı"
        default: userTopView.userLevel.text = "sözlük yazarı"
            userTopView.userInformation.text = "değerli sözlük yazarımız"
    }
        userTopView.totalFollow.text = String(user.totalContact)
        userTopView.totalEntry.text = String(user.totalEntry)
        
    }
    
    func addTopView(){
       addSubview(userTopView)
       

        NSLayoutConstraint.activate([
            userTopView.topAnchor.constraint(equalTo: topAnchor),
            userTopView.leadingAnchor.constraint(equalTo: leadingAnchor),
            userTopView.trailingAnchor.constraint(equalTo: trailingAnchor),
            userTopView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    

}
