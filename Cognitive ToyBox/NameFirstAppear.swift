//
//  NameFirstAppear.swift
//  Cognitive ToyBox
//
//  Created by Heng Lyu on 7/25/14.
//  Copyright (c) 2014 Cognitive ToyBox. All rights reserved.
//

import UIKit
import CoreData

@objc(NameFirstAppear)
class NameFirstAppear: NSManagedObject {
  
  @NSManaged var date: NSDate
  @NSManaged var name: String
  @NSManaged var appearances: NSSet
  
  
  
  
}
