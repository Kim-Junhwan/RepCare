//
//  DetailPetTabViewController.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/15.
//

import Foundation
import Tabman
import Pageboy
import UIKit

protocol CustomTabBarDelegate: AnyObject {
    func pageViewController(_ currentViewController: UIViewController?, didselectPageAt index: Int)
}

class DetailPetTabViewController: TabmanViewController {
    
    private var viewControllers = [UIViewController(), UIViewController()]
    
    lazy var bar: TMBar = {
        let bar = TMBar.ButtonBar()
        bar.backgroundView.style = .flat(color: .systemBackground)
        bar.layout.transitionStyle = .snap
        bar.layout.contentInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        bar.buttons.customize { button in
            button.tintColor = .black
            button.selectedTintColor = .lightDeepGreen
        }
        bar.indicator.tintColor = .lightDeepGreen
        return bar
    }()
    
    weak var delegate: CustomTabBarDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setTapBar(datasource: TMBarDataSource) {
        addBar(bar, dataSource: datasource, at: .top)
    }
    
    override func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollToPageAt index: TabmanViewController.PageIndex, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        super.pageboyViewController(pageboyViewController, didScrollToPageAt: index, direction: direction, animated: animated)
        delegate?.pageViewController(dataSource?.viewController(for: self, at: index), didselectPageAt: index)
    }
}
