//
//  BaseVC.swift
//  BLETagDemo
//
//  Created by Nirzar Gandhi on 19/02/25.
//

import UIKit

class BaseVC: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    
    
    // MARK: -
    // MARK: - View init Methods
    override func viewDidLoad() {
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        self.navBarConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        self.hideNavigationBottomShadow()
        
        APPDELEOBJ.navController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
    }
}


// MARK: -
// MARK: - Call Back
extension BaseVC {
    
    func navBarConfig() {
        
        // Navigation Bar configuration
        if #available(iOS 13, *) {
            
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            
            appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.white]
            
            appearance.backgroundColor = .black
            appearance.shadowColor = .black
            
            self.navigationItem.standardAppearance = appearance
            self.navigationItem.scrollEdgeAppearance = appearance
            
        } else {
            
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.white]
            UINavigationBar.appearance().tintColor = UIColor.white
            
            //UINavigationBar.appearance().shadowImage = UIColor.red.as1ptImage()
            //UINavigationBar.appearance().setBackgroundImage(UIColor.getCarrorRed().as1ptImage(), for: .default)
            
            UINavigationBar.appearance().shadowImage = UIImage()
            UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        }
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
    }
}


// MARK: -
// MARK: - Button Touch & Action
extension BaseVC {
    
    // Left Bar Buttons
    @objc func back(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
}
