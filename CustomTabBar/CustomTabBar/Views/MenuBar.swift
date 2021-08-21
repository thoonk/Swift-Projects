//
//  MenuBar.swift
//  CustomTabBar
//
//  Created by 김태훈 on 2021/08/20.
//

import UIKit

protocol MenuBarDelegate: AnyObject {
    func didScroll(to index: Int)
}

class MenuBar: UIView {
    // MARK: - Interface Builder
    lazy var menuBarCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(
            frame: CGRect(x: 0, y: 0, width: 0, height: 0),
            collectionViewLayout: collectionViewLayout
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private lazy var indicatorView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .black
            return view
    }()
    
    // MARK: - Properties
    var indicatorViewLeadingConstraint: NSLayoutConstraint!
    var indicatorViewWidthConstraint: NSLayoutConstraint!
    
    weak var menuBarDelegate: MenuBarDelegate?
    private var menus = ["First", "Second", "Third", "Fourth"]
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupMenuBarCollectionView()
        setupMenuBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func setupMenuBarCollectionView() {
        menuBarCollectionView.dataSource = self
        menuBarCollectionView.delegate = self
        menuBarCollectionView.showsHorizontalScrollIndicator = false
        menuBarCollectionView.register(
            UINib(nibName: MenuBarCollectionViewCell.name, bundle: nil),
            forCellWithReuseIdentifier: MenuBarCollectionViewCell.id
        )
        
        let indexPathForInitMenu = IndexPath(item: 0, section: 0)
        menuBarCollectionView.selectItem(at: indexPathForInitMenu, animated: false, scrollPosition: [])
    }
    
    private func setupMenuBar() {
        self.addSubview(menuBarCollectionView)
        menuBarCollectionView
            .leadingAnchor
            .constraint(equalTo: self.leadingAnchor)
            .isActive = true
        menuBarCollectionView
            .trailingAnchor
            .constraint(equalTo: self.trailingAnchor)
            .isActive = true
        menuBarCollectionView
            .topAnchor
            .constraint(equalTo: self.topAnchor)
            .isActive = true
        menuBarCollectionView
            .heightAnchor
            .constraint(equalToConstant: 55)
            .isActive = true
        
        self.addSubview(indicatorView)
        indicatorViewLeadingConstraint = indicatorView
            .leadingAnchor
            .constraint(equalTo: self.leadingAnchor)
        indicatorViewLeadingConstraint.isActive = true
        indicatorView
            .bottomAnchor
            .constraint(equalTo: self.bottomAnchor)
            .isActive = true
        indicatorViewWidthConstraint = indicatorView
            .widthAnchor
            .constraint(equalToConstant: self.frame.width / 4)
        indicatorViewWidthConstraint.isActive = true
        indicatorView
            .heightAnchor
            .constraint(equalToConstant: 5)
            .isActive = true
    }
}

// MARK: - UICollectionViewDataSource
extension MenuBar: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(
                withReuseIdentifier: MenuBarCollectionViewCell.id,
                for: indexPath
            ) as? MenuBarCollectionViewCell else { return UICollectionViewCell() }
        
        cell.menuTitleLabel.text = "\(menus[indexPath.row])"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width / 4, height: 55)
    }
}

// MARK: - UICollectionViewDelegate
extension MenuBar: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        menuBarDelegate?.didScroll(to: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MenuBarCollectionViewCell else {return}
        cell.menuTitleLabel.textColor = .systemGray4
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MenuBar: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
}
