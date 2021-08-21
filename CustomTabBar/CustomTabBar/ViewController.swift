//
//  ViewController.swift
//  CustomTabBar
//
//  Created by 김태훈 on 2021/08/20.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - Interface Builder
    private lazy var pageCollectionView: UICollectionView = {
       let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Properties
    private var menuBar = MenuBar()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMenuBar()
        setupPageCollectionView()
    }
    
    // MARK: - Methods
    private func setupMenuBar() {
        menuBar.menuBarDelegate = self
        menuBar.translatesAutoresizingMaskIntoConstraints = false
        menuBar.indicatorViewWidthConstraint.constant = self.view.frame.width / 4
        
        self.view.addSubview(menuBar)
        menuBar
            .leadingAnchor
            .constraint(equalTo: self.view.leadingAnchor)
            .isActive = true
        menuBar
            .trailingAnchor
            .constraint(equalTo: self.view.trailingAnchor)
            .isActive = true
        menuBar
            .topAnchor
            .constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
            .isActive = true
        menuBar
            .indicatorViewWidthConstraint
            .constant = self.view.frame.width / 4
        menuBar
            .heightAnchor
            .constraint(equalToConstant: 60)
            .isActive = true
    }

    private func setupPageCollectionView() {
        pageCollectionView.dataSource = self
        pageCollectionView.delegate = self
        pageCollectionView.showsHorizontalScrollIndicator = false
        pageCollectionView.backgroundColor = .systemGray4
        pageCollectionView.isPagingEnabled = true
        pageCollectionView.register(UINib(nibName: PageCollectionViewCell.name, bundle: nil), forCellWithReuseIdentifier: PageCollectionViewCell.id)
        
        self.view.addSubview(pageCollectionView)
        pageCollectionView
            .leadingAnchor
            .constraint(equalTo: self.view.leadingAnchor)
            .isActive = true
        pageCollectionView
            .trailingAnchor
            .constraint(equalTo: self.view.trailingAnchor)
            .isActive = true
        pageCollectionView
            .topAnchor
            .constraint(equalTo: self.menuBar.bottomAnchor)
            .isActive = true
        pageCollectionView
            .bottomAnchor
            .constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
            .isActive = true
    }
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageCollectionViewCell.id, for: indexPath) as! PageCollectionViewCell
        cell.pageLabel.text = "View \(indexPath.row + 1)"
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.indicatorViewLeadingConstraint.constant = scrollView.contentOffset.x / 4
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let itemAt = Int(targetContentOffset.pointee.x / self.view.frame.width)
        let indexPath = IndexPath(item: itemAt, section: 0)
        menuBar.menuBarCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: pageCollectionView.frame.width, height: pageCollectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
          return 0
    }
}

// MARK: - MenuBarDelegate
extension ViewController: MenuBarDelegate {
    func didScroll(to index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        self.pageCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}
