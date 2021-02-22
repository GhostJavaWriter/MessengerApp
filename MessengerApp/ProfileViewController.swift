//
//  ProfileViewController.swift
//  MessengerApp
//
//  Created by Bair Nadtsalov on 12.02.2021.
//

import UIKit

class ProfileViewController: UIViewController {

    //MARK: - UI
    @IBOutlet weak var logoBackgroundView: UIView!
    @IBOutlet weak var logoFirstLetter: UILabel!
    @IBOutlet weak var logoSecondLetter: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var editButtonOutlet: UIButton!
    
    //MARK: - Private
    private func setupView() {
        //viewController title
        title = "My Profile"
        
        //setup logoBackgroundView
        logoBackgroundView.layer.cornerRadius = logoBackgroundView.frame.height/2
        logoBackgroundView.layer.masksToBounds = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapLogo))
        logoBackgroundView.addGestureRecognizer(tapGesture)
        
        editButtonOutlet.layer.cornerRadius = 14
    }
    
    @objc
    private func tapLogo() {
        print("tapped")
        
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("ViewController : \(#function)")
        
        setupView()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NSLog("ViewController : " + #function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       NSLog("ViewController : " + #function)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        NSLog("ViewController : " + #function)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        NSLog("ViewController : " + #function)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSLog("ViewController : " + #function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NSLog("ViewController : " + #function)
    }

}

