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

    @IBOutlet weak var backgroundImg: UIImageView!
    let allWallpaper = ["1","2","3","4","5","6"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImg.image = UIImage.init(named: "1")
    }

    
    
    @IBAction func toSettingsScreen(_ sender: Any) {
        self.performSegue(withIdentifier: "settingsSegue", sender: self)
    }
    
    @IBAction func refreshWallpaper(_ sender: Any) {
        let randomImage = allWallpaper.randomItem()
        backgroundImg.image = UIImage.init(named: randomImage!)
    }
    
    
    @IBAction func showAction(_ sender: Any) {
        
        SRPopview.show(withValues: ["Abc","XYZ","123","789","Abc","XYZ","123","789","Abc","XYZ","123","789","Abc","XYZ","123","789"], heading: "Heading") { (result) in
            switch result{
            case .notPicked():
                print("Didnt pick any")
            case .picked(let str, let index):
                print("Picked at \(index) \n Picked item : \(str)")
            }
        }

        
    }
    
}


extension Array {
    func randomItem() -> Element? {
        if isEmpty { return nil }
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}
