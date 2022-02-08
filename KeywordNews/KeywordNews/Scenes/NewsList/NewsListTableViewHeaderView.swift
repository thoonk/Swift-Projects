//
//  NewsListTableViewHeaderView.swift
//  KeywordNews
//
//  Created by thoonk on 2022/02/04.
//

import UIKit
import TTGTags
import SnapKit

protocol NewsListTableViewHeaderViewDelegate: AnyObject {
    func didSelectTag(_ selectedIndex: Int)
}

final class NewsListTableViewHeaderView: UITableViewHeaderFooterView {
    static let identifier = "NewsListTableViewHeaderView"
    
    private weak var delegate: NewsListTableViewHeaderViewDelegate?
    private var tags: [String] = []
    
    private lazy var tagCollectioView =  TTGTextTagCollectionView()
    
    func configure(tags: [String], delegate: NewsListTableViewHeaderViewDelegate) {
        self.tags = tags
        self.delegate = delegate
        
        setupLayout()
        setupTagCollectionView()
        
        contentView.backgroundColor = .systemBackground
    }
}

extension NewsListTableViewHeaderView: TTGTextTagCollectionViewDelegate {
    func textTagCollectionView(
        _ textTagCollectionView: TTGTextTagCollectionView!,
        didTap tag: TTGTextTag!,
        at index: UInt
    ) {
        guard tag.selected else { return }
        delegate?.didSelectTag(Int(index))
    }
}

private extension NewsListTableViewHeaderView {
    func setupLayout() {
        addSubview(tagCollectioView)
        
        tagCollectioView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setupTagCollectionView() {
        tagCollectioView.numberOfLines = 1
        tagCollectioView.scrollDirection = .horizontal
        tagCollectioView.showsHorizontalScrollIndicator = false
        tagCollectioView.delegate = self
        
        let inset: CGFloat = 16.0
        tagCollectioView.contentInset = UIEdgeInsets(
            top: inset,
            left: inset,
            bottom: inset,
            right: inset
        )
        
        let cornerRadius: CGFloat = 12.0
        let shadowOpacity: CGFloat = 0.0
        let extraSpace = CGSize(width: 20.0, height: 12.0)
        let color = UIColor.systemOrange
        
        let style = TTGTextTagStyle()
        style.backgroundColor = color
        style.cornerRadius = cornerRadius
        style.borderWidth = 0.0
        style.shadowOpacity = shadowOpacity
        style.extraSpace = extraSpace
        
        let selectedStyle = TTGTextTagStyle()
        selectedStyle.backgroundColor = .white
        selectedStyle.cornerRadius = cornerRadius
        selectedStyle.shadowOpacity = shadowOpacity
        selectedStyle.extraSpace = extraSpace
        selectedStyle.borderColor = color
        
        tags.forEach {
            let font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
            let tagContents = TTGTextTagStringContent(
                text: $0,
                textFont: font,
                textColor: .white
            )
            
            let selectedTagContents = TTGTextTagStringContent(
                text: $0,
                textFont: font,
                textColor: color
            )
            
            let tag = TTGTextTag(
                content: tagContents,
                style: style,
                selectedContent: selectedTagContents,
                selectedStyle: selectedStyle
            )
            
            tagCollectioView.addTag(tag)
        }
    }
}
