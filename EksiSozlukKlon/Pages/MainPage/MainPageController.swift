//
//  MainPage.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 29.03.2021.
//

import UIKit

class MainPageController: UIViewController {
    var id:String?
    
    let collectionView:UICollectionView = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(80), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        let layout = UICollectionViewCompositionalLayout(section: section)
        let collection = UICollectionView(frame: CGRect(x: 0,  y: 0, width: UIScreen.main.bounds.width, height: 60), collectionViewLayout: layout)
        collection.backgroundColor = .systemBackground
        collection.register(MainPageCell.self, forCellWithReuseIdentifier: "ReusableCell")
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.showsHorizontalScrollIndicator = false
        
    
        return collection
    }()
    
    let pageControl :UIPageControl = {
       let pageControl = UIPageControl()
        pageControl.numberOfPages = 9
        pageControl.currentPage = 0
        pageControl.isHidden = true
        return pageControl
    }()
    
    let viewModel = MainPageViewModel()
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            viewModel.selectedSubView?(Collections.init(value: pageControl.currentPage)!)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addModelView()
        collectionView.delegate = self
        collectionView.dataSource = self
        viewModel.delegate = self
        viewModel.parentController?(self)
        
    }
    
    func addModelView(){
        view.addSubview(collectionView)
        view.addSubview(viewModel)
        collectionView.addSubview(pageControl)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 50),
            viewModel.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            viewModel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            viewModel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewModel.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        
    }
    
}


//MARK: - Set collection view

extension MainPageController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReusableCell", for: indexPath) as? MainPageCell else {return UICollectionViewCell()}
        cell.returnCellName(Collections.init(value: indexPath.row)!.rawValue,delegate:self)
        cell.selectedCell?(pageControl.currentPage)
        return cell
    }

}

extension MainPageController:MainPageCellDelegate{
  
    func cellPressed(name: String) {
        let cellNumber = (Collections.init(rawValue: name)?.value)!
       pageControl.currentPage = cellNumber
        let indexPath = IndexPath(item: cellNumber, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        scrollToPage(cellNumber)
        
    }
    
    func scrollToPage(_ page:Int){
        let xPoint = CGFloat(page)*UIScreen.main.bounds.width
        let cgPoint = CGPoint(x: xPoint, y: 0)
        viewModel.scrollView.setContentOffset(cgPoint, animated: true)
        collectionView.reloadData()
        guard let collectionSelected = Collections.init(value: page) else {return}
        viewModel.selectedSubView?(collectionSelected)
    }
    
}

extension MainPageController:MainPageViewModelDelegate{
    func changePage(upOrDown: Int) {
    
        let goToPage = pageControl.currentPage + upOrDown
        if goToPage >= 0 && goToPage < 9{
            pageControl.currentPage = goToPage
            scrollToPage(goToPage)
        }
    }
    
    
}

