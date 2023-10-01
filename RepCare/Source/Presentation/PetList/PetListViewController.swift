//
//  PetListViewController.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/09/29.
//

import UIKit
import RealmSwift

class PetListViewController: UIViewController {
    
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }

}
