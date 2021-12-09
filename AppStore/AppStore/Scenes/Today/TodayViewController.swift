//
//  TodayViewController.swift
//  AppStore
//
//  Created by MA2103 on 2021/12/08.
//

import UIKit
import SnapKit

final class TodayViewController: UIViewController {
    private var todayList = [Today]()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.backgroundColor = .systemBackground
        collectionView.register(
            TodayCollectionViewCell.self,
            forCellWithReuseIdentifier: TodayCollectionViewCell.identifier
        )
        collectionView.register(
            TodayCollectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TodayCollectionHeaderView.identifier
        )
         
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        fetchData()
    }
}

extension TodayViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return todayList.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let todayCell = collectionView
                .dequeueReusableCell(
                    withReuseIdentifier: TodayCollectionViewCell.identifier,
                    for: indexPath
                ) as? TodayCollectionViewCell
        else {
            return UICollectionViewCell()
        }

        todayCell.setup(with: self.todayList[indexPath.item])

        return todayCell
    }
    
    /// header, footer 모두 이 메서드에서 처리 -> 분기 처리 해줘야 함.
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TodayCollectionHeaderView.identifier,
                for: indexPath
              ) as? TodayCollectionHeaderView
        else {
            return UICollectionReusableView()
        }
        
        header.setup()
        
        return header
    }
}

extension TodayViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = collectionView.frame.width - 32.0
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return CGSize(
            width: collectionView.frame.width - 32.0,
            height: 100
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        let value: CGFloat = 16.0
        return UIEdgeInsets(
            top: value,
            left: value,
            bottom: value,
            right: value
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let today = todayList[indexPath.item]
        let appInfo = AppInfo(appName: today.title, type: today.subTitle, imageURL: today.imageURL)
        let appDetailVC = AppDetailViewController(appInfo: appInfo)
        present(appDetailVC, animated: true)
    }
}

private extension TodayViewController {
    func fetchData() {
        guard let url = Bundle.main.url(forResource: "Today", withExtension: "plist")
        else { return }
        
        do {
            let data = try Data(contentsOf: url)
            let result = try PropertyListDecoder().decode([Today].self, from: data)
            
            self.todayList = result
            self.collectionView.reloadData()
        } catch {
            debugPrint("Error Fetch Today Data: \(error.localizedDescription)")
        }
    }
}
