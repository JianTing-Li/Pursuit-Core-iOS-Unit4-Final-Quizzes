//
//  SearchQuizView.swift
//  Quizzes
//
//  Created by Jian Ting Li on 2/1/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

protocol SearchQuizViewDelegate: AnyObject {
    func setupNumberOfItemsInCollectionView() -> Int
    func setupCollectionViewCell(indexPath: IndexPath) -> UICollectionViewCell
}

class SearchQuizView: UIView {
    
    weak var deleagte: SearchQuizViewDelegate?
    
    lazy var searchQuizesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize.init(width: 350, height: 350)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let cv = UICollectionView.init(frame: frame, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(hexString: "#74b9ff")
        cv.dataSource = self
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        addSubview(searchQuizesCollectionView)
        backgroundColor = UIColor.init(hexString: "#0984e3")
        setConstraints()
    }
    
    private func setConstraints() {
        searchQuizesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        searchQuizesCollectionView.register(SearchCell.self, forCellWithReuseIdentifier: "SearchCell")
        
        searchQuizesCollectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        searchQuizesCollectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        searchQuizesCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        searchQuizesCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
    }
}

extension SearchQuizView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return deleagte?.setupNumberOfItemsInCollectionView() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return deleagte?.setupCollectionViewCell(indexPath: indexPath) ?? UICollectionViewCell()
    }
    
}
