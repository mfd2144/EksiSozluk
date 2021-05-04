//
//  File.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 29.03.2021.
//

import Foundation


import UIKit


class MainPageViewModel:BasicView{
    var start:CGFloat = 0
    var delegate:MainPageViewModelDelegate?
    var difference:CGFloat=0
    var parent:UIViewController?
    var selectedSubView:((Collections)->())?//with this closure view communicate controller and learn which view add on scrool view
    
    
    lazy var scrollView:UIScrollView={
        let bounds = UIScreen.main.bounds
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = true
        scroll.contentSize = CGSize(width: 5*bounds.width, height:self.frame.height)//Scrollview have 5 horizantal view on it
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    
    override func startingOptions() {
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        addViewConstraints()
        parentController = { [self] controller in
            parent = controller
        }
        
        //        swipe action on scroll view
        let pan = UIPanGestureRecognizer(target: self, action: #selector(scrollDidChange(_ :)))//add swipe gesture recognizer because page will change completely as its original source
        pan.delegate = self
        
        scrollView.addGestureRecognizer(pan)
        scrollView.isUserInteractionEnabled = true
        
        
//        program add view which selected by user via collection view
        selectedSubView = { [self] collection in
            let newSubview = collection.view
            let screenWidth = UIScreen.main.bounds.width
            let point = CGPoint(x: screenWidth * CGFloat(collection.value), y: 0)
            let size = CGSize(width: screenWidth, height: self.frame.height)
            newSubview.frame = CGRect(origin: point, size: size)
            self.scrollView.addSubview(newSubview)
            guard let _ = parent else {return}
            (newSubview as? BasicView)?.parentController?(parent!) //send parent controller 
            
        }
    }
    
    
    
    func addViewConstraints(){
        NSLayoutConstraint.activate([
                                        scrollView.topAnchor.constraint(equalTo: topAnchor),
                                        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
                                        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
                                        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor)])
    }
    
    
    @objc func scrollDidChange(_ gesture:UIPanGestureRecognizer){
        switch gesture.state {
        case .began://when start state change
            start = scrollView.contentOffset.x
        case.changed://It finished
            difference = scrollView.contentOffset.x - start
            guard scrollView.contentOffset.x > UIScreen.main.bounds.width else {return}
        case.ended:
            if difference > 0{
                delegate?.changePage(upOrDown: 1)
            }else if difference < 0{
                delegate?.changePage(upOrDown: -1)
            }
            
        default: return
        }
    }
}


extension MainPageViewModel:UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        //        I added this method otherwise scrollview doesn't recognize scroll movement
        return true
    }
}


protocol MainPageViewModelDelegate{
   
    func changePage(upOrDown:Int)
}
