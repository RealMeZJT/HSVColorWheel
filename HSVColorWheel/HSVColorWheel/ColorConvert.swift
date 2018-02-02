//
//  ColorConvert.swift
//  HSVColorWheel
//
//  Created by ZhouJiatao on 2018.02.02.
//  Copyright © 2018 ZJT. All rights reserved.
//

import UIKit

/// 值范围：0 ~ 255
struct RGBA {
    var red: UInt8
    var green: UInt8
    var blue: UInt8
    var alpha: UInt8
    
    var description: String {
        return "red:\(red),green:\(green),blue:\(blue),alpha:\(alpha),"
    }
    
    func equalTo(_ other: RGBA) -> Bool {
        return self.red == other.red
            && self.green == other.green
            && self.blue == other.blue
            && self.alpha == other.alpha
        
    }
}


/// 值范围：0.0 ~ 1.0
struct HSV {
    var hue: CGFloat = 0.0
    var saturation: CGFloat = 0.0
    var brightness: CGFloat = 0.0
    var alpha: CGFloat = 1.0
}


//MARK: - functions

func uicolor2rgb(_ color: UIColor) -> RGBA{
    var result = RGBA(red: 0, green: 0, blue: 0, alpha: 255)
    
    let colorRef =  color.cgColor
    let numComponents = colorRef.numberOfComponents
    if numComponents == 4 {
        if let components = colorRef.components {
            result = RGBA(red: UInt8(components[0] * 255),
                          green: UInt8(components[1] * 255),
                          blue: UInt8(components[2] * 255),
                          alpha: UInt8(components[3] * 255))
        }
    }
    
    return result
}


func hsv2rgb(_ hsv: HSV) -> RGBA {
    let uicolor = UIColor(hue: hsv.hue, saturation: hsv.saturation, brightness: hsv.brightness, alpha: hsv.alpha)
    return uicolor2rgb(uicolor)
}

func rgb2hsv(_ rgb: RGBA) -> HSV {
    let uicolor = UIColor(red: CGFloat(rgb.red) / 255.0,
                          green: CGFloat(rgb.green) / 255.0,
                          blue: CGFloat(rgb.blue) / 255.0,
                          alpha: CGFloat(rgb.alpha) / 255.0)
    var hsv = HSV(hue: 0, saturation: 0, brightness: 0, alpha: 1)
    uicolor.getHue(&hsv.hue, saturation: &hsv.saturation, brightness: &hsv.brightness, alpha: &hsv.alpha)
    
    return hsv
}
