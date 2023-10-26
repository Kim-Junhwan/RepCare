//
//  DetailPetViewController.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/14.
//

import UIKit
import Pageboy
import Tabman

class DetailPetViewController: BaseViewController {
    
    lazy var menu: UIMenu = {
        let menu = UIMenu(title: "Menu", children: menuItems)
        return menu
    }()
    
    var menuItems: [UIAction] {
        return [
            UIAction(title: "개체 정보 수정", image: UIImage(systemName: "pencil"), handler: { [weak self] (_) in
                guard let self else { return }
                let updateVC = self.viewModel.diContainer.makeUpdateViewController(pet: self.viewModel.currentPet)
                updateVC.tapRegisterButtonClosure = {
                    try? self.viewModel.fetchDetailPetInfo()
                }
                let nvc = UINavigationController(rootViewController: updateVC)
                self.present(nvc, animated: true)
            }),
            UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive, handler: { _ in
                do {
                    try self.viewModel.deletePet()
                    self.updateClosure?()
                    self.navigationController?.popToRootViewController(animated: true)
                } catch {
                    print(error)
                }
                
            })
        ]
    }
    
    lazy var infoButton: UIBarButtonItem = {
        let buttonImage = UIImage(named: "ellipsis")?.withRenderingMode(.alwaysTemplate).resizeImage(size: .init(width: 20, height: 20))
        let barButton = UIBarButtonItem(image: buttonImage, menu: menu)
        barButton.tintColor = .white
        return barButton
    }()
    
    lazy var profileViewController = ProfileViewController(headerViewController: headerViewController, headerViewHeight: view.frame.width)
    let headerViewController: DetailPetHeaderViewController
    var petCalenderViewController: PetCalendarViewController
    var petWeightViewController: PetWeightViewController
    lazy var tabViewControllers = [petCalenderViewController, petWeightViewController]
    let viewModel: DetailPetViewModel
    var updateClosure: (()->Void)?
    
    init(headerViewController: DetailPetHeaderViewController, petCalenderViewController: PetCalendarViewController, petWeightViewController: PetWeightViewController, viewModel: DetailPetViewModel) {
        self.headerViewController = headerViewController
        self.petCalenderViewController = petCalenderViewController
        self.petWeightViewController = petWeightViewController
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarAppearance()
        bind()
        navigationController?.navigationBar.tintColor = .white
    }
    
    override func configureView() {
        profileViewController.delegate = self
        profileViewController.datasource = self
        view.addSubview(profileViewController.view)
        addChild(profileViewController)
        profileViewController.didMove(toParent: self)
        navigationItem.setRightBarButton(infoButton, animated: false)
    }
    
    override func setContraints() {
        profileViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func bind() {
        viewModel.petDriver.drive(with: self) { owner, pet in
            owner.headerViewController.setView(pet: pet)
        }
    }
    
    private func setNavigationBarAppearance() {
        let edgeAppearance = UINavigationBarAppearance()
        edgeAppearance.backgroundColor = .clear
        edgeAppearance.configureWithTransparentBackground()
        navigationController?.navigationBar.scrollEdgeAppearance = edgeAppearance
        let scrollApprearance = UINavigationBarAppearance()
        scrollApprearance.shadowColor = .clear
        scrollApprearance.backgroundColor = UIColor.systemBackground
        navigationController?.navigationBar.standardAppearance = scrollApprearance
        navigationController?.navigationBar.isTranslucent = true
    }
    
    deinit {
        print("deinit DetailPetVC")
    }

}

extension DetailPetViewController: ProfileViewControllerDelegate, ProfileViewControllerDataSource {
    func scroll(contentOffset: CGPoint) {
        let yOffset = contentOffset.y
        if yOffset == 0 {
            navigationController?.navigationBar.tintColor = .white
            infoButton.tintColor = .white
            return
        }
        navigationController?.navigationBar.tintColor = .black
        infoButton.tintColor = .black
    }
    
    func getCurrentBottomViewControllerContentInset(at index: Int) -> CGFloat {
        return 400
    }
    
    func minHeaderHeight() -> CGFloat {
        guard let navigationBarHeight = navigationController?.navigationBar.frame.height else { return 0 }
        guard let statusbarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height else { return 0 }
        return navigationBarHeight + statusbarHeight
    }
    
    func numberOfTabBarViewControllers() -> Int {
        return tabViewControllers.count
    }
    
    func tabBarViewController(at index: Int) -> UIViewController {
        return tabViewControllers[index]
    }
    
    func tabBarItemTitle(at index: Int) -> String {
        guard let title = tabViewControllers[index].title else { fatalError("No title") }
        return title
    }
}
