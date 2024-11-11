//
//  UserInfoEntryViewController.swift
//  imdangg
//
//  Created by daye on 11/11/24.
//

import UIKit

class UserInfoEntryViewController: UIViewController {

    private lazy var userInfoEntryView = UserInfoEntryView(controlBy: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userInfoEntryView.setup()
        userInfoEntryView.reactor = UserInfoEntryViewReactor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func loadView() {
        self.view = userInfoEntryView
    }
}
