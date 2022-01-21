//
//  MovieListViewController.swift
//  MovieReview
//
//  Created by thoonk on 2022/01/21.
//

import UIKit
import SnapKit

final class MovieListViewController: UIViewController {
    private lazy var presenter = MovieListPresenter(viewController: self)
    
    private let searchController = UISearchController()
    
    private lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = presenter
        collectionView.delegate = presenter
        
        return collectionView
    }()

    override func viewDidLayoutSubviews() {
        super.viewDidLoad()
        
//        MovieSearchManager().request(from: "아이언맨") { movies in
//            print(movies)
//        }
        presenter.viewDidLoad()
    }
}

extension MovieListViewController: MovieListProtocol {
    func setupNavigation() {
        title = "영화 평점"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        self.navigationItem.searchController = searchController
    }
    
    func setupSearchBar() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = presenter
    }
    
    func setupLayout() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
