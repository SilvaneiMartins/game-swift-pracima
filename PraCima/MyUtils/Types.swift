//
//  Types.swift
//  PraCima
//
//  Created by Silvanei  Martins on 13/03/23.
//

import UIKit

let screenWidth: CGFloat = 1536.0
let screenHeight: CGFloat = 2048.0

let appDL = UIApplication.shared.delegate as! AppDelegate

var playableRect: CGRect {
    var ratio: CGFloat =  16/9
    
    if appDL.isIphoneX {
        ratio = 2.16
    } else if appDL.isIpad11 {
        ratio = 1.43
    }
    
    let w: CGFloat = screenHeight / ratio
    let h: CGFloat = screenHeight
    let x: CGFloat = (screenWidth - w) / 2
    let y: CGFloat = 0.0
    
    return CGRect(x: x, y: y, width: w, height: h)
}

struct PhysicsCategories {
    static let Player: UInt32 = 0b1  // 2^0
    static let Wall: UInt32 = 0b10  // 2^1
    static let Side: UInt32 = 0b100  // 2^2
}
