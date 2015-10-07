//
//  StatisticsTrackHelper.swift
//  Cognitive ToyBox
//
//  Created by Heng Lyu on 8/27/14.
//  Copyright (c) 2014 Cognitive ToyBox. All rights reserved.
//

import Foundation

/* record statistics info including username, objects displayed, correctness and settings, and send to Flurry */
class StatisticsTrackHelper {
  
  /* data container */
  private var data: [String: String]?
  
  /* turn on or off the data track */
  var validate = false
  
  /* Keys */
  private enum Keys: String {
    case User = "User"
    case Date = "Date"
    case TimeStart = "Time Start"
    case TimeEnd = "Time End"
    case Object1 = "Object 1"
    case Object2 = "Object 2"
    case Object3 = "Object 3"
    case Object4 = "Object 4"
    case DistractionType = "Distraction Type (Color, Texture)"
    case Correct = "Correct (Y, N, No Response)"
    case TaskType = "Task Type (Shape Bias, Vocabulary)"
    case Settings = "Settings"
    
    static let allValues = [
      User,
      Date,
      TimeStart,
      TimeEnd,
      Object1,
      Object2,
      Object3,
//      DistractionType,
      Correct,
      TaskType,
//      Settings
    ]
  }
  
  init () {
//    if let userInfo = UserInfoHelper.getUserInfo() {
      data = [:]
      for key in Keys.allValues {
        data![key.rawValue] = ""
      }
      
//    } else {
//      data = nil
//    }
  }
  
  func setUser (userInfo: UserInfo) {
    data![Keys.User.rawValue] = userInfo.description
  }
  
  func setDate (date: NSDate) {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "dd-MMM"
    data![Keys.Date.rawValue] = formatter.stringFromDate(date)
  }
  
  func setTimeStart (date: NSDate) {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "HH:mm:ss a"
    data![Keys.TimeStart.rawValue] = formatter.stringFromDate(date)
  }
  
  func setTimeEnd (date: NSDate) {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "HH:mm:ss a"
    data![Keys.TimeEnd.rawValue] = formatter.stringFromDate(date)
  }
  
  func setObject1 (object: CognitiveToyBoxObject) {
    data![Keys.Object1.rawValue] = object.description
  }
  
  func setObject2 (object: CognitiveToyBoxObject) {
    data![Keys.Object2.rawValue] = object.description
  }
  
  func setObject3 (object: CognitiveToyBoxObject) {
    data![Keys.Object3.rawValue] = object.description
  }
  
  func setObject4 (object: CognitiveToyBoxObject) {
    data![Keys.Object4.rawValue] = object.description
  }
  
//  public func setDistractionType (type: String) {
//    if type != "Color" && type != "Texture" {
//      NSException(name: NSInvalidArgumentException, reason: "Invalid Distraction Type", userInfo: nil).raise()
//    }
//    
//    data![Keys.DistractionType.toRaw()] = type
//  }
  
  func setCorrect (correct: Bool?) {
    var correctStr: String
    if correct == nil {
      correctStr = "No Response"
    } else if correct! {
      correctStr = "Y"
    } else {
      correctStr = "N"
    }
    
    data![Keys.Correct.rawValue] = correctStr
  }
  
  func setTaskType (type: String) {
    if type != "Shape Bias" && type != "Vocabulary" {
      NSException(name: NSInvalidArgumentException, reason: "Invalid Distraction Type", userInfo: nil).raise()
    }
    
    data![Keys.TaskType.rawValue] = type
  }
  
//  public func setSettings () {
//    
//  }
  
  func logEvent () {
    if validate {
      Flurry.logEvent("Session Info", withParameters: data, timed: true)
    }
  }
  
}