//
//  WatchModel.swift
//  WatchWorkoutPlanner Extension
//
//  Identifies the Apple Watch model by the size of the screen.
//

import Foundation
import WatchKit

enum WatchModel {
    case w40, w41, w44, w45, other
}

extension WKInterfaceDevice {

    static var currentWatchModel: WatchModel {
        switch WKInterfaceDevice.current().screenBounds.size {
        case CGSize(width: 162, height: 197):
            return .w40
        case CGSize(width: 176, height: 215):
            return .w41
        case CGSize(width: 184, height: 224):
            return .w44
        case CGSize(width: 198, height: 242):
            return .w45
        default:
            return .other
    }
  }
}
