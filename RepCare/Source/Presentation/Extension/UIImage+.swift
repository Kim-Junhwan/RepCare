//
//  UIImage+.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/23.
//

import Foundation
import UIKit

extension UIImage {
    func resize(width: CGFloat) -> UIImage {
        let scale = width / size.width
        let height = size.height * scale
        let newSize = CGSize(width: width, height: height)
        let render = UIGraphicsImageRenderer(size: newSize)
        let renderImage = render.image { context in
            self.draw(in: .init(origin: .zero, size: size))
        }
        return renderImage
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
        guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(source, 0, downsampleOptions) else {
            return self
        }
        
        return UIImage(cgImage: downsampledImage)
    }
}
