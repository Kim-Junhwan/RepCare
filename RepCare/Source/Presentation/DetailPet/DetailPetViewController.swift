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
            UIAction(title: "개체 정보 수정", image: UIImage(systemName: "pencil"), handler: { (_) in
            }),
            UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive, handler: { (_) in
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
    lazy var headerViewController = DetailPetHeaderViewController(pet: viewModel.pet)
    lazy var petCalenderViewController = PetCalenderViewController(taskRepository: DefaultTaskRepository(petStorage: RealmPetStorage(), taskStorage: RealmTaskStorage()), pet: viewModel.pet)
    lazy var petWeightViewController = PetWeightViewController(weightRepository: DefaultWeightRepository(weightStroage: RealmWeightStorage(), petStorage: RealmPetStorage()), pet: viewModel.pet)
    lazy var tabViewControllers = [petCalenderViewController, petWeightViewController]
    let viewModel: DetailPetViewModel
    
    init(viewModel: DetailPetViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarAppearance()
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
    
    private func setNavigationBarAppearance() {
        let edgeAppearance = UINavigationBarAppearance()
        edgeAppearance.backgroundColor = .clear
        edgeAppearance.configureWithTransparentBackground()
        let defaultBackButtonStyle = UIBarButtonItemAppearance(style: .plain)
        //defaultBackButtonStyle.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
        edgeAppearance.backButtonAppearance = defaultBackButtonStyle
        navigationController?.navigationBar.scrollEdgeAppearance = edgeAppearance
        let scrollApprearance = UINavigationBarAppearance()
        let scrollBackButtonStyle = UIBarButtonItemAppearance(style: .plain)
        //scrollBackButtonStyle.normal.titleTextAttributes = [.foregroundColor: UIColor.black]
        scrollApprearance.shadowColor = .clear
        scrollApprearance.backgroundColor = UIColor.systemBackground
        scrollApprearance.backButtonAppearance = scrollBackButtonStyle
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
