//
//  MovieDetailViewController.swift
//  MovieReview
//
//  Created by thoonk on 2022/01/26.
//

import UIKit
import SnapKit
import Kingfisher

final class MovieDetailViewController: UIViewController {
    
    private var presenter: MovieDetailPresenter!
    
    private lazy var imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .secondarySystemBackground
        
        return imageView
    }()
    
    init(movie: Movie) {
        super.init(nibName: nil, bundle: nil)
        
        presenter = MovieDetailPresenter(viewController: self, movie: movie)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
}

extension MovieDetailViewController: MovieDetailProtocol {
    func setupLayout(with movie: Movie) {
        view.backgroundColor = .systemBackground
        navigationItem.title = movie.title
        
        let userRatingContentsStackView = MovieContentsStackView(title: "평점", contents: movie.userRating)
        
        let actorContentsStackView = MovieContentsStackView(title: "배우", contents: movie.actor)
        
        let directContentsStackView = MovieContentsStackView(title: "감독", contents: movie.director)
        
        let pubDateContentsStackView = MovieContentsStackView(title: "제작년도", contents: movie.pubDate)
        
        let contentsStackView = UIStackView()
        contentsStackView.axis = .vertical
        contentsStackView.spacing = 8.0
        
        [
            userRatingContentsStackView,
            actorContentsStackView,
            directContentsStackView,
            pubDateContentsStackView
        ]
            .forEach { contentsStackView.addArrangedSubview($0) }
        
        [
            imageView,
            contentsStackView
        ]
            .forEach { view.addSubview($0) }
        
        let inset: CGFloat = 16.0
        imageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).inset(inset)
            $0.leading.trailing.equalToSuperview().inset(inset)
            $0.height.equalTo(imageView.snp.width)
        }
        
        contentsStackView.snp.makeConstraints {
            $0.leading.trailing.equalTo(imageView)
            $0.top.equalTo(imageView.snp.bottom).offset(inset)
        }
        
        if let imageURL = movie.imageURL {
            imageView.kf.setImage(with: imageURL)
        }
    }
}
