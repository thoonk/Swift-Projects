//
//  HomeVC.swift
//  NetflixDemo
//
//  Created by 김태훈 on 2021/11/09.
//

import UIKit
import SwiftUI

class HomeVC: UICollectionViewController {
    var contents = [Content]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 네비게이션 설정
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.hidesBarsOnSwipe = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "netflix_icon"), style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle"), style: .plain, target: nil, action: nil)
        
        // 데이터 설정 및 가져오기
        self.contents = getContents()
        
        // Collectonview Item 설정
        collectionView.register(ContentCell.self, forCellWithReuseIdentifier: "ContentCell")
        collectionView.register(ContentHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ContentHeader")
    }
    
    func getContents() -> [Content] {
        guard let path = Bundle.main.path(forResource: "Content", ofType: "plist"),
              let data = FileManager.default.contents(atPath: path),
              let list = try? PropertyListDecoder().decode([Content].self, from: data) else { return [] }
        return list
    }
}

extension HomeVC {
    // 섹션당 보여질 셀의 개수
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return contents[section].contentItem.count
        }
    }
    
    // 섹션 개수 설정
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return contents.count
    }
    
    // 콜렉션뷰 셀 설정
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch contents[indexPath.section].sectionType {
        case .basic, .large:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCell", for: indexPath) as? ContentCell else { return UICollectionViewCell() }
            
            cell.imageView.image = contents[indexPath.section].contentItem[indexPath.row].image
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    // 헤더뷰 설정
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ContentHeader", for: indexPath) as? ContentHeader else { fatalError("Could not dequeue header")}
            
            headerView.sectionNameLabel.text = contents[indexPath.section].sectionName
            return headerView
        } else {
            return UICollectionReusableView()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionName = contents[indexPath.section].sectionName
        debugPrint("\(sectionName)섹션의 \(indexPath.row + 1)번째 콘텐츠")
    }
}

// Preview
struct HomeVCPreview: PreviewProvider {
    static var previews: some View {
        Container().edgesIgnoringSafeArea(.all)
    }
    
    struct Container: UIViewControllerRepresentable {

        func makeUIViewController(context: Context) -> UIViewController {
            let layout = UICollectionViewLayout()
            let homeVC = HomeVC(collectionViewLayout: layout)
            return UINavigationController(rootViewController: homeVC)
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
        
        typealias UIViewControllerType = UIViewController
    }
}
