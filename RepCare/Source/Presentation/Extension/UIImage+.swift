//
//  UIImage+.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/23.
//

import Foundation
import UIKit

extension UIImage {
    func resizeImage(size: CGSize) -> UIImage {
        let originalSize = self.size
        let ratio: CGFloat = {
            return originalSize.width > originalSize.height ? 1 / (size.width / originalSize.width) :
            1 / (size.height / originalSize.height)
        }()
        
        return UIImage(cgImage: self.cgImage!, scale: self.scale * ratio, orientation: self.imageOrientation)
    }
    
    func downSamplingImage(maxSize:CGFloat) -> UIImage {
        let sourceOptions = [kCGImageSourceShouldCache:false] as CFDictionary
        guard let data = self.pngData() else { return self }
        guard let source = CGImageSourceCreateWithData(data as CFData, sourceOptions) else { return self }
        let downsampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways:true,
            kCGImageSourceThumbnailMaxPixelSize: maxSize * UIScreen.main.scale ,
            kCGImageSourceShouldCacheImmediately:true,
            kCGImageSourceCreateThumbnailWithTransform:true
        ] as CFDictionary
        guard let downsampledCGImage = CGImageSourceCreateThumbnailAtIndex(source, 0, downsampleOptions) else {
            return self
        }
        guard let downSampleImage = UIImage(cgImage: downsampledCGImage, scale: 1.0, orientation: imageOrientation).cgImage else { return self }
        let rotateImage = UIImage(cgImage: downSampleImage, scale: 1.0, orientation: imageOrientation)
        return rotateImage
    }
    
    func orientImage() -> UIImage {
        if imageOrientation == .up {
            return self
        }
        guard let cgImage else { return self }
        return UIImage(cgImage: cgImage, scale: 1.0, orientation: imageOrientation)
    }
}
