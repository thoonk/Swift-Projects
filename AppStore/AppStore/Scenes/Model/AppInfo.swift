//
//  AppInfo.swift
//  AppStore
//
//  Created by MA2103 on 2021/12/09.
//

import Foundation

struct AppInfo {
    let appName: String
    let type: String
    let imageURL: String?
    
    init(
        appName: String,
        type: String,
        imageURL: String? = nil
    ) {
        self.appName = appName
        self.type = type
        self.imageURL = imageURL
    }
}
