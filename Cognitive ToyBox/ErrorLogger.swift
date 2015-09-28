//
//  ErrorLogger.swift
//  Cognitive ToyBox
//
//  Created by Heng Lyu on 7/24/14.
//  Copyright (c) 2014 Cognitive ToyBox. All rights reserved.
//

import Foundation

class ErrorLogger {
  class func logError (error: NSError, message: String) -> Bool {
//    if error != nil {
      NSLog("error: \(message), \(error.localizedDescription)")
      Flurry.logError("error", message: message, error: error)
      return true
//    }
    
//    return false
  }
}