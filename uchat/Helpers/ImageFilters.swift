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

infix operator >>> { associativity left }

func >>> (filter1: Filter, filter2: Filter) -> Filter {
    return { image in filter2(filter1(image)) }
}

// Apply default Channel Filter
extension PictureCache {
    
    func applyFilters(toImage image: UIImage) -> UIImage? {
        
        guard let beginImage = CIImage(image: image) else {
            print("couldn't find a picture")
            return nil
        }
    
        let myFilter = bw(OTMColors.bgLight, intensity: 0.4)
        let filteredImage = myFilter(beginImage)
    
        // https://developer.apple.com/library/mac/documentation/GraphicsImaging/Conceptual/CoreImaging/ci_tasks/ci_tasks.html#//apple_ref/doc/uid/TP30001185-CH3-SW19
        let myEAGLContext = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
        let options = [kCIContextWorkingColorSpace : NSNull()]
        let eagContext = CIContext(EAGLContext: myEAGLContext, options: options)
        let cgimg = eagContext.createCGImage(filteredImage, fromRect: filteredImage.extent)
        
        let endImage = UIImage(CGImage: cgimg)
        
        return endImage
        
    }
    

}

// Filters
extension PictureCache {

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
    
    func bw(color: UIColor, intensity: Double) -> Filter {
        return { image in
            let parameters = [
                kCIInputColorKey: CIColor(color: color),
                kCIInputIntensityKey: intensity,
                kCIInputImageKey: image
            ]
            guard let filter = CIFilter(name: "CIColorMonochrome", withInputParameters: parameters) else { fatalError() }
            guard let outputImage = filter.outputImage else { fatalError() }
            return outputImage
            
        }
    }
    
}





    

