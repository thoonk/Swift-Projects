//
//  DetailListBackgroundView.swift
//  FindCVS
//
//  Created by thoonk on 2022/01/12.
//

import UIKit
import RxSwift
import RxCocoa

final class DetailListBackgroundView: UIView {
    let bag = DisposeBag()
    
    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.text = "🏪"
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: DetailListBackgroundViewModel) {
        viewModel.isStatusLabelHidden
            .emit(to: statusLabel.rx.isHidden)
            .disposed(by: bag)
    }
}

private extension DetailListBackgroundView {
    func setupLayout() {
        backgroundColor = .white
        addSubview(statusLabel)
        
        statusLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
}
