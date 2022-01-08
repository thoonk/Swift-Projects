//
//  DetailWriteFromCellViewModel.swift
//  UsedGoodsUpload
//
//  Created by thoonk on 2022/01/08.
//

import RxSwift
import RxCocoa

struct DetailWriteFromCellViewModel {
    let bag = DisposeBag()
    // Output
    let contentValue = PublishRelay<String?>()
}
