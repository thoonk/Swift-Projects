//
//  FeatureSectionView.swift
//  AppStore
//
//  Created by thoonk on 2021/12/08.
//

import UIKit
import SnapKit

final class FeatureSectionView: UIView {
    private var featureList = [Feature]()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
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
            FeatureSectionCollectionViewCell.self,
            forCellWithReuseIdentifier: FeatureSectionCollectionViewCell.identifier
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

extension FeatureSectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return featureList.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FeatureSectionCollectionViewCell.identifier,
            for: indexPath
        ) as? FeatureSectionCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        cell.setup(with: featureList[indexPath.item])
        
        return cell
    }
}

extension FeatureSectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = collectionView.frame.width - 32.0
        
        return CGSize(width: width, height: frame.width)
    }
    
    /// set alignment center
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        let value: CGFloat = 16.0
        return UIEdgeInsets(
            top: 0.0,
            left: value,
            bottom: 0.0,
            right: value
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 32.0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let feature = self.featureList[indexPath.item]
        let appInfo = AppInfo(appName: feature.appName, type: feature.description, imageURL: feature.imageURL)
        let appDetailVC = AppDetailViewController(appInfo: appInfo)
        if let appVC = self.parentViewController {
            appVC.navigationController?.pushViewController(appDetailVC, animated: true)
        }
    }
}

private extension FeatureSectionView {
    func setupView() {
        [collectionView, separatorView]
            .forEach { addSubview($0) }
        
        collectionView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview().inset(16.0)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(snp.width)
        }
        
        separatorView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalTo(collectionView.snp.bottom).offset(16.0)
            $0.bottom.equalToSuperview()
        }
    }
    
    func fetchData() {
        guard let url = Bundle.main.url(forResource: "Feature", withExtension: "plist")
        else { return }
        
        do {
            let data = try Data(contentsOf: url)
            let result = try PropertyListDecoder().decode([Feature].self, from: data)
            
            self.featureList = result
            self.collectionView.reloadData()
        } catch {
            debugPrint("Error Fetch Feature Data: \(error.localizedDescription)")
        }
    }
}
