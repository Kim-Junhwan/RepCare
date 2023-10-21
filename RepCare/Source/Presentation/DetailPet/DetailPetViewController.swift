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
    
    lazy var profileViewController = ProfileViewController(headerViewController: headerViewController, headerViewHeight: view.frame.width)
    lazy var headerViewController = DetailPetHeaderViewController(pet: viewModel.pet)
    lazy var petCalenderViewController = PetCalenderViewController(taskRepository: DefaultTaskRepository(petStorage: RealmPetStorage(), taskStorage: RealmTaskStorage()), pet: viewModel.pet)
    let petWeightViewController = PetWeightViewController()
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
    }
    
    override func configureView() {
        profileViewController.delegate = self
        profileViewController.datasource = self
        view.addSubview(profileViewController.view)
        addChild(profileViewController)
        profileViewController.didMove(toParent: self)
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
