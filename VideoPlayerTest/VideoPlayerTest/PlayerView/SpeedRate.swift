//
//  SpeedRate.swift
//  VideoPlayerTest
//
//  Created by thoonk on 2022/01/06.
//

enum SpeedRate {
    case speed05
    case speed075
    case originalSpeed
    case speed15
    case speed2
    
    var value: Float {
        switch self {
        case .speed05:
            return 0.5
        case .speed075:
            return 0.75
        case .originalSpeed:
            return 1.0
        case .speed15:
            return 1.5
        case .speed2:
            return 2.0
        }
    }
    
    var title: String {
        switch self {
        case .speed05:
            return "0.5x"
        case .speed075:
            return "0.75x"
        case .originalSpeed:
            return "1.0x (기본)"
        case .speed15:
            return "1.5x"
        case .speed2:
            return "2.0x"
        }
    }
}
