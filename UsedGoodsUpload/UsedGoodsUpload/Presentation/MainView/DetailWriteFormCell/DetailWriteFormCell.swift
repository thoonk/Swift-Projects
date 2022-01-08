//
//  DetailWriteFormCell.swift
//  UsedGoodsUpload
//
//  Created by thoonk on 2022/01/08.
//

import UIKit
import RxSwift
import RxCocoa

final class DetailWriteFormCell: UITableViewCell {
    static let identifier = "DetailWriteFormCell"
    let bag = DisposeBag()
    lazy var contentInputView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 17 )
        return textView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: DetailWriteFromCellViewModel) {
        contentInputView.rx.text
            .bind(to: viewModel.contentValue)
            .disposed(by: bag)
    }
}

private extension DetailWriteFormCell {
    func setupLayout() {
        contentView.addSubview(contentInputView)
        
        contentInputView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(15)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(300)
        }
    }
}
