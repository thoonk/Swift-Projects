//
//  LocalNetworkStub.swift
//  FindCVSTests
//
//  Created by thoonk on 2022/01/17.
//

import Foundation
import RxSwift
import Stubber


@testable import FindCVS

class LocalNetworkStub: LocalNetwork {
    override func getLocation(by mapPoint: MTMapPoint) -> Single<Result<LocationData, URLError>> {
        return Stubber.invoke(getLocation(by:), args: mapPoint)
    }
}
