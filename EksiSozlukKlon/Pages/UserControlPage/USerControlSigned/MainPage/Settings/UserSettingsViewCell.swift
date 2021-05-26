//
//  UserSettingsViewCell.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 20.05.2021.
//

import UIKit
import  Firebase

class SettingsModel: NSObject {
    let firebaseService = FirebaseService()
    var parentController:UIViewController?
    
    
    var lightMode = UserDefaults.standard.bool(forKey: "lightMode")
       
    lazy var lightSwitch:UISwitch = {
        let swtch = UISwitch()
        swtch.isOn = lightMode
        swtch.addTarget(self, action: #selector(switchOnOf(_:)), for: .valueChanged)
        swtch.translatesAutoresizingMaskIntoConstraints = false
        return swtch
    }()
    
    override init() {
        super.init()
        
    }
  
    
    @objc private func switchOnOf(_ sender:UISwitch) {
        lightMode = !lightMode
        (UIApplication.shared.windows.first?.windowScene?.delegate as? SceneDelegate)?.window?.overrideUserInterfaceStyle = lightMode ? .dark : .light
        UserDefaults.standard.set(lightMode, forKey: "lightMode")
    }
    
    
    func setCell(indexPath:IndexPath,_ cell:UITableViewCell)->UITableViewCell{
        cell.textLabel?.textColor = .none
        switch indexPath.row {
        case 0 : cell.textLabel?.text = "kullanıcı bilgileri"
        case 1 : cell.textLabel?.text = "mail değiştir"
        case 2 :cell.textLabel?.text = "şifre değiştir"
        case 3: cell.textLabel?.text = "çıkış yap"
        default:
            cell.textLabel?.text = "dark mode"
            cell.addSubview(lightSwitch)
            NSLayoutConstraint.activate([
                lightSwitch.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
                lightSwitch.trailingAnchor.constraint(equalTo: cell.trailingAnchor,constant: -10)
            ])
        }
        return cell
    }
    
    
    func selectViewController(_ selectedIndex:Int){
        switch selectedIndex {
        case 0:changeUserInfo()
        case 1:changeUserMail()
        case 2:changeUserPassword()
        case 3:logOut()
        default:return
            
        }
    }

    
    func logOut(){
        
        firebaseService.logout()
    }
    
    func changeUserPassword(){
        let alert = UIAlertController(title: "şifre değiştirme", message: "yeni şifre girin", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "yeni password girin"
            textField.isSecureTextEntry = true
        }
        alert.addTextField { textField in
            textField.placeholder = "passwordu tekrar girin"
            textField.isSecureTextEntry = true
        }
        let actionCAncel = UIAlertAction(title: "vazgeç", style: .cancel, handler: nil)
        let actionChange = UIAlertAction(title: "değiştir", style: .default) { _ in
            let password = alert.textFields?.first?.text
            let  password_2 = alert.textFields?.last?.text
            
            if password != "" && password == password_2{
                self.firebaseService.changePassword(newPassword: password!) { error in
                    if let error = error{
                        print(error)
                    }
                }
            }
        }
        alert.addAction(actionCAncel)
        alert.addAction(actionChange)
        parentController?.present(alert, animated: true, completion: nil)
    }
    
    
    
    func changeUserMail(){
        let alert = UIAlertController(title: "mail değiştirme", message: "yeni e-mail adresini girin", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.keyboardType = .emailAddress
            textField.placeholder = "yeni mail adresi girin"
        }
        alert.addTextField { textField in
            textField.keyboardType = .emailAddress
            textField.placeholder = "yeni mail adresini tekrar girin"
        }
        let actionCAncel = UIAlertAction(title: "vazgeç", style: .cancel, handler: nil)
        let actionChange = UIAlertAction(title: "değiştir", style: .default) { _ in
            let mail = alert.textFields?.first?.text
            let mail_2 = alert.textFields?.last?.text
            if mail != "" && mail_2 == mail{
                self.firebaseService.resetMailAdress(newMail: mail!) { error in
                    if let error = error{
                        print(error)
                    }
                }
            }
        }
        alert.addAction(actionCAncel)
        alert.addAction(actionChange)
        parentController?.present(alert, animated: true, completion: nil)
    }
    
   func changeUserInfo(){
        let vc = ChangeUserInformationViewControl()
    
    parentController?.navigationController?.pushViewController(vc, animated: true)

    }
    
}
