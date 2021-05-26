//
//  ChangeUserInformation.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 25.05.2021.
//

import UIKit


class ChangeUserInformationViewControl:UIViewController{
    let width = UIScreen.main.bounds.width
    let model = ChangeUserInformationModel()
    var userInfo :UserStruct?
    var date:Date?
    
    let  mainStack : UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalCentering
        stack.alignment = .center
        stack.backgroundColor = .systemGray6
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = .init(top: 50, leading: 10, bottom: 50, trailing: 10)
        stack.layer.cornerRadius = 150
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    lazy var datePicker:UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.locale = Locale(identifier: "tr")
        picker.datePickerMode = .date
        picker.backgroundColor = .systemBackground
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        return picker
    }()
    
    let  buttonStack : UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .fill
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var buttonUpdate:UIButton = {
        let button = model.newButton(#selector(updatePressed))
        button.setTitle("güncelle", for: .normal)
        button.setTitleColor(nickField.textColor, for: .normal)
        return button
    }()
    
    lazy var buttonCancel:UIButton = {
        let button = model.newButton(#selector(cancelPressed))
        button.setTitle("vazgeç", for: .normal)
        button.setTitleColor(nickField.textColor, for: .normal)
        return button
    }()
    
    lazy var nickField :UITextField={
        let field = model.newTextField()
        field.delegate = self
        return field
    }()
    
    
    
    lazy var userBirthdayField :UITextField = {//birthday field
        let field = model.newTextField()
        field.delegate = self
        field.restorationIdentifier = "birthday"
        return field
    }()
    
    
    let genderSegment:UISegmentedControl = {
        let segment = UISegmentedControl(items: ["kadın","erkek","başka","boşver"])
        segment.selectedSegmentIndex = 0
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setView()
        model.userContanier = { user in
            self.userInfo = user
            self.setFields(user)
            
        }
        
    }
    
    private func setView(){
        
        mainStack.addArrangedSubview(nickField)
        mainStack.addArrangedSubview(genderSegment)
        mainStack.addArrangedSubview(userBirthdayField)
        buttonStack.addArrangedSubview(buttonUpdate)
        buttonStack.addArrangedSubview(buttonCancel)
        view.addSubview(mainStack)
        view.addSubview(buttonStack)
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            mainStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStack.widthAnchor.constraint(equalToConstant: 300),
            mainStack.heightAnchor.constraint(equalToConstant: 300),
            nickField.heightAnchor.constraint(equalToConstant: 50),
            userBirthdayField.heightAnchor.constraint(equalToConstant: 50),
            buttonStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStack.widthAnchor.constraint(equalToConstant: 300),
            buttonStack.heightAnchor.constraint(equalToConstant: 100),
            buttonStack.bottomAnchor.constraint(equalTo: mainStack.bottomAnchor, constant: 200),
            buttonCancel.widthAnchor.constraint(equalToConstant: 100),
            buttonUpdate.widthAnchor.constraint(equalToConstant: 100),
            
            
        ])
    }
    

    
 
    
    func setFields(_ user:UserStruct){
        nickField.text = user.nick
        genderSegment.selectedSegmentIndex = user.gender
        var birthdayDate:String?
    
        if  user.birtday != nil {
            birthdayDate = user.birtday?.convertDateToString()
            date = user.birtday!
        }else{
            birthdayDate = Date().convertDateToString()
            date = Date()
        }
        userBirthdayField.text = birthdayDate
    }
    
    
    @objc private func cancelPressed(){
        guard let user = userInfo else {return}
       setFields(user)
    }
    
    @objc private func updatePressed(){
        guard nickField.text != "" , let birthdayDate = date else {return}
        model.saveChanges(nickField.text!,birthdayDate , genderSegment.selectedSegmentIndex)
        
    }
    
    @objc private func dateChanged(){
        userBirthdayField.text = datePicker.date.convertDateToString()
        date = datePicker.date
        datePicker.removeFromSuperview()
    }
    
    
    
    func setDatePicker(){
        view.addSubview(datePicker)
        NSLayoutConstraint.activate([
            
            datePicker.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            datePicker.widthAnchor.constraint(equalToConstant: width/3),
            datePicker.heightAnchor.constraint(equalToConstant: 50)
            
            
        ])
        userBirthdayField.text = datePicker.date.convertDateToString()
   
    }
    
}

extension ChangeUserInformationViewControl:UITextFieldDelegate{
    
    //    this part helps user to see date picker also deletes field when first input is entered
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        DispatchQueue.main.async { [self] in
            if textField.restorationIdentifier != nil && textField.restorationIdentifier! == "birthday" {
                textField.endEditing(true)
                setDatePicker()
            }
        }
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.restorationIdentifier == "e-mail" ||  textField.restorationIdentifier == "nick"{
            textField.text = textField.text?.lowercased()
        }else{
            datePicker.removeFromSuperview()
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        datePicker.removeFromSuperview()
    }
    
   
}
