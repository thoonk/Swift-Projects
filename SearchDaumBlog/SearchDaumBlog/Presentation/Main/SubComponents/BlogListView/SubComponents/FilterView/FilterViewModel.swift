//
//  FilterViewModel.swift
//  SearchDaumBlog
//
//  Created by thoonk on 2022/01/06.
//

import RxSwift
import RxCocoa

struct FilterViewModel {
    // FilterView 외부에서 전달
    let sortButtonTapped = PublishRelay<Void>()
}
