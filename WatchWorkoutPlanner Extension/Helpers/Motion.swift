//
//  MotionStruct.swift
//  Form Identifier
//
//  Structure for storing motion data in a more organised manner.
//

import Foundation
import CoreML

struct Motion {
    
    var TimeStamp: [Double] = []
    
    var DMUAccelX: [Double] = []
    var DMUAccelY: [Double] = []
    var DMUAccelZ: [Double] = []
    
    var DMGrvX: [Double] = []
    var DMGrvY: [Double] = []
    var DMGrvZ: [Double] = []
    
    var DMQuatX: [Double] = []
    var DMQuatY: [Double] = []
    var DMQuatZ: [Double] = []
    var DMQuatW: [Double] = []
    
    var DMRotX: [Double] = []
    var DMRotY: [Double] = []
    var DMRotZ: [Double] = []
    
    var DMRoll: [Double] = []
    var DMPitch: [Double] = []
    var DMYaw: [Double] = []
}
