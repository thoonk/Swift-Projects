//
//  LocationInfoModelTests.swift
//  FindCVSTests
//
//  Created by thoonk on 2022/01/17.
//

import XCTest
import Nimble

@testable import FindCVS

class LocationInfoModelTests: XCTestCase {
    
    let stubNetwork = LocalNetworkStub()
    
    var doc: [KLDocument]!
    var model: LocationInfoModel!
    
    override func setUp() {
        self.model = LocationInfoModel(localNetwork: stubNetwork)
        
        self.doc = cvsList
    }

    func testDocToCellData() {
        let cellData = model.documentToCellData(doc) // 실제 모델의 값
        let placeName = doc.map { $0.placeName } // dummy 값
        let address0 = cellData[1].address // 실제 모델 값
        let roadAdressName = doc[1].roadAddressName // dummy 값
        
        expect(cellData.map { $0.placeName }).to(
            equal(placeName),
            description: "DetailLstCellData의 placeName은 document의 placeName"
        )
        
        expect(address0).to(
            equal(roadAdressName),
            description: "KLDocument의 RoadAdressName이 빈 값이 아닐 때 roadAddress가 cellData에 전달됨."
        )
    }
}
