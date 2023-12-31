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
    
    lazy var dismissButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate).withTintColor(.white)
       let button = UIButton(configuration: config)
        button.tintColor = .white
        button.addTarget(self, action: #selector(tapDismissButton), for: .touchUpInside)
        return button
    }()
    
    private let imagePathList: [PetImageModel]
    private var viewControllers: [UIViewController] = []
    private let selectIndex: Int
    
    init(selectIndex: Int ,imagePathList: [PetImageModel]) {
        self.imagePathList = imagePathList
        self.selectIndex = selectIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        viewControllers = imagePathList.map { FullScreenImageViewController(imagePath: $0.imagePath) }
        view.addSubview(imagePageViewController.view)
        view.addSubview(dismissButton)
        imagePageViewController.dataSource = self
        imagePageViewController.setViewControllers([viewControllers[selectIndex]], direction: .forward, animated: true)
    }
    
    override func setContraints() {
        view.backgroundColor = .black
        dismissButton.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.leading.top.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc private func tapDismissButton() {
        dismiss(animated: true)
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
