//
//  File.swift
//  
//
//  Created by HOANGHUNG on 5/22/21.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Generic Property
public class Property<T: Any> {
    private var property = [String:T]()
   
    func get(_ key: AnyObject) -> T? {
        return property["\(unsafeBitCast(key, to: Int.self))"] ?? nil
    }
   
    func set(_ key: AnyObject, value: T) {
        property["\(unsafeBitCast(key, to: Int.self))"] = value
    }
}

// MARK: - UIImageView Shape Extension
extension UIImageView {
    private static var isAnimationEnabled = Property<Bool>()
    
    /// Enable or Disable animation when shape is drawing
    @IBInspectable var animationEnabled : Bool {
        get {
            return UIImageView.isAnimationEnabled.get(self) ?? false
         }
        set(newValue) {
            UIImageView.isAnimationEnabled.set(self, value: newValue)
        }
    }
    
    private static var _durationAnimation = Property<Double>()
    /// animation duration when shape is drawing
    @IBInspectable var durationAnimation : Double {
        get {
            return UIImageView._durationAnimation.get(self) ?? 0.3
         }
        set(newValue) {
            UIImageView._durationAnimation.set(self, value: newValue)
        }
    }
    
    /// Clear all sublayer
    func clearLayer() {
        self.layer.sublayers?.removeAll()
    }
    
    
    /// Draw connected points on image view with correct coordinator
    /// - Parameters:
    ///   - points: [CGPoints] Array points of image coordinator
    ///   - color: color of stroke
    ///   - lineWidth: line of stroke
    ///   - isSolid: solid or dashed line
    func drawPoints(points: [CGPoint], color: CGColor, lineWidth: CGFloat, isSolid: Bool) {
        let imagePoints = convertPoints(fromImagePoints: points)
        
        let path = UIBezierPath()
        if imagePoints.count == 1 {
            path.move(to: imagePoints.first!)
            path.addLine(to: imagePoints.first!)
        } else {
            path.move(to: imagePoints.first!)
            for i in 1...imagePoints.count-1 {
                path.addLine(to: imagePoints[i])
            }
        }
        path.lineCapStyle = .round
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = color
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = lineWidth
        
        if !isSolid {
            shapeLayer.lineDashPattern = [7, 3] // 7 is the length of dash, 3 is length of the gap.
        }
        shapeLayer.path = path.cgPath
        self.layer.addSublayer(shapeLayer)
        
        if animationEnabled {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.toValue = 1
            animation.duration = durationAnimation
            shapeLayer.add(animation, forKey: "line")
        }
    }
}
// MARK: - UIImageView GeometryConvesion Extension
extension UIImageView {
    
    func convertPoints(fromImagePoints imagePoints: [CGPoint]) -> [CGPoint] {
        var newPoints = [CGPoint]()
        for point in imagePoints {
            let newPoint = convertPoint(fromImagePoint: point)
            newPoints.append(newPoint)
        }
        return newPoints
    }
    
    func convertPoint(fromImagePoint imagePoint: CGPoint) -> CGPoint {
        guard let imageSize = image?.size else { return CGPoint.zero }

        var viewPoint = imagePoint
        let viewSize = bounds.size
        
        let ratioX = viewSize.width / imageSize.width
        let ratioY = viewSize.height / imageSize.height
        
        switch contentMode {
        case .scaleAspectFit: fallthrough
        case .scaleAspectFill:
            var scale : CGFloat = 0
            
            if contentMode == .scaleAspectFit {
                scale = min(ratioX, ratioY)
            }
            else {
                scale = max(ratioX, ratioY)
            }
            
            viewPoint.x *= scale
            viewPoint.y *= scale
            
            viewPoint.x += (viewSize.width  - imageSize.width  * scale) / 2.0
            viewPoint.y += (viewSize.height - imageSize.height * scale) / 2.0
        
        case .scaleToFill: fallthrough
        case .redraw:
            viewPoint.x *= ratioX
            viewPoint.y *= ratioY
        case .center:
            viewPoint.x += viewSize.width / 2.0  - imageSize.width  / 2.0
            viewPoint.y += viewSize.height / 2.0 - imageSize.height / 2.0
        case .top:
            viewPoint.x += viewSize.width / 2.0 - imageSize.width / 2.0
        case .bottom:
            viewPoint.x += viewSize.width / 2.0 - imageSize.width / 2.0
            viewPoint.y += viewSize.height - imageSize.height
        case .left:
            viewPoint.y += viewSize.height / 2.0 - imageSize.height / 2.0
        case .right:
            viewPoint.x += viewSize.width - imageSize.width
            viewPoint.y += viewSize.height / 2.0 - imageSize.height / 2.0
        case .topRight:
            viewPoint.x += viewSize.width - imageSize.width
        case .bottomLeft:
            viewPoint.y += viewSize.height - imageSize.height
        case .bottomRight:
            viewPoint.x += viewSize.width  - imageSize.width
            viewPoint.y += viewSize.height - imageSize.height
        case.topLeft: fallthrough
        default:
            break
        }
        
         return viewPoint
    }
    
    func convertRect(fromImageRect imageRect: CGRect) -> CGRect {
        let imageTopLeft = imageRect.origin
        let imageBottomRight = CGPoint(x: imageRect.maxX, y: imageRect.maxY)
        
        let viewTopLeft = convertPoint(fromImagePoint: imageTopLeft)
        let viewBottomRight = convertPoint(fromImagePoint: imageBottomRight)
        
        var viewRect : CGRect = .zero
        viewRect.origin = viewTopLeft
        viewRect.size = CGSize(width: abs(viewBottomRight.x - viewTopLeft.x), height: abs(viewBottomRight.y - viewTopLeft.y))
        return viewRect
    }
    
    func convertPoint(fromViewPoint viewPoint: CGPoint) -> CGPoint {
        guard let imageSize = image?.size else { return CGPoint.zero }
        
        var imagePoint = viewPoint
        let viewSize = bounds.size
        
        let ratioX = viewSize.width / imageSize.width
        let ratioY = viewSize.height / imageSize.height
        
        switch contentMode {
        case .scaleAspectFit: fallthrough
        case .scaleAspectFill:
            var scale : CGFloat = 0
            
            if contentMode == .scaleAspectFit {
                scale = min(ratioX, ratioY)
            }
            else {
                scale = max(ratioX, ratioY)
            }
            
            // Remove the x or y margin added in FitMode
            imagePoint.x -= (viewSize.width  - imageSize.width  * scale) / 2.0
            imagePoint.y -= (viewSize.height - imageSize.height * scale) / 2.0
            
            imagePoint.x /= scale;
            imagePoint.y /= scale;
            
        case .scaleToFill: fallthrough
        case .redraw:
            imagePoint.x /= ratioX
            imagePoint.y /= ratioY
        case .center:
            imagePoint.x -= (viewSize.width - imageSize.width)  / 2.0
            imagePoint.y -= (viewSize.height - imageSize.height) / 2.0
        case .top:
            imagePoint.x -= (viewSize.width - imageSize.width)  / 2.0
        case .bottom:
            imagePoint.x -= (viewSize.width - imageSize.width)  / 2.0
            imagePoint.y -= (viewSize.height - imageSize.height);
        case .left:
            imagePoint.y -= (viewSize.height - imageSize.height) / 2.0
        case .right:
            imagePoint.x -= (viewSize.width - imageSize.width);
            imagePoint.y -= (viewSize.height - imageSize.height) / 2.0
        case .topRight:
            imagePoint.x -= (viewSize.width - imageSize.width);
        case .bottomLeft:
            imagePoint.y -= (viewSize.height - imageSize.height);
        case .bottomRight:
            imagePoint.x -= (viewSize.width - imageSize.width)
            imagePoint.y -= (viewSize.height - imageSize.height)
        case.topLeft: fallthrough
        default:
            break
        }
        
        return imagePoint
    }
    
    func convertRect(fromViewRect viewRect : CGRect) -> CGRect {
        let viewTopLeft = viewRect.origin
        let viewBottomRight = CGPoint(x: viewRect.maxX, y: viewRect.maxY)
        
        let imageTopLeft = convertPoint(fromImagePoint: viewTopLeft)
        let imageBottomRight = convertPoint(fromImagePoint: viewBottomRight)
        
        var imageRect : CGRect = .zero
        imageRect.origin = imageTopLeft
        imageRect.size = CGSize(width: abs(imageBottomRight.x - imageTopLeft.x), height: abs(imageBottomRight.y - imageTopLeft.y))
        return imageRect
    }

}
