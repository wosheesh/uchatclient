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
    

