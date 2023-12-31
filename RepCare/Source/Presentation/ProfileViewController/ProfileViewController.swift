//
//  ProfileViewController.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/16.
//

import UIKit
import Tabman
import Pageboy

protocol ProfileViewControllerDelegate: AnyObject {
    func minHeaderHeight() -> CGFloat
    func scroll(contentOffset: CGPoint)
}

protocol ProfileViewControllerDataSource: AnyObject {
    func numberOfTabBarViewControllers() -> Int
    func tabBarViewController(at index: Int) -> UIViewController
    func tabBarItemTitle(at index: Int) -> String
}

final class ProfileViewController: UIViewController {
    
    private let overlayScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        return scrollView
    }()
    
    private let containerScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private var panScrollViewObservation: NSKeyValueObservation?
    
    private var panViews: [Int: UIView] = [:] {
        didSet {
            if let scrollView = panViews[currentIndex] as? UIScrollView{
                scrollView.panGestureRecognizer.require(toFail: overlayScrollView.panGestureRecognizer)
                panScrollViewObservation = scrollView.observe(\.contentSize) { scroll, change in
                    self.updateOverlayScrollContentSize(with: scroll)
                }
            }
        }
    }
    private var contentOffsets: [Int: CGFloat] = [:]
    
    private let headerViewController: UIViewController
    private var headerView: UIView {
        return headerViewController.view
    }
    private let headerViewHeight: CGFloat
    private let bottomViewController: DetailPetTabViewController = .init()
    private var currentIndex = 0
    weak var delegate: ProfileViewControllerDelegate?
    weak var datasource: ProfileViewControllerDataSource?
    
    init(headerViewController: UIViewController, headerViewHeight: CGFloat) {
        self.headerViewController = headerViewController
        self.headerViewHeight = headerViewHeight
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let mainView = UIView()
        mainView.addSubview(overlayScrollView)
        mainView.addSubview(containerScrollView)
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setConstraints()
    }
    
    private func addViewControllerView(_ vc: UIViewController, at: UIView) {
        addChild(vc)
        at.addSubview(vc.view)
        vc.didMove(toParent: self)
    }
    
    private func configureView() {
        overlayScrollView.delegate = self
        bottomViewController.delegate = self
        bottomViewController.dataSource = self
        bottomViewController.setTapBar(datasource: self)
        containerScrollView.addGestureRecognizer(overlayScrollView.panGestureRecognizer)
        addViewControllerView(headerViewController, at: containerScrollView)
        addViewControllerView(bottomViewController, at: containerScrollView)
    }
    
    private func setConstraints() {
        overlayScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        containerScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        headerView.snp.makeConstraints { make in
            make.leading.trailing.width.equalToSuperview()
            make.top.equalTo(containerScrollView.snp.top)
            make.height.equalTo(headerViewHeight)
        }
        bottomViewController.view.snp.makeConstraints { make in
            make.bottom.leading.trailing.width.height.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
        }
    }
    
    private func updateOverlayScrollContentSize(with bottomView: UIView) {
        self.overlayScrollView.contentSize = getContentSize(for: bottomView)
    }
    
    private func getContentSize(for bottomView: UIView) -> CGSize {
        let tabBarHeight = bottomViewController.bar.frame.height
        let bottomInset = getBottomInset()
        if let scroll = bottomView as? UIScrollView{
            let bottomHeight = max(scroll.contentSize.height, self.view.frame.height - (delegate?.minHeaderHeight() ?? 0) - tabBarHeight - bottomInset )
            return CGSize(width: scroll.contentSize.width,
                          height: bottomHeight + headerView.frame.height + tabBarHeight + bottomInset )
        }else{
            let bottomHeight = self.view.frame.height - (delegate?.minHeaderHeight() ?? 0) - tabBarHeight
            return CGSize(width: bottomView.frame.width,
                          height: bottomHeight + headerView.frame.height + tabBarHeight + bottomInset)
        }
    }
    
    private func getBottomInset() -> CGFloat {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return 0 }
        guard let keywindow = window.keyWindow else { return 0 }
        if let tabBarController = keywindow.rootViewController?.tabBarController {
            return tabBarController.tabBar.frame.height
        }
        return keywindow.safeAreaInsets.bottom 
    }
}

extension ProfileViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        contentOffsets[currentIndex] = scrollView.contentOffset.y
        delegate?.scroll(contentOffset: scrollView.contentOffset)
        let topHeight = bottomViewController.view.frame.minY - (delegate?.minHeaderHeight() ?? 0)
        if scrollView.contentOffset.y < topHeight{
            self.containerScrollView.contentOffset.y = scrollView.contentOffset.y
            self.panViews.forEach({ (arg0) in
                let (_, value) = arg0
                (value as? UIScrollView)?.contentOffset.y = 0
            })
            contentOffsets.removeAll()
        }else{
            self.containerScrollView.contentOffset.y = topHeight
            (self.panViews[currentIndex] as? UIScrollView)?.contentOffset.y = scrollView.contentOffset.y - self.containerScrollView.contentOffset.y
        }
        
    }
}

extension ProfileViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        return datasource?.numberOfTabBarViewControllers() ?? 0
    }
    
    func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
        return datasource?.tabBarViewController(at: index)
    }
    
    func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? {
        nil
    }
    
    func barItem(for bar: Tabman.TMBar, at index: Int) -> Tabman.TMBarItemable {
        guard let title = datasource?.tabBarItemTitle(at: index) else { fatalError("NO TabBarItemTitle") }
        return TMBarItem(title: title)
    }
}

extension ProfileViewController: CustomTabBarDelegate {
    func pageViewController(_ currentViewController: UIViewController?, didselectPageAt index: Int) {
        currentIndex = index
        if let offset = contentOffsets[index] {
            self.overlayScrollView.contentOffset.y = offset
        } else {
            self.overlayScrollView.contentOffset.y = containerScrollView.contentOffset.y
        }
        if let vc = currentViewController, panViews[currentIndex] == nil {
            self.panViews[currentIndex] = vc.panView()
        }
        if let panView = self.panViews[currentIndex] {
            updateOverlayScrollContentSize(with: panView)
        }
    }
    
}

extension UIViewController {
    func panView() -> UIView {
        if let scroll = self.view.subviews.first(where: { $0 is UIScrollView }) {
            return scroll
        } else {
            return self.view
        }
    }
}
