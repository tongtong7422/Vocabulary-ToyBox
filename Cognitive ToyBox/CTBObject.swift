//
//  CTBObject.swift
//  Cognitive ToyBox
//
//  Created by Heng Lyu on 6/20/14.
//  Copyright (c) 2014 Cognitive ToyBox. All rights reserved.
//

import UIKit
import CoreData

/*
CognitiveToyBoxObject represents objects to be recognized by children. name CANNOT be nil.

name - the name (category) of the object.
material - the material of the object. Convert to nil if unknown.
color - the color of the object. Convert to nil if unknown

func toString()
return String consistent to file name, e.g. apple_x_green

*/
public class CognitiveToyBoxObject : NSObject {
 
  public class var allObjects: [String] {
    get {
      return ["ball", "basket","belt", "bench","bird","bowl","chair","dog","dress","flag","glasses","gloves","glue","hammer","hose","jar","keys","ladder","lamp","napkin","necklace","pig","pretzel","scarf","shovel","sled","sofa","stairs","tape","toast","tractor","tractor","tray","tricycle","zipper"]
    }
  }
  
  public class var stage1Objects: [String] {
    get {
      return ["apple", "airplane", "ball", "balloon", "cat", "cookie", "dog", "shoe", "cup", "socks"]
    }
  }
  
  public class var stage2Objects: [String] {
    get {
      return ["bearteddy", "bed", "chair", "glasses", "grapes", "pen","rock","toothbrush","tree","turtle"]
    }
  }
  
  public class var stage3Objects: [String] {
    get {
      return ["basket", "flag", "hammer", "ladder", "motorcycle", "sofa", "shovel", "stove","tractor","tablesmall"]
    }
  }
  
  public class var tutorialObjects: [String] {
    get {
      return ["t_apple", "t_bowl", "t_bucket", "t_dax", "t_fork", "t_guitar", "t_hammer", "t_horn", "t_ibb", "t_kettle", "t_mug", "t_paddle", "t_pot", "t_pux", "t_rudder", "t_spoon", "t_trophy", "t_veet", "t_wif", "t_yen", "t_zup"]
    }
  }
  public class var testObjects: [String] {
    get {
      return ["ball","belt","sofa","tape","zipper"]
    }
  }
  
  public class var unknownMaterial: String {
  get {
    return "x"
  }
  }
  
  public class var unknownColor: String {
    get {
      return "x"
  }
  }
  
  /* private variables */
  private var _id : Int = -1
  private var _name : String = ""
  private var _filename:String = ""
    
  /* getters, no setters */
  public var id : Int { get { return _id } }
  public var name : String { get { return _name } }
  public var filename : String { get { return _filename } }

  
  override public var description : String {
  get {
//    var str = "\(self.name)_\(self.material == nil ? CognitiveToyBoxObject.unknownMaterial : self.material!)_\(self.color == nil ? CognitiveToyBoxObject.unknownColor : self.color!)"
//    return str
    return _filename;
  }
  }
  
  public func equals (theOtherObject:CognitiveToyBoxObject?) -> Bool {
    if let object = theOtherObject {
      return self.id == object.id && self.name == object.name && self.filename == object.filename
    }
    return false
  }
  
  public var pluralName: String {
    get {
      return CognitiveToyBoxObject.getPluralName(self.name)
    }
  }
  
  public class func getPluralName (name: String) -> String {
    if name.hasSuffix("y") {
      return name.substringToIndex(name.endIndex.predecessor()) + "ies"
    }
    
    if name.hasSuffix("x") {
      return name.substringToIndex(name.endIndex.predecessor()) + "es"
    }
    
    return name + "s"
  }
  
  public var playtimeImageFileName: String {
    get {
    
      return self.description
    }
  }
  
//  init () {
//    self.setId(-1)
//    self.setName("")
//    self.setMaterial(nil)
//    self.setColor(nil)
//  }
  
//  private init (id: Int, name:String, material:String?, color:String?) {
//    self._id = id
//    self._name = name
//    self._material = material
//    self._color = color
//  }

//  init (nsmObject:NSManagedObject) {
//    self.setId(nsmObject.valueForKey("id") as Int)
//    self.setName(nsmObject.valueForKey("name") as String)
//    self.setMaterial(nsmObject.valueForKey("material") as? String)
//    self.setColor(nsmObject.valueForKey("color") as String)
//  }
  
  
//   copy data from another CTBObject 
//  func copyFrom (ctbObject : CognitiveToyBoxObject) {
//    self.id = ctbObject.id
//    self.name = ctbObject.name
//    self.material = ctbObject.material
//    self.color = ctbObject.color
//    
//  }
  
  /* Return String consistent to file name, e.g. apple_x_green */
//  func toString () -> String {
//    return "\(self.name)_\(self.material == nil ? CognitiveToyBoxObject.unknownMaterial() : self.material)_\(self.color)"
//  }
//  
//  func setId (id:Int) {
//    self.id = id
//  }
//
//  func setName (name:String) {
//    self.name = name
//  }
//
//  func setMaterial (material:String?) {
//    self.material = material == CognitiveToyBoxObject.unknownMaterial() ? nil : material
//  }
//  
//  func setColor (color:String?) {
//    self.material = material == CognitiveToyBoxObject.unknownMaterial() ? nil : material
//  }
//  
//  func getId () -> Int {
//    return self.id
//  }
//  
//  func getName () -> String {
//    return self.name
//  }
//  
//  /* return nil if material is unknown */
//  func getMaterial () -> String? {
////    return self.material == object_getClass(self).unknownMaterial() ? nil : self.material
//    return self.material
//  }
//  
//  func getColor () -> String? {
//    return self.color
//  }
  
  /* return UIColor */
  //    func getColor () -> UIColor {
  //        return
  //    }
  
}

// builder class
public class CognitiveToyBoxObjectBuilder {
  private var _id : Int = -1
  private var _name : String = ""
  private var _filename : String = ""
  
  public var id: Int {
  get {
    return _id
  }
  set {
    _id = newValue
  }
  }
  
  public var name: String {
  get {
    return _name
  }
  set {
    _name = newValue
  }
  }
  
  public var filename: String {
    get {
      return _filename
    }
    set {
      _filename = newValue
    }
  }


  
  
  public init () {}
  
  public func build () -> CognitiveToyBoxObject {
    
    var object = CognitiveToyBoxObject()
    object._id = id
    object._name = name
    object._filename = filename
    return object
  }
  
  public func buildFromNSManagedObject (nsmObject:NSManagedObject) -> CognitiveToyBoxObject {
    self.id = nsmObject.valueForKey("id") as! Int
    self.name = nsmObject.valueForKey("name") as! String
    self.filename = nsmObject.valueForKey("filename") as! String

    
    return self.build()
  }
  
  
}