//
//  FullScreenImageViewController.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/30.
//

import Foundation
import UIKit

final class FullScreenImageViewController: BaseViewController {
    
    lazy var scrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.addSubview(imageView)
        scrollView.backgroundColor = .black
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        return scrollView
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = false
        return imageView
    }()
    
    
    init(imagePath: String) {
        super.init(nibName: nil, bundle: nil)
        do {
            try imageView.configureImageFromFilePath(path: imagePath)
        } catch {
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureView() {
        view.addSubview(scrollView)
    }
    
    override func setContraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        imageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalToSuperview()
        }
        
    }
}

extension FullScreenImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
