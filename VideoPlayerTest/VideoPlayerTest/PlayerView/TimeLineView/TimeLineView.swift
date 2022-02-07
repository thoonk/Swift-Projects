//
//  TimeLineView.swift
//  VideoPlayerTest
//
//  Created by thoonk on 2022/02/07.
//

import UIKit
import CoreMedia

protocol TimeLineViewDelegate: AnyObject {
    func didCloseButtonTapped()
    func didTimeLineTapped(with value: CMTime)
}

final class TimeLineView: UIView {
    let timeLines: [TimeLine] = [
        TimeLine(title: "시작", timeStamp: 0),
        TimeLine(title: "토끼가 나무를 봄", timeStamp: 90),
        TimeLine(title: "전쟁의 시작", timeStamp: 165),
        TimeLine(title: "토끼의 위기", timeStamp: 202),
        TimeLine(title: "쿠쿠", timeStamp: 400),
        TimeLine(title: "끝", timeStamp: 596)
    ]
    
    private let cellHeight: CGFloat = 250
    
    weak var delegate: TimeLineViewDelegate?
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        button.addTarget(
            self,
            action: #selector(closeButtonTapped),
            for: .touchUpInside
        )
        
        return button
    }()
    
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
        collectionView.backgroundColor = UIColor(white: 0, alpha: 0.7)
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(
            TimeLineCollectionViewCell.self,
            forCellWithReuseIdentifier: TimeLineCollectionViewCell.identifier
        )
        
        return collectionView
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        print(frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UICollectionViewDataSource
extension TimeLineView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        timeLines.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TimeLineCollectionViewCell.identifier,
            for: indexPath
        ) as? TimeLineCollectionViewCell
        else { return UICollectionViewCell() }
        
        cell.configure(with: self.timeLines[indexPath.item])
        
        return cell
    }
}

extension TimeLineView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = self.frame.width / 3
        return CGSize(width: width, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let value: CGFloat = 5.0
        return UIEdgeInsets(
            top: 0.0,
            left: value,
            bottom: 0.0,
            right: value
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let time = CMTime(value: CMTimeValue(self.timeLines[indexPath.item].timeStamp), timescale: 1)
        delegate?.didTimeLineTapped(with: time)
    }
}

private extension TimeLineView {
    func setupLayout() {
        let topMaskView = UIView()
        topMaskView.backgroundColor = UIColor(white: 0, alpha: 0.9)

        topMaskView.addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(15)
        }
        
        let bottomMaskView = UIView()
        bottomMaskView.backgroundColor = UIColor(white: 0, alpha: 0.9)
        
        [
            topMaskView,
            collectionView,
            bottomMaskView
        ]
            .forEach { addSubview($0) }
        
        topMaskView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo((frame.height - cellHeight) / 2)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(topMaskView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(cellHeight)
        }
        
        bottomMaskView.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(topMaskView)
        }
    }
    
    @objc func closeButtonTapped() {
        delegate?.didCloseButtonTapped()
    }
}
