//
//  Dummy.swift
//  FindCVSTests
//
//  Created by thoonk on 2022/01/17.
//

import Foundation

@testable import FindCVS

var cvsList: [KLDocument] = Dummy().load("networkDummy.json")

class Dummy {
    func load<T: Decodable>(_ filename: String) -> T {
        let data: Data
        let bundle = Bundle(for: type(of: self))
        
        guard let file = bundle.url(forResource: filename, withExtension: nil) else {
            fatalError("\(filename) 을 main bundle에서 불러올 수 없음.")
        }
        
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("\(filename) 을 main bundle에서 불러올 수 없음, \(error)")
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            fatalError("\(filename)을 \(T.self)로 파싱할 수 없음.")
        }
    }
}
