//
//  SettingsViewController.swift
//  SRSwiftyPopView_Example
//
//  Created by Administrator on 29/08/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import SRSwiftyPopView

class SettingsViewController: UIViewController {

    var allsettings = [[String : Any]]()
    @IBOutlet weak var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        loadSettings()
    }
    

    func loadSettings(){
        var blurResult = ""
        if  SRPopview.shared.blurBackground == .none {
            blurResult = "None"
        }
        else if SRPopview.shared.blurBackground == .dark {
            blurResult = "Dark"
        }
        else {
            blurResult = "Light"
        }
        
        
        var colorScheme = ""
        
        switch  SRPopview.shared.currentColorScheme {
        case .black:
            colorScheme = "black"
        case .dark:
            colorScheme = "dark"
        case .bright:
            colorScheme = "bright"
        case .matte:
            colorScheme = "matte"
        case .strangerthings:
            colorScheme = "strangerthings"
        case .westworld:
            colorScheme = "westworld"
        case .firefly:
            colorScheme = "firefly"
        }
        
        
        var logVal = ""
            
        if SRPopview.shared.showLog == .off {
            logVal = "Off"
        }
        else {
            logVal = "On"
        }
        
        
        allsettings = [
                        ["title" : "Auto Search",
                        "value" : ["On","Off"],
                        "current" : SRPopview.shared.autoSearch ? "On" : "Off"
                        ],
                        ["title" : "Background Blur",
                         "value" : ["None","Light","Dark"],
                         "current" : blurResult],
                        ["title" : "Color Scheme",
                         "value" : ["dark","bright","black","matte","strangerthings","westworld","firefly"],
            "current" : colorScheme],
                        ["title" : "Show Log",
                         "value" : ["On","Off"],
                          "current" : logVal
                         ]
                        
        ]
    }

    
    func redraw(){
        let searchCurrent = allsettings[0]["current"] as! String
        if searchCurrent == "On" {
            SRPopview.shared.autoSearch = true
        }
        else {
            SRPopview.shared.autoSearch = false
        }
        
        
        let backgroundBlurCurrent = allsettings[1]["current"] as! String
        switch backgroundBlurCurrent {
        case "None" :
            SRPopview.shared.blurBackground = .none
        case "Light" :
             SRPopview.shared.blurBackground = .vibrant
        case "Dark" :
            SRPopview.shared.blurBackground = .dark
        default:
            print("Nothing-")
        }
        
        let colorSchemeCurrent = allsettings[2]["current"] as! String
        switch  colorSchemeCurrent {
        case "black" :
            SRPopview.shared.currentColorScheme = .black
        case "dark" :
            SRPopview.shared.currentColorScheme = .dark
        case "bright" :
            SRPopview.shared.currentColorScheme  = .bright
        case "matte" :
           SRPopview.shared.currentColorScheme = .matte
        case "strangerthings" :
            SRPopview.shared.currentColorScheme = .strangerthings
        case "westworld" :
            SRPopview.shared.currentColorScheme = .westworld
        case "firefly" :
            SRPopview.shared.currentColorScheme = .firefly
        default:
            print("Nothing - ")
        }
        
        
        let logResult = allsettings[3]["current"] as! String
        if logResult == "On" {
            SRPopview.shared.showLog = .verbose
        }
        else {
            SRPopview.shared.showLog = .off
        }
        
    }
    
}

extension SettingsViewController : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return allsettings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dict = allsettings[section]
        let arr = dict["value"] as! [String]
        return arr.count
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dict = allsettings[section]
        return dict["title"] as? String
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuse")
        let dict = allsettings[indexPath.section]
        let itemArr = dict["value"] as! [String]
        let item = itemArr[indexPath.row]
        
        cell?.textLabel?.text = item
        
        let currentVal = dict["current"] as! String
        
        if currentVal == item {
            cell?.accessoryType = .checkmark
        }
        else {
            cell?.accessoryType = .none
        }
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var dict = allsettings[indexPath.section]
        let itemArr = dict["value"] as! [String]
        let item = itemArr[indexPath.row]
        dict["current"] = item
        allsettings[indexPath.section] = dict
        redraw()
        tableView.reloadData()
        
    }
    
}
