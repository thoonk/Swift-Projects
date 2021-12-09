//
//  RankingFeatureSectionView.swift
//  AppStore
//
//  Created by MA2103 on 2021/12/09.
//

import UIKit
import SnapKit

final class RankingFeatureSectionView: UIView {
    private var rankingFeatureList = [RankingFeature]()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "iPhone이 처음이라면"
        label.font = .systemFont(ofSize: 18.0, weight: .black)
        
        return label
    }()
    
    private lazy var viewAllButton: UIButton = {
        let button = UIButton()
        button.setTitle("모두 보기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .semibold)
        button.setTitleColor(.systemBlue, for: .normal)
        
        return button
    }()
    
    private lazy var collectionView: UICollectionView  = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 32.0
        layout.minimumInteritemSpacing = 0.0
        layout.sectionInset = UIEdgeInsets(
            top: 0.0,
            left: 16.0,
            bottom: 0.0,
            right: 16.0
        )
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(
            RankingFeatureSectionCollectionViewCell.self,
            forCellWithReuseIdentifier: RankingFeatureSectionCollectionViewCell.identifier
        )

        return collectionView
    }()
    
    private let separatorView = SeparatorView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        fetchData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension RankingFeatureSectionView {
    func setupView() {
        [titleLabel, viewAllButton, collectionView, separatorView]
            .forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16.0)
            $0.top.equalToSuperview().inset(16.0)
            $0.trailing.equalTo(viewAllButton.snp.leading).offset(8.0)
        }
        
        viewAllButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.0)
            $0.trailing.equalToSuperview().inset(16.0)
            $0.bottom.equalTo(titleLabel.snp.bottom)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16.0)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(RankingFeatureSectionCollectionViewCell.height * 3)
        }
        
        separatorView.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(16.0)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

extension RankingFeatureSectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        rankingFeatureList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RankingFeatureSectionCollectionViewCell.identifier,
            for: indexPath
        ) as? RankingFeatureSectionCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        cell.setup(with: rankingFeatureList[indexPath.item])
        
        return cell
    }
}

extension RankingFeatureSectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
    return CGSize(
        width: collectionView.frame.width - 32.0,
        height: RankingFeatureSectionCollectionViewCell.height
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let rankingFeature = self.rankingFeatureList[indexPath.item]
        let appInfo = AppInfo(appName: rankingFeature.title, type: rankingFeature.description)
        let appDetailVC = AppDetailViewController(appInfo: appInfo)
        if let appVC = self.parentViewController {
            appVC.navigationController?.pushViewController(appDetailVC, animated: true)
        }
    }
}

// MARK: - Private Methods
private extension RankingFeatureSectionView {
    func fetchData() {
        guard let url = Bundle.main.url(forResource: "RankingFeature", withExtension: "plist")
        else { return }
        
        do {
            let data = try Data(contentsOf: url)
            let result = try PropertyListDecoder().decode([RankingFeature].self, from: data)
            
            self.rankingFeatureList = result
            self.collectionView.reloadData()
        } catch {
            debugPrint("Error Fetch RankingFeatures Data: \(error.localizedDescription)")
        }
    }
}

extension UIResponder {
    public var parentViewController: UIViewController? {
        return next as? AppViewController ?? next?.parentViewController
    }
}
