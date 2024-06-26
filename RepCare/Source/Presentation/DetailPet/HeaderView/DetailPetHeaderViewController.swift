//
//  DetailPetHeaderViewController.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/16.
//

import UIKit

class DetailPetHeaderViewController: BaseViewController {
    
    private let mainView = DetailPetHeaderView()
    var pet: PetModel
    var imagePathList: [PetImageModel] {
        return pet.imagePath
    }
    
    var viewControllers: [UIViewController] = []
    
    init(pet: PetModel) {
        self.pet = pet
        super.init(nibName: nil, bundle: nil)
    }
    
    override func configureView() {
        mainView.imagePageViewController.delegate = self
        mainView.imagePageViewController.dataSource = self
        mainView.pageControl.addTarget(self, action: #selector(pageControlHandler), for: .valueChanged)
    }
    
    func setView(pet: PetModel) {
        mainView.setPetInfo(pet: pet)
        mainView.pageControl.numberOfPages = pet.imagePath.count
        setViewControllers(imagePathList: pet.imagePath)
        mainView.imagePageViewController.setViewControllers([viewControllers[0]], direction: .forward, animated: true)
        mainView.pageControl.currentPage = 0
    }
    
   private func setViewControllers(imagePathList: [PetImageModel]) {
       guard let petClass = pet.overSpecies.petClass else { fatalError() }
        if imagePathList.isEmpty {
            viewControllers = [ImageViewController(petClass: petClass)]
            return
        }
       viewControllers = imagePathList.map { image in
           let imageController = ImageViewController(imagePath: image, imagePathList: imagePathList, petClass: petClass)
           imageController.pageTapAction = { num in
               let fullScreenImagePaegVC = self.makeFullScreenImagePageViewController(tapPageIndex: num)
               fullScreenImagePaegVC.modalPresentationStyle = .overFullScreen
               self.present(fullScreenImagePaegVC, animated: true)
           }
           return imageController
       }
    }
    
    private func makeFullScreenImagePageViewController(tapPageIndex: Int) -> FullScreenImagePageViewController {
        return FullScreenImagePageViewController(selectIndex: tapPageIndex, imagePathList: imagePathList) { pagingNum in
            self.mainView.imagePageViewController.setViewControllers([self.viewControllers[pagingNum]], direction: .forward, animated: false)
            self.mainView.pageControl.currentPage = pagingNum
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @objc func pageControlHandler(_ sender: UIPageControl) {
        guard let currentViewController = mainView.imagePageViewController.viewControllers?.first, let currentIndex = viewControllers.firstIndex(of: currentViewController) else { return }
        let direction: UIPageViewController.NavigationDirection = (sender.currentPage > currentIndex) ? .forward : .reverse
        mainView.imagePageViewController.setViewControllers([viewControllers[sender.currentPage]], direction: direction, animated: true)
    }
}

extension DetailPetHeaderViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = viewControllers.firstIndex(of: viewController), currentIndex > 0 else { return nil }
        
        return viewControllers[currentIndex-1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = viewControllers.firstIndex(of: viewController), currentIndex < viewControllers.count-1 else { return nil }
        return viewControllers[currentIndex+1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewControllerList = pageViewController.viewControllers, let currentIndex = viewControllers.firstIndex(of: viewControllerList[0]) else { return }
        mainView.pageControl.currentPage = currentIndex
    }
}
