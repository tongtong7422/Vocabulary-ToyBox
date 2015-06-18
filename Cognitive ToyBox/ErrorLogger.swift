//
//  ErrorLogger.swift
//  Cognitive ToyBox
//
//  Created by Heng Lyu on 7/24/14.
//  Copyright (c) 2014 Cognitive ToyBox. All rights reserved.
//

import Foundation

class ErrorLogger {
  class func logError (error: NSErrorPointer, message: String) -> Bool {
    if error != nil {
      NSLog("error: \(message), \(error.memory)")
      Flurry.logError("error", message: message, error: error.memory)
      return true
    }
    
    return false
  }
}