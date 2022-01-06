//
//  MainViewModel.swift
//  SearchDaumBlog
//
//  Created by thoonk on 2022/01/06.
//

import RxSwift
import RxCocoa

struct MainViewModel {
    let bag = DisposeBag()

    let blogListViewModel = BlogListViewModel()
    let searchBarViewModel = SearchBarViewModel()
    
    let alertActionTapped = PublishRelay<MainVC.AlertAction>()
    let shouldPresentAlert: Signal<MainVC.Alert>

    init(model: MainModel = MainModel()) {
        let blogResult = searchBarViewModel.shouldLoadResult
            .flatMapLatest(model.searchBlog)
            .share()
        
        let blogValue = blogResult
            .compactMap(model.getBlogValue(_:))
        
        let blogError = blogResult
            .compactMap(model.getBlogError(_:))
        
        // 네트워크 결과 값을 cellData로 변환
        let cellData = blogValue
            .map(model.getBlogListCellData(_:))
        
        // FilterView를 선택했을 때 나오는 alertsheet를 선택했을 때 타입
        let sortedType = alertActionTapped
            .filter {
                switch $0 {
                case .title, .datetime:
                    return true
                default:
                    return false
                }
            }
            .startWith(.title)
        
        // MainVC -> ListView
        Observable
            .combineLatest(
                sortedType,
                cellData,
                resultSelector: model.sort(by:of:)
            )
            .bind(to: blogListViewModel.blogCellData)
            .disposed(by: bag)
        
        let alertSheetForSorting = blogListViewModel.filterViewModel.sortButtonTapped
            .map { _ -> MainVC.Alert in
                return (
                    title: nil,
                    message: nil,
                    actions: [.title, .datetime, .cancel],
                    style: .actionSheet
                )
            }
        
        let alertForErrorMessage = blogError
            .map { message -> MainVC.Alert in
                return (
                    title: nil,
                    message: "네트워크 오류가 발생했습니다. 잠시후 다시 시도해주세요.",
                    actions: [.confirm],
                    style: .alert
                )
            }
        
        shouldPresentAlert = Observable
            .merge(
                alertSheetForSorting,
                alertForErrorMessage
            )
            .asSignal(onErrorSignalWith: .empty())
    }
}
