//
//  LogupView.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 31.03.2021.
//

import UIKit

class LogupViewModel:MutualLogView{
    
    var controller:((UIViewController)->())?
    var parentController:UIViewController?
    var delegate : LogupViewModelDelegate?
    
    let textStack:UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 10
        return stack
    }()
    
    let userNickCautionLabel:UILabel = {//Caution would appear, if  field is empty
        let label = UILabel()
        label.text = "nick girilmeli"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .systemBackground
        return label
    }()
    
    let userNickField :UITextField = {//nick field
        let field = UITextField()
        field.text = "nick"
        field.restorationIdentifier = "nick"
        field.layer.borderWidth = 0
        return field
    }()
    
    let line1Field:UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray6
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
        
    }()
    
    let userEmailCautionLabel:UILabel = {//Caution would appear, if  field is empty
        let label = UILabel()
        label.text = "böyle e-mail olmaz olsun"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .systemBackground
        return label
    }()
    let userEmailField :UITextField = {//email field
        let field = UITextField()
        field.keyboardType = .emailAddress
        field.textContentType = .emailAddress
        field.text = "e-mail"
        field.restorationIdentifier = "e-mail"

        field.layer.borderWidth = 0
        return field
    }()
    
    
    let line2Field:UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray6
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
        
    }()
    
    let userBirthdayCautionLabel:UILabel = {//Caution would appear, if  field is empty
        let label = UILabel()
        label.text = "ne zaman doğdun aga"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .systemBackground
        return label
    }()
    let userBirthdayField :UITextField = {//birthday field
        let field = UITextField()
        field.text = "doğum tarihi"
        field.restorationIdentifier = "birthday"
        field.layer.borderWidth = 0
        return field
    }()
    
    
    let line3Field:UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray6
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
        
    }()
    
    
    let genderStack : UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        return stack
    }()
    
    let genderLabel: UILabel = {
        let label = UILabel()
        label.text = "cinsiyetiniz"
        return label
    }()
    let genderSegment:UISegmentedControl = {
        let segment = UISegmentedControl(items: ["kadın","erkek","başka","boşver"])
        segment.selectedSegmentIndex = 0
        return segment
    }()
    
    let line4Field:UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray6
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
        
    }()
    
    let userPasswordCautionLabel:UILabel = {//Caution would appear, if  field is empty
        let label = UILabel()
        label.text = "aşağıda yazana az bir bak gözünü seveyim"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .systemBackground
        return label
    }()
    let userPasswordField :UITextField = {//birthday field
        let field = UITextField()
        field.text = "şifre"
        field.textContentType = .password
        field.layer.borderWidth = 0
        return field
    }()
    
    
    let line5Field:UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray6
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
        
    }()
    
    lazy var logupButton:UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 20
        button.backgroundColor = .systemGreen
        button.setTitle("kayıt ol işte böyle", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemBackground
        button.addTarget(self, action: #selector(logupButtonPressed), for: .touchUpInside)
        return button
    }()
    lazy var cancelButton:UIButton = {
        let button = UIButton()
        
        button.backgroundColor = .systemGray3
        button.setTitle("vazgeç", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemBackground
        button.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
        return button
    }()
    
    
    lazy var datePicker:UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.locale = Locale(identifier: "tr")
        picker.datePickerMode = .date
        picker.backgroundColor = .systemGray5
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        return picker
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        
        setTextStack()
        setLogupButton()
        setCancelButton()
        
        controller = { controller in
            self.parentController = controller
        }
        
        
        userBirthdayField.delegate = self
        userEmailField.delegate = self
        userNickField.delegate = self
        userPasswordField.delegate = self
        
        

    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    private func setTextStack(){
        setGenderStack()
        
        textStack.addArrangedSubview(userNickCautionLabel)
        textStack.addArrangedSubview(userNickField)
        textStack.addArrangedSubview(line1Field)
        textStack.addArrangedSubview(userEmailCautionLabel)
        textStack.addArrangedSubview(userEmailField)
        textStack.addArrangedSubview(line2Field)
        textStack.addArrangedSubview(userBirthdayCautionLabel)
        textStack.addArrangedSubview(userBirthdayField)
        textStack.addArrangedSubview(line3Field)
        textStack.addArrangedSubview(genderStack)
        textStack.addArrangedSubview(line4Field)
        textStack.addArrangedSubview(userPasswordCautionLabel)
        textStack.addArrangedSubview(userPasswordField)
        textStack.addArrangedSubview(line5Field)
        
        addSubview(textStack)
        NSLayoutConstraint.activate([
            textStack.widthAnchor.constraint(equalTo:widthAnchor),
            textStack.topAnchor.constraint(equalTo: buttonStack.bottomAnchor, constant: 100),
            line1Field.heightAnchor.constraint(equalToConstant: 2),
            line2Field.heightAnchor.constraint(equalToConstant: 2),
            line3Field.heightAnchor.constraint(equalToConstant: 2),
            line4Field.heightAnchor.constraint(equalToConstant: 2),
            line5Field.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
    
    private func setCancelButton(){
        addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            cancelButton.widthAnchor.constraint(equalTo: widthAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: leadingAnchor)
            
        ])
    }
    func setDatePicker(handler:()->()
    ){
        addSubview(datePicker)
        NSLayoutConstraint.activate([
            
            datePicker.bottomAnchor.constraint(equalTo: bottomAnchor),
            datePicker.leadingAnchor.constraint(equalTo: leadingAnchor)
            
            
        ])
        userBirthdayField.text = datePicker.date.convertDateToString()
        handler()
    }
    
    private func setLogupButton(){
        addSubview(logupButton)
        
        NSLayoutConstraint.activate([
            logupButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
            logupButton.heightAnchor.constraint(equalTo: faceButton.heightAnchor),
            logupButton.topAnchor.constraint(equalTo: textStack.bottomAnchor, constant: 50),
            logupButton.centerXAnchor.constraint(equalTo: centerXAnchor)
            
        ])
    }
    
    
    private func setGenderStack() {
        genderStack.addArrangedSubview(genderLabel)
        genderStack.addArrangedSubview(genderSegment)
    }
    @objc private func cancelPressed(){
        parentController?.dismiss(animated: true, completion: nil)
    }
    @objc func logupButtonPressed(){
        guard let email = userEmailField.text?.lowercased(),let password = userPasswordField.text, let nick = userNickField.text?.lowercased() else {return}
        
        let date = datePicker.date
        let user = UserStruct(email: email, nick: nick, password: password, gender: genderSegment.selectedSegmentIndex, birthday: date)
        
        delegate?.logupButtonClicked(user)
    }
    @objc func dateChanged(){
        userBirthdayField.text = datePicker.date.convertDateToString()
    }
    override func googlePressed() {
        delegate?.googleSignInPressed()
    }
   
}

extension LogupViewModel:UITextFieldDelegate{
    
   
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("burada yazı kayma efekti")
        return true
       
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.restorationIdentifier != nil && textField.restorationIdentifier! == "birthday" {
            
         
                cancelButton.removeFromSuperview()
            setDatePicker(){
                textField.resignFirstResponder()
            }
        }else{
            setCancelButton()
        }
        if textField.restorationIdentifier == "e-mail" ||  textField.restorationIdentifier == "nick"{
            
            textField.text = ""
        }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)

    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.restorationIdentifier == "e-mail" ||  textField.restorationIdentifier == "nick"{
            textField.text = textField.text?.lowercased()
        }
        return true
    }

}

protocol  LogupViewModelDelegate {
    func  logupButtonClicked(_ user:UserStruct)
    func googleSignInPressed()
}
