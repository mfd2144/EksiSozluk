//
//  AddNewCommentViewController.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 6.04.2021.
//

import UIKit

class AddNewCommentViewController: UIViewController {
    var commentString:String?{
        didSet{
            entryLabel.text = commentString
        }
    }
    let model = AddNewCommentModel()
    
    let entryLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let addButton:UIButton = {
        let button = UIButton()
        button.setTitle("yolla", for: .normal)
        button.setTitleColor(.systemGreen, for: .normal)
        return button
    }()
    
    let cancelButton:UIButton = {
        let button = UIButton()
        button.setTitle("vazgeç", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    let buttonStack:UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let commentText:UITextView = {
       let text = UITextView()
        text.becomeFirstResponder()
        text.textAlignment = .justified
        
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setViews()
        addButtonTargets()
        
    }
    
    private func setViews(){
        buttonStack.addArrangedSubview(cancelButton)
        buttonStack.addArrangedSubview(addButton)
        view.addSubview(buttonStack)
        view.addSubview(entryLabel)
        view.addSubview(commentText)
        
        NSLayoutConstraint.activate([
                                        buttonStack.topAnchor.constraint(equalTo: view.topAnchor),
                                        buttonStack.widthAnchor.constraint(equalTo: view.widthAnchor,multiplier: 0.90),
                                        buttonStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            entryLabel.topAnchor.constraint(equalTo: buttonStack.bottomAnchor,constant: 20),
            entryLabel.widthAnchor.constraint(equalTo: buttonStack.widthAnchor),
            entryLabel.centerXAnchor.constraint(equalTo: buttonStack.centerXAnchor),
            commentText.topAnchor.constraint(equalTo: entryLabel.bottomAnchor,constant: 20),
            commentText.widthAnchor.constraint(equalTo: buttonStack.widthAnchor),
            commentText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            commentText.heightAnchor.constraint(equalToConstant: 200)
            
            
    ])
    }
    
    private func addButtonTargets(){
        cancelButton.addTarget(self, action: #selector(cancelClicked(_:)), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(addClicked(_:)), for: .touchUpInside)
    }
    
    @objc private func addClicked(_ sender:UIButton){
        if commentText.text != nil,commentText.text != ""{
            model.addNewComment(text: commentText.text!)
            self.dismiss(animated: true, completion: nil)
        }
      
    }
    @objc private func cancelClicked(_ sender:UIButton){
        self.dismiss(animated: true, completion: nil)
    }

}
