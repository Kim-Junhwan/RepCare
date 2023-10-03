//
//  PetListViewController.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/09/29.
//

import UIKit
import RealmSwift

final class PetListViewController: BaseViewController {
    
    let mainView = PetListView()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "개체 목록"
    }
    

}
