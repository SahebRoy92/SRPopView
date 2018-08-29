//
//  SRExtensions.swift
//  SRSwiftyPopoverDemo
//
//  Created by Administrator on 26/12/17.
//  Copyright © 2017 Order of the Light. All rights reserved.
//

import Foundation



struct HorizontalPadding {
    let left : CGFloat?
    let right : CGFloat?
}

struct VerticalPadding {
    let top : CGFloat?
    let bottom : CGFloat?
}

struct ConstraintValues {
    let top     : CGFloat?
    let bottom  : CGFloat?
    let left    : CGFloat?
    let right   : CGFloat?
    let height  : CGFloat?
    let width   : CGFloat?
    
    init(withTop t : CGFloat? = nil ,bottom b : CGFloat? = 0 , left l : CGFloat? = 0 , right r : CGFloat? = 0, height h:CGFloat? = 0 , width w : CGFloat? = nil) {
        top     = t
        bottom  = b
        left    = l
        right   = r
        height  = h
        width   = w
    }
}

extension NSLayoutConstraint{
    class func addConstraint(ToSuperview superview : UIView, subview sub : UIView , andConstraintValues c : ConstraintValues?){
        sub.translatesAutoresizingMaskIntoConstraints = false
        superview.addSubview(sub)
        
        if let topConstVal = c?.top  {
            let topConstraint = NSLayoutConstraint(item: sub, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: topConstVal)
            superview.addConstraint(topConstraint)
        }
        
        if let bottomConstVal = c?.bottom  {
            let bottomConstraint = NSLayoutConstraint(item: sub, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: bottomConstVal)
            superview.addConstraint(bottomConstraint)
        }
        
        if let leadingConstVal = c?.left  {
            let leadingConstraint = NSLayoutConstraint(item: sub, attribute: .left, relatedBy: .equal, toItem: superview, attribute: .left, multiplier: 1.0, constant: leadingConstVal)
            superview.addConstraint(leadingConstraint)
        }
        
        if let trailingConstVal = c?.right  {
            let trailingConstraint = NSLayoutConstraint(item: sub, attribute: .right, relatedBy: .equal, toItem: superview, attribute: .right, multiplier: 1.0, constant: trailingConstVal)
            superview.addConstraint(trailingConstraint)
        }
        
        if let heightVal = c?.height  {
            let heightConstraint = NSLayoutConstraint(item: sub, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: heightVal)
            superview.addConstraint(heightConstraint)
        }
        
        if let widthConstVal = c?.width  {
            let widthConstraint = NSLayoutConstraint(item: sub, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: widthConstVal)
            superview.addConstraint(widthConstraint)
        }
        
    }
    
  
    
    
    class func addConstraintsFit(ToSuperview superview : UIView, andSubview sub : UIView, horizontalpadding hP: HorizontalPadding? = nil, verticalPadding vP : VerticalPadding? = nil){
        sub.translatesAutoresizingMaskIntoConstraints = false
        superview.addSubview(sub)
        
        
        var metrics = Dictionary<String,CGFloat>()
        if hP != nil{
            metrics["left"] = hP?.left
            metrics["right"] = hP?.right
        }
        else {
            metrics["left"] = 0
            metrics["right"] = 0
        }
        
        
        
        if vP != nil{
            metrics["top"] = vP?.top
            metrics["bottom"] = vP?.bottom
        }
        else {
            metrics["top"] = 0
            metrics["bottom"] = 0
        }
        
        let dictValues = ["subview":sub]
        
        let verticalConst = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(top)-[subview]-(bottom)-|", options: [], metrics: metrics, views: dictValues)
        let horizontalConst = NSLayoutConstraint.constraints(withVisualFormat:  "H:|-(left)-[subview]-(right)-|", options: [], metrics: metrics, views: dictValues)
        
        superview.addConstraints(verticalConst)
        superview.addConstraints(horizontalConst)
    }
    
    
}

extension UILabel {
    
    func getSwiftyHeight() -> CGFloat{
        var constraintRect = self.bounds.size
        constraintRect.width = 0.8 * UIScreen.main.bounds.width
        
        let boundingBox = self.text?.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: self.font], context: nil)
        return ceil(boundingBox!.height)
    }

}


extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

