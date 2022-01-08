//
//  TitleTextFieldCell.swift
//  UsedGoodsUpload
//
//  Created by thoonk on 2022/01/08.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

final class TitleTextFieldCell: UITableViewCell {
    static let identifier = "TitleTextFieldCell"
    let bag = DisposeBag()
    
    lazy var titleInputField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 17)
        
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: TitleTextFieldCellViewModel) {
        titleInputField.rx.text
            .bind(to: viewModel.titleText)
            .disposed(by: bag)
    }
}

private extension TitleTextFieldCell {
    private func setupLayout() {
        contentView.addSubview(titleInputField)
        
        titleInputField.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
    }
}
