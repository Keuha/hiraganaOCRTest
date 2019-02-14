//
//  ViewController.swift
//  hiraganaOCRTest
//
//  Created by Franck Petriz on 12/02/2019.
//  Copyright © 2019 Franck Petriz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var canvas: DrawableCanvas!
    private var timer : Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        canvas.delegate = self
        canvas.clipsToBounds = true
        canvas.isMultipleTouchEnabled = false
    }
    
    // clear the drawing in view
    @IBAction func clearPressed(_ sender: UIButton) {
        canvas.clear()
        canvas.setNeedsDisplay()
    }
}

extension ViewController:  DrawabaleCanvasDelegate {
    func drawingStarted() {
        timer?.invalidate()
    }
    
    func drawingEnded() {
        print("draw ended !")
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(OCR), userInfo: nil, repeats: false)
    }
    
    @objc func OCR() {
        guard let resultImage = canvas.image else {
            return
        }
        let pixelBuffer = resultImage.pixelBufferGray(width: 32, height: 32)
        let model = hiraganaModel()
        let output = try? model.prediction(image: pixelBuffer!)
        print(output?.classLabel)
    }
}

fileprivate extension UIImage {
    func pixelBufferGray(width: Int, height: Int) -> CVPixelBuffer? {
        return _pixelBuffer(width: width, height: height,
                            pixelFormatType: kCVPixelFormatType_OneComponent8,
                            colorSpace: CGColorSpaceCreateDeviceGray(),
                            alphaInfo: .none)
    }
    
    func _pixelBuffer(width: Int, height: Int, pixelFormatType: OSType,
                      colorSpace: CGColorSpace, alphaInfo: CGImageAlphaInfo) -> CVPixelBuffer? {
        var maybePixelBuffer: CVPixelBuffer?
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
                     kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue]
        let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                         width,
                                         height,
                                         pixelFormatType,
                                         attrs as CFDictionary,
                                         &maybePixelBuffer)
        
        guard status == kCVReturnSuccess, let pixelBuffer = maybePixelBuffer else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer)
        
        guard let context = CGContext(data: pixelData,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: 8,
                                      bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer),
                                      space: colorSpace,
                                      bitmapInfo: alphaInfo.rawValue)
            else {
                return nil
        }
        
        UIGraphicsPushContext(context)
        context.translateBy(x: 0, y: CGFloat(height))
        context.scaleBy(x: 1, y: -1)
        self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        UIGraphicsPopContext()
        
        CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        return pixelBuffer
    }
}
