//
//  UserPerformance.swift
//  Cognitive ToyBox
//
//  Created by Heng Lyu on 7/25/14.
//  Copyright (c) 2014 Cognitive ToyBox. All rights reserved.
//

import UIKit
import CoreData

@objc(UserPerformance)
class UserPerformance: NSManagedObject {
  
  @NSManaged var name: String
//  @NSManaged var date: NSDate
//  @NSManaged var correct: NSNumber
  @NSManaged var firstAppear: NameFirstAppear
  @NSManaged var correcttimes: Int16
  @NSManaged var appeartimes: Int16
  
  override func prepareForDeletion() {
    if self.firstAppear.appearances.count == 1 {
      self.managedObjectContext?.deleteObject(self.firstAppear)
    }
  }
  
}
