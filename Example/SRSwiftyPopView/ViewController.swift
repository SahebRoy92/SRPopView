//
//  ViewController.swift
//  SRSwiftyPopView
//
//  Created by sahebroy92 on 08/29/2018.
//  Copyright (c) 2018 sahebroy92. All rights reserved.
//

import UIKit
import SRSwiftyPopView

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showAction(_ sender: Any) {

        SRPopview.show(withValues: ["ABC","qwd","ABC","qwd"], autoSearch: true, selectedIndex: -1) { (result) in
            switch result{
            case .notPicked():
                print("Didnt pick any")
            case .picked(let str, let index):
                print("Picked at \(index) \n Picked item : \(str)")
            }
        }
        
    }
    
}

