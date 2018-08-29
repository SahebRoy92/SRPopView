//
//  SRSwiftyPopoverView.swift
//  SRSwiftyPopoverDemo
//
//  Created by Administrator on 26/12/17.
//  Copyright © 2017 Order of the Light. All rights reserved.
//

import Foundation
import UIKit



protocol SRSwiftyPopviewDelegate {
    func textFieldDidChange(_ str : String)
    func didPickItem(str : String,index : Int)
    func dismissWithoutPicking()
}


class SRSwiftyPopoverView : UIView{
    
    var delegate : SRSwiftyPopviewDelegate!
    
    private let maxLabelHeight : CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 120.0 : 50.0
    private let screenSize = UIScreen.main.bounds
    public var allItems = [String]()
    internal(set) public var selectedIndex = -1
    private(set) public var autoSearch = true
    private var actualheight : Double = 0.0
    fileprivate let cellHeight = UIDevice.current.userInterfaceIdiom == .pad ? 80.0 : 40.0
    private var shouldScroll = false
    private var initialTopPosition : CGFloat = 0.0
    private var heightConst : NSLayoutConstraint!
    private var verticalConst : NSLayoutConstraint!
    private var tempTopConst : NSLayoutConstraint!
    private var tempConst : NSLayoutConstraint!
    private var orientationActualHeight : CGFloat = 0.0
    private let tempConstantTopHeightLandscape = UIDevice.current.userInterfaceIdiom == .pad ? CGFloat(60) : CGFloat(20)
    private let screenSizeProportionHeight : CGFloat = 0.75
    
    var keyboardcalls = 0
    
    
    private lazy var layerView : UIView = {
        let lazyLayerView = UIView(frame: UIScreen.main.bounds)
        lazyLayerView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4385178257)
        lazyLayerView.alpha = 1.0
        return lazyLayerView
    }()
    
    private lazy var mainPopview : UIView = {
        let lazyMainPopview = UIView()
        lazyMainPopview.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        lazyMainPopview.translatesAutoresizingMaskIntoConstraints = false
        return lazyMainPopview
    }()
    
    private lazy var topView : UIView = {
        let lzyTopView = UIView()
        lzyTopView.translatesAutoresizingMaskIntoConstraints = false
        lzyTopView.backgroundColor = #colorLiteral(red: 1, green: 0.1085712331, blue: 0.08336619562, alpha: 1)
        return lzyTopView
        
    }()
    
    
    private lazy var textLabel : UILabel = {
        let lzyLabel = UILabel()
        lzyLabel.text = "Heading --- qwieuhqwi ehqwueh wqiuehqwe hqwuie huiqwh eui"
        lzyLabel.translatesAutoresizingMaskIntoConstraints = false
        lzyLabel.backgroundColor = UIColor.clear
        lzyLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        lzyLabel.numberOfLines = 0
        lzyLabel.textAlignment = .center
        lzyLabel.lineBreakMode = .byWordWrapping
        lzyLabel.font = UIFont.systemFont(ofSize: 15)
        return lzyLabel
    }()
    
    private(set) public lazy var tblView : UITableView = {
        let lzyTableview = UITableView()
        lzyTableview.dataSource = self
        lzyTableview.delegate = self
        lzyTableview.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        lzyTableview.allowsMultipleSelection = false
        lzyTableview.showsVerticalScrollIndicator = false
        lzyTableview.showsHorizontalScrollIndicator = false
        lzyTableview.separatorStyle = .singleLine
        lzyTableview.separatorColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        lzyTableview.separatorInset = UIEdgeInsetsMake(0, 5, 0, 5)
        lzyTableview.translatesAutoresizingMaskIntoConstraints = false
        return lzyTableview
    }()
    
    private lazy var searchField : UITextField = {
        let lzySearchfield = UITextField()
        lzySearchfield.placeholder = "Search"
        lzySearchfield.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        lzySearchfield.clearButtonMode = .whileEditing
        lzySearchfield.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        lzySearchfield.setLeftPaddingPoints(8)
        lzySearchfield.font = UIFont.systemFont(ofSize: 15)
        lzySearchfield.delegate = self
        lzySearchfield.addTarget(self, action: #selector(textfieldDidChange(_:)), for: .editingChanged)
        return lzySearchfield
    }()
    
    
    
    init(withItems items : [String], andSelectedItem index : Int = -1, autoSearchbar : Bool = false) {
        super.init(frame: screenSize)
        allItems = items
        selectedIndex = index
        autoSearch = autoSearchbar
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(){
        setupLayerConstraints()
        setupTopView()
        setupTablebviewConstraints()
        setupMainPopConstraints()
        addNotifications()
        print("Done setting up !!")
    }
    
    deinit {
        print("View getting deallocated ------ ")
    }
    
    private func addNotifications(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidAppear(_:)),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
       
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChangeNoticed(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    func removeKeyboardNotfications(){
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc
    func orientationChangeNoticed(_ notification: NSNotification){
        if UIDevice.current.orientation.isLandscape{
            tempTopConst.constant = tempConstantTopHeightLandscape
        }
        else {
            tempTopConst.constant = initialTopPosition
        }
        
        let addHeightConstrantMultiplier = calculateEstimatedHeight()
        if (addHeightConstrantMultiplier) {
            tempConst.isActive = true
            heightConst.isActive = false
        }
        else {
            
            heightConst.isActive = true
            tempConst.isActive = false
            
        }
        print("===== ACTUAL HEIGHT == \(actualheight)")
        self.layoutIfNeeded()
    }
    
    
    
    
    @objc
    func keyboardDidAppear(_ notification: NSNotification){
        
        print("Keyboard call : \(keyboardcalls)")
        keyboardcalls += 1
        
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let keyboardHeight = endFrame?.size.height ?? 0.0
            
            if endFrameY >= UIScreen.main.bounds.size.height {
                calculateHowMuchToMove(false, val: 0)
               // move down
            } else {
               // move up keyboardHeight
                 calculateHowMuchToMove(true, val: keyboardHeight)
            }
            
        }
    }
    
    private func calculateHowMuchToMove(_ up : Bool , val : CGFloat){

        
        if up {
            let mainPopHeight = CGFloat(actualheight)
            let decreasedHeight = mainPopHeight + initialTopPosition - val
            
            heightConst.isActive = false
            verticalConst.isActive = false
            tempConst.isActive = true
            tempTopConst.isActive = true

             self.tempConst.constant = decreasedHeight - tempConstantTopHeightLandscape
            
        }
        else {
            
            tempConst.isActive = false
            tempTopConst.isActive = false
            
            heightConst.isActive = true
            verticalConst.isActive = true
        }
        
        UIView.animate(withDuration: 0.4, animations: {
            self.layoutIfNeeded()
        })
        
    }
    
    private func setupLayerConstraints(){
        NSLayoutConstraint.addConstraintsFit(ToSuperview: self, andSubview: layerView)
    }
    
    
    
    private func setupMainPopConstraints(){
        
        layerView.addSubview(mainPopview)
        let addHeightConstrantMultiplier = calculateEstimatedHeight()
        
        if (addHeightConstrantMultiplier) {
            
            heightConst = NSLayoutConstraint(item: mainPopview, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: CGFloat(actualheight))
             tblView.isScrollEnabled = false
        }
        else {
            heightConst = NSLayoutConstraint(item: mainPopview, attribute: .height, relatedBy: .equal, toItem: layerView, attribute: .height, multiplier: 0.75, constant: 1.0)
            tblView.isScrollEnabled = true
        }
        
        
        
        let widthConst = NSLayoutConstraint(item: mainPopview, attribute: .width, relatedBy: .equal, toItem: layerView, attribute: .width, multiplier: 0.8, constant: 1.0)

        let horizontalCenter = NSLayoutConstraint(item: mainPopview, attribute: .centerX, relatedBy: .equal, toItem: layerView, attribute: .centerX, multiplier: 1.0, constant: 1.0)

        verticalConst = NSLayoutConstraint(item: mainPopview, attribute: .centerY, relatedBy: .equal, toItem: layerView, attribute: .centerY, multiplier: 1.0, constant: 1.0)

        self.addConstraints([heightConst,widthConst,horizontalCenter,verticalConst])
        
        
        orientationActualHeight = CGFloat(actualheight)

        tempConst = NSLayoutConstraint(item: mainPopview, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: CGFloat(actualheight))

        initialTopPosition = UIDevice.current.userInterfaceIdiom == .pad ? 60 : (screenSize.height - CGFloat(actualheight))/2
        
        tempTopConst = NSLayoutConstraint(item: mainPopview, attribute: .top, relatedBy: .equal, toItem: layerView, attribute: .top, multiplier: 1.0, constant:initialTopPosition)
         self.addConstraints([tempConst,tempTopConst])
        
        tempTopConst.isActive = false
        tempConst.isActive = false
        
    }
    
    private func calculateEstimatedHeight() -> Bool{
        
        let trueHeight = UIScreen.main.bounds.size.height
        let calculatedHeightScreenSize = Double(screenSizeProportionHeight * trueHeight)
        var topViewHeight : Double = 0.0;
        
        if shouldScroll && autoSearch {
            topViewHeight = Double(textLabel.getSwiftyHeight()) + 40
        }
        else {
            topViewHeight = Double(textLabel.getSwiftyHeight()) + 10
        }
        
        
        let estimatedheight = (Double(allItems.count) * cellHeight) + topViewHeight
        
        actualheight = estimatedheight > calculatedHeightScreenSize ? calculatedHeightScreenSize : estimatedheight
        
        return actualheight == estimatedheight ? true : false
    }
    
    private func mainViewShouldScroll() -> Bool{
        
        let calculatedHeightScreenSize = Double(0.75 * screenSize.height)
        let estimatedheight = (Double(allItems.count) * cellHeight)
        return estimatedheight > calculatedHeightScreenSize ? true : false
        
    }
    
    
    private func setupTopView(){
        
        shouldScroll = mainViewShouldScroll()
 
        if(autoSearch && shouldScroll){
            addSearchBar()
        }else {
            addHeading()
        }
        
        NSLayoutConstraint.addConstraint(ToSuperview: mainPopview, subview: topView, andConstraintValues: ConstraintValues(withTop: 0, bottom: nil, left: 0, right: 0, height: nil, width: nil))
        
    }

    
    private func addHeading(){
        NSLayoutConstraint.addConstraintsFit(ToSuperview: topView, andSubview: textLabel, horizontalpadding: HorizontalPadding(left: 0, right: 0), verticalPadding: VerticalPadding(top: 5, bottom: 5))
        
        
        let heightConst = NSLayoutConstraint(item: textLabel, attribute: .height, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: maxLabelHeight)
        textLabel.addConstraint(heightConst)
    }
    
    
    private func addSearchBar(){

        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        searchField.translatesAutoresizingMaskIntoConstraints = false
        
        topView.addSubview(textLabel)
        topView.addSubview(searchField)
        
        
        let subviews = ["textLabel":textLabel,"searchText":searchField] as [String : Any]
        let verticalConst = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[textLabel(>=50)]-5-[searchText(30)]-(5)-|", options: [], metrics: nil, views: subviews)
        
        let horizontalTxt = NSLayoutConstraint.constraints(withVisualFormat:  "H:|-(0)-[textLabel]-(0)-|", options: [], metrics: nil, views: subviews)
        
        let horizontalSearch = NSLayoutConstraint.constraints(withVisualFormat:  "H:|-(5)-[searchText]-(5)-|", options: [], metrics: nil, views: subviews)
        
        
        
        topView.addConstraints(verticalConst)
        topView.addConstraints(horizontalTxt)
        topView.addConstraints(horizontalSearch)
        
        
        
    }
    
    
    private func setupTablebviewConstraints(){
       
        
        NSLayoutConstraint.addConstraint(ToSuperview: mainPopview, subview: tblView, andConstraintValues: ConstraintValues(withTop: nil, bottom: 0, left: 0, right: 0, height: nil, width: nil))
        

        let topConst = NSLayoutConstraint(item: tblView, attribute: .top, relatedBy: .equal, toItem: topView, attribute: .bottom, multiplier: 1.0, constant: 0)

        mainPopview.addConstraint(topConst)
        
    }
    
    fileprivate func configureCell(withCell cell : UITableViewCell, andIndex index : IndexPath){
        cell.textLabel?.text = allItems[index.row]
    }
    
    
    
    
    @objc
    private func textfieldDidChange(_ txtField : UITextField){
       self.delegate.textFieldDidChange(txtField.text!)
    }
    
    
    func didSelectItem(_ index : Int){
        let item = allItems[index]
        self.delegate.didPickItem(str: item, index: index)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        let touch = touches.first
        let touchPoint = touch?.location(in: self)
        let touchedView = self.hitTest(touchPoint!, with: event)!
        
        
        if(!touchedView.isDescendant(of: mainPopview)){
            self.delegate.dismissWithoutPicking()
        }
        
    }
    
    
}


extension SRSwiftyPopoverView : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        guard let newCell = cell else {
            
            let c = UITableViewCell(style: .default, reuseIdentifier: "cell")
            c.backgroundColor = .clear
            c.selectionStyle = .none
            c.accessoryType = .none
            c.textLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            c.textLabel?.font = UIFont.systemFont(ofSize: 14)
            
            configureCell(withCell: c, andIndex: indexPath)
            return c
            
        }

        configureCell(withCell: newCell, andIndex: indexPath)
        return newCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(cellHeight)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        self.didSelectItem(selectedIndex)
    }
    
    
}

extension SRSwiftyPopoverView : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        keyboardcalls = 0
        return true
    }
}

