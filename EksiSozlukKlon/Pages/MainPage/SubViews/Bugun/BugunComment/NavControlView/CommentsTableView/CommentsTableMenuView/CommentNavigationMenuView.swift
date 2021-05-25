//
//  CommentNavigationMenuView.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 4.04.2021.
//

import UIKit


class CommentNavMenuView:CommentNavTopComponent{
    
    weak var pageControlDelegate:PageControlDelegate?
    weak var pageControlDataSource:PageControlDataSource?
    
    var totalPageNumber:Int?
    var currentPage:Int=1
    
    let buttonFirst:UIButton = {
        let button = UIButton()
        button.setTitle("first", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 3
        button.translatesAutoresizingMaskIntoConstraints = true
        return button
    }()
    let buttonLast:UIButton = {
        let button = UIButton()
        button.setTitle("last", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 3
        button.frame.size = CGSize(width: 40, height: 20)
        button.translatesAutoresizingMaskIntoConstraints = true
        return button
    }()
    
    let buttonPrevious:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 3
        button.frame.size = CGSize(width: 40, height: 20)
        button.translatesAutoresizingMaskIntoConstraints = true
        return button
    }()
    let buttonNext:UIButton={
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 3
        button.frame.size = CGSize(width: 40, height: 20)
        button.translatesAutoresizingMaskIntoConstraints = true
        return button
    }()
    
    let arrowButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrowtriangle.down.fill"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 3
        button.frame.size = CGSize(width: 40, height: 20)
       
        return button
    }()
    
    let labelPageNumber :UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemGray6
        label.frame.size = CGSize(width: 80, height: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    let middleStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 0
        return stack
    }()
    
    let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 10
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func otherSettings() {
        addTargetToButtons()
        addAndSetViews()
       getTotalPage()
    }
    
    func getTotalPage(){
        if pageControlDataSource?.returnTotalPage() == nil{
            Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block:{_ in
                self.getTotalPage()
            })
           
        }else{
            totalPageNumber = pageControlDataSource?.returnTotalPage()
            labelPageNumber.text = String(currentPage)+"/"+String(totalPageNumber!)
        }
        
    }
    
    private func addAndSetViews(){
        middleStack.addArrangedSubview(labelPageNumber)
        middleStack.addArrangedSubview(arrowButton)
        mainStack.addArrangedSubview(buttonFirst)
        mainStack.addArrangedSubview(buttonPrevious)
        mainStack.addArrangedSubview(middleStack)
        mainStack.addArrangedSubview(buttonNext)
        mainStack.addArrangedSubview(buttonLast)
        addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topComponentStack.bottomAnchor),
            mainStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainStack.heightAnchor.constraint(equalToConstant: 40),
            
            buttonFirst.heightAnchor.constraint(equalToConstant: 25),
            buttonFirst.widthAnchor.constraint(equalToConstant: 50),
            
            buttonLast.heightAnchor.constraint(equalToConstant: 25),
            buttonLast.widthAnchor.constraint(equalToConstant: 50),
            
            
            buttonPrevious.heightAnchor.constraint(equalToConstant: 25),
            buttonPrevious.widthAnchor.constraint(equalToConstant: 50),
            
            
            buttonNext.heightAnchor.constraint(equalToConstant: 25),
            buttonNext.widthAnchor.constraint(equalToConstant: 50),
            
            
            labelPageNumber.heightAnchor.constraint(equalToConstant: 25),
            labelPageNumber.widthAnchor.constraint(equalToConstant: 40),
    
        ])
        
    }
     private func addTargetToButtons(){
        buttonFirst.addTarget(self, action: #selector(firstButtonPressed(_:)), for: .touchUpInside)
        buttonLast.addTarget(self, action: #selector(lastButtonPressed(_:)), for: .touchUpInside)
        buttonNext.addTarget(self, action: #selector(nextButtonPressed(_:)), for: .touchUpInside)
        buttonPrevious.addTarget(self, action: #selector(previousButtonPressed(_:)), for: .touchUpInside)
        arrowButton.addTarget(self, action: #selector(arrowButtonPressed(_:)), for: .touchUpInside)

        
    }
    
    @objc private func firstButtonPressed(_ sender:UIButton){
        pageControlDelegate?.firstPage()
    }
    @objc private func lastButtonPressed(_ sender:UIButton){
        pageControlDelegate?.lastPage()
    }
    @objc private func nextButtonPressed(_ sender:UIButton){
        pageControlDelegate?.nextPage()
    }
    @objc private func previousButtonPressed(_ sender:UIButton){
        pageControlDelegate?.previousPage()
    }
    @objc private func arrowButtonPressed(_ sender:UIButton){
        pageControlDelegate?.goToPage(page: 1)
    }
    
}

protocol PageControlDelegate:AnyObject{
    func nextPage()
    func previousPage()
    func lastPage()
    func firstPage()
    func goToPage(page:Int)
}

protocol PageControlDataSource:AnyObject{
    func returnTotalPage()->Int?
}
