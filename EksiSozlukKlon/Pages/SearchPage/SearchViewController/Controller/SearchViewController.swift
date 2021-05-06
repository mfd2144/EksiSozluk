//
//  SearchPAge.swift
//  EksiSozlukKlon
//
//  Created by Mehmet fatih DOĞAN on 29.03.2021.
//

import UIKit



class SearchViewController: UIViewController{

    var collectionView:UICollectionView?
    let customLayoutProvider = CollectionCompotionalLayoutProvider()
    let searchBarController = UISearchController(searchResultsController:nil)
    let model = SearchViewControllerModel()
    var mostFollowed:[MostFollowedStruct]?{
        didSet{
            collectionView?.reloadData()
        }
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mostFollowed = AppSingleton.shared.mostFollowed?.sorted(by: { $0.category < $1.category })
        navigationController?.navigationBar.topItem?.title = "search"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: customLayoutProvider.getCollectionViewLayout())
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.register(SearchCollectionCell.self, forCellWithReuseIdentifier: SearchCollectionCell.cellIdentifier)
        collectionView?.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderReusableView.headerReusableIdentifier)
        collectionView?.backgroundColor = .systemBackground
        
        
        navigationItem.searchController = searchBarController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchBarController.searchBar.delegate = self
        searchBarController.searchBar.backgroundColor = .systemBackground
}


    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        guard let collectionV = collectionView else {
            return
        }
        view.addSubview(collectionV)
        collectionV.frame = view.bounds
    }
 
   
}



extension SearchViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        mostFollowed?.count ?? 0
    }

     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var itemNumber = 0
        guard let mostFollowed = mostFollowed else {return itemNumber}
        for (index,subCategory) in mostFollowed.enumerated(){
            if index == section{
                itemNumber = subCategory.entries.count
                return itemNumber
            }

        }
        return itemNumber
    }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionCell.cellIdentifier, for: indexPath) as? SearchCollectionCell ,let mostFollowed = mostFollowed else {return UICollectionViewCell()}
        for (index,subCategory) in mostFollowed.enumerated(){
            if index == indexPath.section{
                let entry = subCategory.entries[indexPath.row]
                cell.entryStruct = entry
            }
        
    }
        return cell

}

    
     func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
         guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderReusableView.headerReusableIdentifier , for: indexPath) as? HeaderReusableView,
               let mostFollowed = mostFollowed else {return UICollectionReusableView()}
        
        
        for (index,subCategory) in mostFollowed.enumerated(){
            if index == indexPath.section{
                header.sectionName = subCategory.category
            }

    }
    
        return header
}

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let commentVC = CommentsTableViewController()
        guard let id = mostFollowed?[indexPath.section].entries[indexPath.row].documentID  else { return }
        AppSingleton.shared.entryID = id
        navigationController?.pushViewController(commentVC, animated: true)
        
    }




}


extension SearchViewController:UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.text = searchText.lowercased()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text ,text != "" else {
            
            return
        }
        searchBar.text = ""
        searchBar.endEditing(true)
        model.searchEntries(with: text){ entries in
            print(entries)
            
        }
    }
}
