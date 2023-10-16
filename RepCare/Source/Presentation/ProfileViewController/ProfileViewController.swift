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
}

final class ProfileViewController: UIViewController {
    
    private let overlayScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let containerScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    private var panViews: [Int: UIView] = [:] {
        didSet {
            if let scrollView = panViews[currentIndex] as? UIScrollView{
                scrollView.panGestureRecognizer.require(toFail: overlayScrollView.panGestureRecognizer)
                scrollView.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize), options: .new, context: nil)
            }
        }
    }
    private var contentOffsets: [Int: CGFloat] = [:]
    
    private let headerView: UIView
    private let headerViewHeight: CGFloat
    let bottomViewController: DetailPetTabViewController = .init()
    private var currentIndex = 0
    weak var delegate: ProfileViewControllerDelegate?
    
    init(headerView: UIView, headerViewHeight: CGFloat) {
        self.headerView = headerView
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
        containerScrollView.addGestureRecognizer(overlayScrollView.panGestureRecognizer)
        containerScrollView.addSubview(headerView)
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
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UIScrollView, keyPath == #keyPath(UIScrollView.contentSize) {
            if let scroll = self.panViews[currentIndex] as? UIScrollView, obj == scroll {
                updateOverlayScrollContentSize(with: scroll)
            }
        }
    }
    
}

extension ProfileViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        contentOffsets[currentIndex] = scrollView.contentOffset.y
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
