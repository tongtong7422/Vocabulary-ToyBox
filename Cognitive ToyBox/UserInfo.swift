//
//  UserInfo.swift
//  Cognitive ToyBox
//
//  Created by Heng Lyu on 9/8/14.
//  Copyright (c) 2014 Cognitive ToyBox. All rights reserved.
//

import UIKit
import CoreData

@objc(UserInfo)
class UserInfo: NSManagedObject {
  
  @NSManaged var id: String
  @NSManaged var name: String
  @NSManaged var dateOfBirth: NSDate
  @NSManaged var lastLogin: NSDate
  @NSManaged var icon: NSData
  
  /* generate unique id including name and birth date */
  override internal var description: String {
    get {
      return "\(name)_\(UserInfoHelper.birthDateToString(dateOfBirth))_\(id)"
    }
  }
  
}
