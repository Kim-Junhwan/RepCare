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
    private var viewTransition: CGPoint = .init(x: 0, y: 0)
    private var alpha: CGFloat = 1.0
    let pagingBindingAction: (Int) -> Void
    
    init(selectIndex: Int ,imagePathList: [PetImageModel], pagingBindingAction: @escaping (Int) -> Void) {
        self.imagePathList = imagePathList
        self.selectIndex = selectIndex
        self.pagingBindingAction = pagingBindingAction
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panDismiss)))
    }
    
    override func configureView() {
        viewControllers = imagePathList.map { FullScreenImageViewController(imagePath: $0.imagePath) }
        view.addSubview(imagePageViewController.view)
        view.addSubview(dismissButton)
        imagePageViewController.dataSource = self
        imagePageViewController.delegate = self
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
    
    @objc func panDismiss(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            viewTransition = sender.translation(in: view)
            UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
                self.view.transform = CGAffineTransform(translationX: 0, y: self.viewTransition.y)
                self.view.alpha = 1 - (abs(self.viewTransition.y) / 300.0)
            }
        case .ended:
            if abs(viewTransition.y) < 200 {
                UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
                    self.view.transform = .identity
                    self.view.alpha = 1
                }
            } else {
                dismiss(animated: true)
            }
        default:
            break
        }
    }
}

extension FullScreenImagePageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let currentVC = pageViewController.viewControllers?.first, let currentIndex = viewControllers.firstIndex(of: currentVC) else { return }
        pagingBindingAction(currentIndex)
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
