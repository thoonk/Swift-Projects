//
//  ViewModelType.swift
//  WeatherAPITest-RxSwift
//
//  Created by 김태훈 on 2021/02/11.
//

import Foundation
import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var bag: DisposeBag { get set }
    
    func bind(input: Input) -> Output
}
