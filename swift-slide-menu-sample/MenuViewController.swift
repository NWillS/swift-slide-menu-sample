//
//  MenuViewController.swift
//  swift-slide-menu-sample
//
//  Created by devWill on 2018/06/02.
//  Copyright © 2018年 devWill. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}
