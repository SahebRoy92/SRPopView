//
//  SRSwiftyPopManager.swift
//  SRSwiftyPopoverDemo
//
//  Created by Administrator on 26/12/17.
//  Copyright © 2017 Order of the Light. All rights reserved.
//

import Foundation


//autlayout for popview in the window !~

public enum Result{
    case notPicked()
    case picked(String,Int)
}

public enum SRPopViewColorScheme{
    case dark
    case bright
    case black
    case matte
    case strangerthings
    case westworld
    case firefly
}

public typealias SRPopviewCompletion = (Result)->Void

public class SRPopview : NSObject{
    
    public static let shared = SRPopview()
    internal(set) public var currentItems : Array<String>!
    private(set) public var originalItems : Array<String>!
    private(set) public var selectedItem = -1
    public var currentColorScheme : SRPopViewColorScheme!
    internal var comp : SRPopviewCompletion?
    internal var popView : SRSwiftyPopoverView!
    private var autoSearch = false

    
    public class func show(withValues array : Array<String>, autoSearch a : Bool = false,selectedIndex s : Int = 0,colorscheme cs : SRPopViewColorScheme = .dark, completion c : SRPopviewCompletion?){
        
        SRPopview.shared.currentItems            = array
        SRPopview.shared.originalItems           = array
        SRPopview.shared.selectedItem            = s
        SRPopview.shared.autoSearch              = a
        SRPopview.shared.currentColorScheme     = cs
        
        if let hasCompletion = c {
            SRPopview.shared.comp = hasCompletion
        }
        SRPopview.shared.configure()
        
    }
    
    public class func dismiss(){
        SRPopview.shared.dismissAnimated()
    }
    
    private func configure(){
        popView = SRSwiftyPopoverView(withItems: currentItems, andSelectedItem: selectedItem, autoSearchbar: autoSearch)
        popView.translatesAutoresizingMaskIntoConstraints = false
        popView.alpha = 0.0
        popView.delegate = self
        popView.configure()
        self.showAnimated()
        
    }
    
    private func showAnimated(){
        let window = UIApplication.shared.keyWindow!
        window.addSubview(popView)
        NSLayoutConstraint.addConstraintsFit(ToSuperview: window, andSubview: popView)
        
        UIView.animate(withDuration: 0.3) {
            self.popView.alpha = 1.0
        }
    }
    
    internal func dismissAnimated(){
        popView.removeKeyboardNotfications()
        UIView.animate(withDuration: 0.3, animations: {
            self.popView.alpha = 0.0
        }) { (_) in
            self.cleanup()
        }
    }
    
    private func cleanup(){
        popView.removeFromSuperview()
        popView = nil
        print("Cleanup Done")
    }
}


extension SRPopview : SRSwiftyPopviewDelegate{
    func dismissWithoutPicking() {
        dismissAnimated()
        comp?(.notPicked())
    }

    func didPickItem(str: String, index: Int) {
        comp?(.picked(str, index))
        dismissAnimated()
    }
    
    func textFieldDidChange(_ str: String) {
        print(str)
        // do predicate operations --- >>>
        if(str != ""){
            currentItems = originalItems.filter{
                $0.localizedCaseInsensitiveContains(str)
            }
        }
        else {
            currentItems = originalItems
        }
        popView.allItems = currentItems
        popView.tblView.reloadData()
        
    }
    
}
