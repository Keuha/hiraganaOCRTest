//
//  DrawableCanvas.swift
//  hiraganaOCRTest
//
//  Created by Franck Petriz on 12/02/2019.
//  Copyright © 2019 Franck Petriz. All rights reserved.
//

import Foundation
import UIKit

protocol DrawabaleCanvasDelegate {
    func drawingEnded()
    func drawingStarted()
}

class DrawableCanvas: UIImageView {
    
    private var lastPoint = CGPoint()
    var drawingWidth: CGFloat = 6.0
    var drawingColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    var delegate : DrawabaleCanvasDelegate?
    @IBInspectable var originalPicture : UIImage? {
        didSet  {
            self.image = originalPicture
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.drawingStarted()

        let touch = touches.first!
        lastPoint = touch.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        let touch = touches.first!
        let currentPoint = touch.location(in: self)
        
        UIGraphicsBeginImageContext(self.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        if self.image == nil {
            self.image = UIImage()
        }
        self.image!.draw(in: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        context.move(to: lastPoint)
        context.addLine(to: currentPoint)
        context.setLineWidth(drawingWidth)
        context.setStrokeColor(drawingColor.cgColor)
        context.setLineCap(CGLineCap.square)
        context.strokePath()
        
        self.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        lastPoint = currentPoint
    }
    
    func clear() {
        self.image = originalPicture
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.drawingEnded()
    }
}
