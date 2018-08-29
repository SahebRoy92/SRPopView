//
//  Common.swift
//  Pods-SRSwiftyPopView_Example
//
//  Created by Administrator on 29/08/18.
//

import Foundation


var logging : Logging = .off

func PLOG(_ msg : String) {
    if logging == .verbose {
        print(msg)
    }
}

public enum Logging {
    case verbose
    case off
}

