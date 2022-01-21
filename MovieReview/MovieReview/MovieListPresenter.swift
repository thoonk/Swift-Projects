//
//  MovieListPresenter.swift
//  MovieReview
//
//  Created by thoonk on 2022/01/21.
//

import UIKit

protocol MovieListProtocol: AnyObject {
    func setupNavigation()
    func setupSearchBar()
    func setupLayout()
}

final class MovieListPresenter: NSObject {
    private unowned var viewController: MovieListProtocol?
    
    init(viewController: MovieListProtocol) {
        self.viewController = viewController
    }
    
    func viewDidLoad() {
        viewController?.setupNavigation()
        viewController?.setupSearchBar()
        viewController?.setupLayout()
    }
}

extension MovieListPresenter: UISearchBarDelegate {
    
}

extension MovieListPresenter: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

extension MovieListPresenter: UICollectionViewDelegate {
    
}
