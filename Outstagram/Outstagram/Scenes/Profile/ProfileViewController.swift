//
//  ProfileViewController.swift
//  Outstagram
//
//  Created by MA2103 on 2021/12/16.
//

import UIKit
import SnapKit

final class ProfileViewController: UIViewController {
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.quaternaryLabel.cgColor
        
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "thoonk"
        label.font = .systemFont(ofSize: 14.0, weight: .semibold)
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello ~_~"
        label.font = .systemFont(ofSize: 14.0, weight: .medium)
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton()
        button.setTitle("팔로우", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .semibold)
        button.layer.cornerRadius = 3.0
        button.backgroundColor = .systemBlue
        button.setTitleColor(UIColor.white, for: .normal)
        
        return button
    }()
    
    private lazy var messageButton: UIButton = {
        let button = UIButton()
        button.setTitle("메시지", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .semibold)
        button.layer.cornerRadius = 3.0
        button.backgroundColor = .white
        button.setTitleColor(UIColor.label, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray4.cgColor

        return button
    }()
    
    private let feedDataView = ProfileDataView(title: "게시물", count: 53)
    private let followerDataView = ProfileDataView(title: "팔로워", count: 2_000)
    private let followingDataView = ProfileDataView(title: "팔로잉", count: 123)
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0.5
        layout.minimumInteritemSpacing = 0.5
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(
            ProfileCollectionViewCell.self,
            forCellWithReuseIdentifier: ProfileCollectionViewCell.identifier
        )
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupLayout()
    }
}

extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 15
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProfileCollectionViewCell.identifier,
            for: indexPath
        ) as? ProfileCollectionViewCell
        else { return UICollectionViewCell() }
        
        cell.setup()
        
        return cell
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width: CGFloat = (collectionView.frame.width / 3) - 1.0
        return CGSize(width: width, height: width)
    }
}


private extension ProfileViewController {
    func setupNavigationBar() {
        navigationItem.title = "thoonk"

        let ellipsisButton = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis"),
            style: .plain,
            target: self,
            action: #selector(didTapEllipsisButton)
        )
        
        navigationItem.rightBarButtonItem = ellipsisButton
    }
    
    @objc func didTapEllipsisButton() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        [
            UIAlertAction(title: "회원 정보 변경", style: .default),
            UIAlertAction(title: "탈퇴하기", style: .destructive),
            UIAlertAction(title: "닫기", style: .cancel)
        ].forEach { actionSheet.addAction($0) }
        
        present(actionSheet, animated: true)
    }
    
    func setupLayout() {
        let buttonStackView = UIStackView(arrangedSubviews: [followButton, messageButton])
        buttonStackView.spacing = 4.0
        buttonStackView.distribution = .fillEqually
        
        let dataStackView = UIStackView(arrangedSubviews: [
            feedDataView, followerDataView, followingDataView
        ])
        
        dataStackView.spacing = 4.0
        dataStackView.distribution = .fillEqually
        
        [
            profileImageView,
            dataStackView,
            nameLabel,
            descriptionLabel,
            buttonStackView,
            collectionView
        ].forEach { view.addSubview($0) }
        
        let inset: CGFloat = 16.0
        
        profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(inset)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(inset)
            $0.width.equalTo(80.0)
            $0.height.equalTo(profileImageView.snp.width)
        }
        
        dataStackView.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(inset)
            $0.trailing.equalToSuperview().inset(inset)
            $0.centerY.equalTo(profileImageView.snp.centerY)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.leading)
            $0.trailing.equalToSuperview().inset(inset)
            $0.top.equalTo(profileImageView.snp.bottom).offset(12.0)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalTo(nameLabel.snp.leading)
            $0.trailing.equalTo(nameLabel.snp.trailing)
            $0.top.equalTo(nameLabel.snp.bottom).offset(6.0)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.leading.equalTo(nameLabel.snp.leading)
            $0.trailing.equalTo(nameLabel.snp.trailing)
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(12.0)
        }
        
        collectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(buttonStackView.snp.bottom).offset(16.0)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

