//
//  UserInfoHelper.swift
//  Cognitive ToyBox
//
//  Created by Heng Lyu on 8/26/14.
//  Copyright (c) 2014 Cognitive ToyBox. All rights reserved.
//

import Foundation
import CoreData

///* public info struct */
//public struct UserInfo: Printable {
//  var id: String
//  var name: String
//  var dateOfBirth: NSDate
//  
//  /* generate unique id including name and birth date */
//  public var description: String {
//    get {
//      return "\(name)_\(UserInfoHelper.birthDateToString(dateOfBirth))_\(id)"
//    }
//  }
//  
//  /* public constructor */
//  public init (id: String, name: String, dateOfBirth: NSDate) {
//    self.id = id
//    self.name = name
//    self.dateOfBirth = dateOfBirth
//  }
//  
//  /* construct from NSManagedObject */
//  private init (info: User) {
//    id = info.id
//    name = info.name
//    dateOfBirth = info.dateOfBirth
//  }
//}

public class UserInfoHelper {
  
  /* private global variable representing current user */
  private struct _UserInfo {
    static var user: UserInfo! = nil
//    static var id: String! = nil
//    static var name: String! = nil
//    static var dateOfBirth: NSDate! = nil
    
//    static func isInitialized () -> Bool {
////      return id != nil && name != nil && dateOfBirth != nil
//      return user != nil
//    }
//    
//    static func update (info: UserInfo) {
//      
//      user.id = info.id
//      user.name = info.name
//      user.dateOfBirth = info.dateOfBirth
//    }
//    
//    /* switch to parent account */
//    static func clear () {
//      user = nil
////      id = nil
////      name = nil
////      dateOfBirth = nil
//    }
//    
//    /* publish */
//    static func export () -> UserInfo! {
//      if let user = self.user {
//        return UserInfo(id: user.id, name: user.name, dateOfBirth: user.dateOfBirth)
//      }
//      
//      return nil
//    }
  }
  
  class func getAnonymousName() -> String {
    return "_Anonymous"
  }
  
  class func clearUser () {
    _UserInfo.user = nil
  }
  
  class func signUp (name name: String, dateOfBirth: NSDate, icon:UIImage) {
    
    /* generate user id */
    let cfuuid = CFUUIDCreate(kCFAllocatorDefault)
    var userId: String = CFUUIDCreateString(kCFAllocatorDefault, cfuuid) as NSString as String
    
    /* access core data */
    NSLog("Setting user info...")
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let context:NSManagedObjectContext = appDelegate.managedObjectContext
    var error : NSErrorPointer = nil
    
    /* fetch earlier records */
    var request = NSFetchRequest(entityName: "UserInfo")
    request.propertiesToFetch = NSArray(objects: "id") as [AnyObject]
    
    /** change the commented line in try block **/
//    var result: NSArray = context.executeFetchRequest(request, error: error)!
    var result = NSArray()
    do {
      result = try context.executeFetchRequest(request)
      // success ...
    } catch let error as NSError {
      // failure
      print("Fetch failed: \(error.localizedDescription)")
      ErrorLogger.logError(error, message: "Error fetching earlier user info")
    }
    
//    ErrorLogger.logError(error, message: "Error fetching earlier user info")
    
    /* retrieve user id */
    if result.count > 0 {
      userId = (result.firstObject as! UserInfo).id as String
      for userInfo in result as! [UserInfo] {
        if userInfo.name == name && userInfo.dateOfBirth == dateOfBirth {
          switchUser(userInfo)
          
          Flurry.setUserID(userId)
          return
        }
      }
    }
    
    /* insert new information */
    var newUser = NSEntityDescription.insertNewObjectForEntityForName("UserInfo", inManagedObjectContext: context) as! UserInfo
//    newUserInfo.setValue(userId, forKey: "id")
//    newUserInfo.setValue(name, forKey: "name")
//    newUserInfo.setValue(dateOfBirth, forKey: "birth_date")
    newUser.id = userId
    newUser.name = name
    newUser.dateOfBirth = dateOfBirth
    newUser.lastLogin = NSDate(timeIntervalSinceNow: 0)
    newUser.icon = UIImagePNGRepresentation(icon)!
    do{
      try context.save()
    }catch let error as NSError{
      print("Fetch failed: \(error.localizedDescription)")
      ErrorLogger.logError(error, message: "Error signing up user")
    }
//    context.save(error)
//    ErrorLogger.logError(error, message: "Error signing up user")
    
    /* update global variable */
//    switchUser(UserInfo(id: userId, name: name, dateOfBirth: dateOfBirth))
    switchUser(newUser)
    
    Flurry.setUserID(userId)
    NSLog("Done.")
  }
  
//  class func switchUser (info: UserInfo?) {
//    if info != nil {
//      _UserInfo.update(info!)
//    } else {
//      _UserInfo.clear()
//    }
//  }
  class func switchUser (user: UserInfo?) {
    _UserInfo.user = user
    if let userInfo = user {
      Flurry.setUserID(userInfo.id)
    }
  }
  
  /* get current user info. If no user has signed in, return nil. */
  class func getUserInfo () -> UserInfo? {
//    if !_UserInfo.isInitialized() {
//      let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
//      let context:NSManagedObjectContext = appDelegate.managedObjectContext!
//      var error : NSErrorPointer = nil
//      
//      NSLog("Fetching user info...")
//      var request = NSFetchRequest(entityName: "UserInfo")
//      var results: NSArray = context.executeFetchRequest(request, error: error)
//      
//      ErrorLogger.logError(error, message: "Error fething user info")
//      NSLog("Done.")
//      
//      if let info = results.firstObject as? NSManagedObject {
////        _UserInfo.id = info.valueForKey("id") as String
////        _UserInfo.name = info.valueForKey("name") as String
////        _UserInfo.dateOfBirth = info.valueForKey("birth_date") as NSDate
//        switchUser(UserInfo(info: info))
//      } else {
//        return nil
//      }
//      
//      
//    }
//    
//    
//    return _UserInfo.export()
    return _UserInfo.user
  }
  
  /* get all registered users */
  class func getUserList () -> [UserInfo] {
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let context:NSManagedObjectContext = appDelegate.managedObjectContext
    var error : NSErrorPointer = nil
    
    NSLog("Fetching user info...")
    var request = NSFetchRequest(entityName: "UserInfo")
    let sortDescriptor = NSSortDescriptor(key: "lastLogin", ascending: false)
    request.sortDescriptors = [sortDescriptor]
//    var results = context.executeFetchRequest(request, error: error) as! [UserInfo]
    var results:[UserInfo]!
    do{
      results = try context.executeFetchRequest(request) as! [UserInfo]
    }catch let error as NSError{
      print("Fetch failed: \(error.localizedDescription)")
      ErrorLogger.logError(error, message: "Error fething user info")
    }
    
//    ErrorLogger.logError(error, message: "Error fething user info")
    NSLog("Done.")
    
    return results.filter({ (user:UserInfo) -> Bool in
      user.name != UserInfoHelper.getAnonymousName()
    })
    
//    return results.map() {
//      (info: NSManagedObject) -> UserInfo in
//      UserInfo(info: info)
////        id: info.valueForKey("id") as String,
////        name: info.valueForKey("name") as String,
////        dateOfBirth: info.valueForKey("birth_date") as NSDate
////      )
//    }
  }
  
  /* convert date to string */
  class func birthDateToString (date: NSDate) -> String {
    var formatter = NSDateFormatter()
    formatter.dateFormat = "MMM dd, yyyy"
    return formatter.stringFromDate(date)
  }
  
  
}