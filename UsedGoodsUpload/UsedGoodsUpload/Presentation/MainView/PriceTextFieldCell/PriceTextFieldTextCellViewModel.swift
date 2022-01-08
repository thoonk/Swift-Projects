//
//  PriceTextFieldTextCellViewModel.swift
//  UsedGoodsUpload
//
//  Created by thoonk on 2022/01/08.
//

import RxSwift
import RxCocoa

struct PriceTextFieldTextCellViewModel {
    // Output
    let showFreehShareButton: Signal<Bool>
    let resetPrice: Signal<Void>
    // Input
    let priceValue = PublishRelay<String?>()
    let freeShareButtonTapped = PublishRelay<Void>()
    
    init() {
        self.showFreehShareButton = Observable
            .merge(
                priceValue.map { $0 ?? "" == "0" },
                freeShareButtonTapped.map { _ in false }
            )
            .asSignal(onErrorJustReturn: false)
        
        self.resetPrice = freeShareButtonTapped
            .asSignal(onErrorSignalWith: .empty())
    }
}
