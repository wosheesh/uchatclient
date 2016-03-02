//
//  ImageFilters.swift
//  uchat
//
//  Created by Wojtek Materka on 29/02/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import UIKit
import CoreImage

    
typealias Filter = CIImage -> CIImage

func sepia(intensity: Double) -> Filter {
    return { image in
        let parameters = [
            kCIInputImageKey: image,
            kCIInputIntensityKey: intensity
        ]
        
        guard let filter = CIFilter(name: "CISepiaTone", withInputParameters: parameters) else { fatalError() }
        
        guard let outputImage = filter.outputImage else { fatalError() }
        
        return outputImage
    }
}

func blur(radius: Double) -> Filter {
    return { image in
        let parameters = [
            kCIInputRadiusKey: radius,
            kCIInputImageKey: image
        ]
        guard let filter = CIFilter(name: "CIGaussianBlur",
            withInputParameters: parameters) else { fatalError() }
        guard let outputImage = filter.outputImage else { fatalError() }
        return outputImage
    }
}

//    func applyFilters(fileURLString: String) {
//
//        let fileURL = NSURL(fileURLWithPath: fileURLString)
//
//        guard var beginImage = CIImage(contentsOfURL: fileURL) else {
//            print("couldn't find a picture")
//            return
//        }
//
//        beginImage = blur(5.0)(beginImage)
//        beginImage = sepia(0.5)(beginImage)
//
////            let context = CIContext(options: nil)
//        // https://developer.apple.com/library/mac/documentation/GraphicsImaging/Conceptual/CoreImaging/ci_tasks/ci_tasks.html#//apple_ref/doc/uid/TP30001185-CH3-SW19
//        let myEAGLContext = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
//        let options = [kCIContextWorkingColorSpace : NSNull()]
//        let eagContext = CIContext(EAGLContext: myEAGLContext, options: options)
//        let cgimg = eagContext.createCGImage(beginImage, fromRect: beginImage.extent)
//
//        let newImage = UIImage(CGImage: cgimg)
//
//        let fileName = fileURL.lastPathComponent
//
//        print("Saving filtered image as: \(fileName)")
//
//        PictureCache().storePicture(newImage, withIdentifier: fileName!)
//
//    }
    

