//
//  AlertActionConvertible.swift
//  SearchDaumBlog
//
//  Created by thoonk on 2022/01/03.
//

import UIKit

protocol AlertActionConvertible {
    var title: String { get }
    var style: UIAlertAction.Style { get }
}
