//
//  PriceTextFieldCell.swift
//  UsedGoodsUpload
//
//  Created by thoonk on 2022/01/08.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class PriceTextFieldCell: UITableViewCell {
    static let identifier = "PriceTextFieldCell"
    let bag = DisposeBag()
    lazy var priceInputField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.font = .systemFont(ofSize: 17)
        
        return textField
    }()
    
    lazy var freeShareButton: UIButton = {
       let button = UIButton()
        button.setTitle("무료나눔", for: .normal)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.tintColor = .orange
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.orange.cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 10.0
        button.clipsToBounds = true
        button.isHidden = true
        button.semanticContentAttribute = .forceRightToLeft
        
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: PriceTextFieldTextCellViewModel) {
        viewModel.showFreehShareButton
            .map { !$0 }
            .emit(to: freeShareButton.rx.isHidden)
            .disposed(by: bag)
        
        viewModel.resetPrice
            .map { _ in "" }
            .emit(to: priceInputField.rx.text)
            .disposed(by: bag)
        
        priceInputField.rx.text
            .bind(to: viewModel.priceValue)
            .disposed(by: bag)
        
        freeShareButton.rx.tap
            .bind(to: viewModel.freeShareButtonTapped)
            .disposed(by: bag)
    }
}

private extension PriceTextFieldCell {
    func setupLayout() {
        [priceInputField, freeShareButton]
            .forEach { contentView.addSubview($0) }
        
        priceInputField.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
        
        freeShareButton.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview().inset(15)
            $0.width.equalTo(100)
        }
    }
    
}
