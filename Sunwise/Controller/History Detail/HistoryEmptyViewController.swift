//
//  HistoryEmptyViewController.swift
//  Sunwise
//
//  Created by Ariel Waraney on 11/01/23.
//

import UIKit

class HistoryEmptyViewController: UIViewController {

    var selectedDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDateTitle()
        // Do any additional setup after loading the view.
    }
    
    func setupDateTitle() {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM yyyy"
        let selectedDate = formatter.string(from: selectedDate)
        title = selectedDate
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
   
}
