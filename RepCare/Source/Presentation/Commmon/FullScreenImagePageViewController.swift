//
//  FullScreenImagePageViewController.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/11/24.
//

import Foundation
import UIKit

final class FullScreenImagePageViewController: BaseViewController {
    
    lazy var imagePageViewController: UIPageViewController = {
        let pageView = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        return pageView
    }()
    
    private let imagePathList: [PetImageModel]
    private var viewControllers: [UIViewController] = []
    
    init(imagePathList: [PetImageModel]) {
        self.imagePathList = imagePathList
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers()
    }
    
    override func configureView() {
        viewControllers = imagePathList.map { FullScreenImageViewController(imagePath: $0.imagePath) }
        view.addSubview(imagePageViewController.view)
        imagePageViewController.dataSource = self
        imagePageViewController.setViewControllers([viewControllers[0]], direction: .forward, animated: true)
    }
    
    private func setViewControllers() {
        
    }
    
}

extension FullScreenImagePageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = viewControllers.firstIndex(of: viewController), currentIndex > 0 else { return nil }
        
        return viewControllers[currentIndex-1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = viewControllers.firstIndex(of: viewController), currentIndex < viewControllers.count-1 else { return nil }
        return viewControllers[currentIndex+1]
    }
    
    
}
