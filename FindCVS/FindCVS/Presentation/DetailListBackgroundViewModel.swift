//
//  DetailListBackgroundViewModel.swift
//  FindCVS
//
//  Created by thoonk on 2022/01/12.
//

import RxSwift
import RxCocoa

struct DetailListBackgroundViewModel {
    // Input
    let shouldHideStatusLabel = PublishSubject<Bool>()
    
    // Output
    let isStatusLabelHidden: Signal<Bool>
    
    init() {
        isStatusLabelHidden = shouldHideStatusLabel
            .asSignal(onErrorJustReturn: true)
    }
}
