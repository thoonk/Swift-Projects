//
//  BlogListView.swift
//  SearchDaumBlog
//
//  Created by thoonk on 2022/01/03.
//

import UIKit
import RxSwift
import RxCocoa

final class BlogListView: UITableView {
    let bag = DisposeBag()
    
    let headerView = FilterView(frame: CGRect(
        origin: .zero,
        size: CGSize(width: UIScreen.main.bounds.width, height: 50)
    ))
    
    // MainVC -> BlogListView
    let cellData = PublishSubject<[BlogListCellData]>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        bind()
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        cellData
            .asDriver(onErrorJustReturn: [])
            .drive(self.rx.items) { tv, row, data in
                let index = IndexPath(row: row, section: 0)
                guard let cell = tv.dequeueReusableCell(withIdentifier: BlogListCell.identifier, for: index) as? BlogListCell else { return UITableViewCell() }
                
                cell.setData(data)
                return cell
            }
            .disposed(by: bag)
    }
    
    private func attribute() {
        self.register(BlogListCell.self, forCellReuseIdentifier: BlogListCell.identifier)
        self.separatorStyle = .singleLine
        self.rowHeight = 100
        self.tableHeaderView = headerView
    }
}
