//
//  HSVColorWheel.swift
//  HSVColorWheel
//
//  Created by ZhouJiatao on 2018.02.02.
//  Copyright © 2018 ZJT. All rights reserved.
//

import UIKit


/// 色盘
class HSVColorWheel: UIView {
    
    /// 像素坐标
    struct Location {
        var x: Int
        var y: Int
    }
    
    var hueLayer: CALayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup(frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setup(_ rect: CGRect) {
        hueLayer = CALayer()
        hueLayer.frame = CGRect(x: 0, y: 100, width: min(rect.size.height,rect.size.width), height: min(rect.size.height,rect.size.width))
        hueLayer.cornerRadius = hueLayer.frame.width / 2
        hueLayer.masksToBounds = true
        self.layer.addSublayer(hueLayer)
        let heightDimension: Int = Int(rect.size.height * UIScreen.main.scale)
        let widthDimesion: Int = Int(rect.size.width * UIScreen.main.scale)
        let dimension: Int = min(heightDimension, widthDimesion)
        if let imageRef = createHueImage(dimension) {
            let image = UIImage(cgImage: imageRef)
            hueLayer.contents = imageRef
        }
        
    }
    
    private func createHueImage(_ sizeOfPixel: Int) -> CGImage? {
        let dimension = sizeOfPixel
        let bufferLenght = Int(dimension * dimension * 4)
        
        let bitmapData: CFMutableData = CFDataCreateMutable(nil, 0)
        CFDataSetLength(bitmapData, CFIndex(bufferLenght))
        let bitmap = CFDataGetMutableBytePtr(bitmapData)
        
        
        //        let circleOrigin = heightDimension > widthDimesion
        //            ? Location(x: 0, y: (heightDimension - dimension) / 2)
        //            : Location(x: (widthDimesion - dimension) / 2, y: 0)
        let circleCenter = Location(x: (dimension / 2), y: (dimension / 2))
        let circleMaxX = dimension - 1
        let circleBasicVector =  CGVector(dx: circleMaxX - circleCenter.x , dy: 0 - circleCenter.y)
        let circleRadius = dimension / 2
        for y in 0..<dimension {
            for x in 0..<dimension {
                //print("xy: \(x),\(y)")
                let currentVector = CGVector(dx: x - circleCenter.x, dy: y - circleCenter.y)
                let deg = degree(vector1: currentVector, vector2: circleBasicVector)
                let h = hue(fromDegree: deg)
                let s = Swift.min(1.0,(currentVector.length / CGFloat(circleRadius)))
                // print("degree:\(deg),hue: \(h)")
                let hsv = HSV(hue: h, saturation: s, brightness: 1.0, alpha: 1.0)
                let rgb = hsv2rgb(hsv)
                
                let byteIndex = (y * dimension + x) * 4
                
                bitmap?[byteIndex] = UInt8(rgb.red)
                bitmap?[byteIndex + 1] = UInt8(rgb.green)
                bitmap?[byteIndex + 2] = UInt8(rgb.blue)
                bitmap?[byteIndex + 3] = UInt8(rgb.alpha)
            }
        }
        
        // bitmap to CGImage
        let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo().rawValue | CGImageAlphaInfo.last.rawValue)
        let imageRef = CGImage(width: dimension, height: dimension,
                               bitsPerComponent: 8, bitsPerPixel: 32,
                               bytesPerRow: dimension * 4,
                               space: CGColorSpaceCreateDeviceRGB(),
                               bitmapInfo: bitmapInfo,
                               provider: CGDataProvider(data: bitmapData)!,
                               decode: nil, shouldInterpolate: false,
                               intent: CGColorRenderingIntent.defaultIntent)
        
        
        return imageRef
    }
    
    
    private func hue(fromDegree degree: CGFloat) -> CGFloat {
        let validDegree = max(min(degree, 360),0)
        let result = 1.0 * (validDegree / 360)
        
        return result
    }
    
    private func degree(vector1 v1: CGVector, vector2 v2: CGVector) -> CGFloat {
        let angle = atan2(v2.dy, v2.dx) - atan2(v1.dy, v1.dx)
        var deg = angle * CGFloat(180.0 / .pi)
        
        if deg < 0 {
            deg = deg + 360
        }
        
        return deg
    }
    
}

private extension CGVector {
    var length: CGFloat {
        return sqrt( (dx * dx) + (dy * dy))
    }
}
