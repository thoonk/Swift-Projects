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
    func updateSearchTableView(isHidden: Bool)
    func pushToMovieDetailViewController(with movie: Movie)
}

final class MovieListPresenter: NSObject {
    private unowned var viewController: MovieListProtocol?
    private let movieSearchManger: MovieSearchManagerProtocol
    
    private var likedMovies: [Movie] = [
        Movie(title: "배고파", imageURL: "", pubDate: "2022", director: "존슨즈", actor: "ㅁㄴㅇㄹ", userRating: "5.0"),
        Movie(title: "배고파", imageURL: "", pubDate: "2022", director: "존슨즈", actor: "ㅁㄴㅇㄹ", userRating: "5.0"),

        Movie(title: "배고파", imageURL: "", pubDate: "2022", director: "존슨즈", actor: "ㅁㄴㅇㄹ", userRating: "5.0")
    ]
    
    private var currentMovieSearchResult = [Movie]()
     
    init(
        viewController: MovieListProtocol,
        movieSearchManger: MovieSearchManagerProtocol = MovieSearchManager()
    ) {
        self.viewController = viewController
        self.movieSearchManger = movieSearchManger
    }
    
    func viewDidLoad() {
        viewController?.setupNavigation()
        viewController?.setupSearchBar()
        viewController?.setupLayout()
    }
}

// MARK: - UISearchBarDelegate
extension MovieListPresenter: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        viewController?.updateSearchTableView(isHidden: false)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        currentMovieSearchResult = []
        viewController?.updateSearchTableView(isHidden: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        movieSearchManger.request(from: searchText) { [weak self] movies in
            self?.currentMovieSearchResult = movies
            self?.viewController?.updateSearchTableView(isHidden: false)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension MovieListPresenter: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return likedMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MovieListCollectionViewCell.identifier,
            for: indexPath
        ) as? MovieListCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: likedMovies[indexPath.item])

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MovieListPresenter: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewController?.pushToMovieDetailViewController(with: self.likedMovies[indexPath.item])
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        let spacing: CGFloat = 16.0
        let width: CGFloat = (collectionView.frame.width - spacing * 3) / 2
        return CGSize(width: width, height: 210.0)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        let inset: CGFloat = 16.0
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
}

// MARK: - UITableViewDataSource
extension MovieListPresenter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.currentMovieSearchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = currentMovieSearchResult[indexPath.row].title
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MovieListPresenter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewController?.pushToMovieDetailViewController(with: self.currentMovieSearchResult[indexPath.row])
    }
}
