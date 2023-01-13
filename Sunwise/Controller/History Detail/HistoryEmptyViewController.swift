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
        setupNavigationView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func setupNavigationView() {
        let newNavBarAppearance = customNavbarAppearance()
        navigationController!.navigationBar.scrollEdgeAppearance = newNavBarAppearance
        navigationController?.navigationBar.standardAppearance = newNavBarAppearance
        navigationController?.navigationBar.tintColor = UIColor(named: "LB-mainText")
    }
    
    func customNavbarAppearance() -> UINavigationBarAppearance {
        let customNavBarAppearance = UINavigationBarAppearance()
        
        //adding the background
        customNavBarAppearance.configureWithOpaqueBackground()
        customNavBarAppearance.backgroundColor = UIColor(named: "TN-BG-mainYellow")
        
        //title color
        customNavBarAppearance.titleTextAttributes = [.foregroundColor: UIColor(named: "LB-mainText")!]
        
        //button color
        let barButtonItemAppearance = UIBarButtonItemAppearance(style: .plain)
        barButtonItemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(named: "LB-mainText")!]
        customNavBarAppearance.buttonAppearance = barButtonItemAppearance
        
        return customNavBarAppearance
    }
   
}
