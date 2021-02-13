//
//  ViewController.swift
//  MessengerApp
//
//  Created by Bair Nadtsalov on 12.02.2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSLog("ViewController : \(#function)")
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
        
        NSLog("ViewController : " + #function)
    }
    
    override func viewDidLayoutSubviews() {
        
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

