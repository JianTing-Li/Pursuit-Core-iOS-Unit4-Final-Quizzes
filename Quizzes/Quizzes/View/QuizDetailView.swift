//
//  QuizDetailView.swift
//  Quizzes
//
//  Created by Jian Ting Li on 2/1/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

protocol QuizDetailViewDelegate: AnyObject {
    func getNumberOfFacts() -> Int
    func setCollectionViewCell(indexPath: IndexPath) -> UICollectionViewCell
}

class QuizDetailView: UIView {
    
    weak var delegate: QuizDetailViewDelegate?
    
    lazy var quizDetailCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize.init(width: 100, height: 200)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let cv = UICollectionView.init(frame: frame, collectionViewLayout: layout)
        cv.dataSource = self
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension QuizDetailView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate?.getNumberOfFacts() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return delegate?.setCollectionViewCell(indexPath: indexPath) ?? UICollectionViewCell()
    }
}
