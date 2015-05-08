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
      return ["apple", "ball", "balloon", "bottle", "bowl", "bucket", "chair", "fork", "guitar", "hammer", "hat", "spoon", "mug", "kettle", "horn", "paddle", "plate", "pot", "rudder", "trophy", "table", "dax", "ibb", "lug", "pux", "veet", "wif", "yen", "zup"]
    }
  }
  
  public class var stage1Objects: [String] {
    get {
      return ["apple", "bottle", "ball", "balloon", "bowl", "bucket", "chair", "guitar", "hat", "spoon", "mug"]
    }
  }
  
  public class var stage2Objects: [String] {
    get {
      return ["kettle", "horn", "paddle", "plate", "rudder", "trophy", "table"]
    }
  }
  
  public class var stage3Objects: [String] {
    get {
      return ["dax", "ibb", "lug", "pux", "veet", "wif", "yen", "zup"]
    }
  }
  
  public class var tutorialObjects: [String] {
    get {
      return ["t_apple", "t_bowl", "t_bucket", "t_dax", "t_fork", "t_guitar", "t_hammer", "t_horn", "t_ibb", "t_kettle", "t_mug", "t_paddle", "t_pot", "t_pux", "t_rudder", "t_spoon", "t_trophy", "t_veet", "t_wif", "t_yen", "t_zup"]
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
  private var _material : String? = nil
  private var _color : String? = nil
  private var _suffix: String? = nil
  
  /* getters, no setters */
  public var id : Int { get { return _id } }
  public var name : String { get { return _name } }
  public var material : String? { get { return _material } }
  public var color : String? { get { return _color } }
  public var suffix: String? { get { return _suffix }}
  
  /* auxiliary dictionary recording suffix of suplementary files */
//  private let auxSuffix: [String: [String]] = [
//    "apple_x_green": ["_leaf"],
//    "apple_x_orange": ["_bite_leaf", "_bite", "_leaf"],
//    "apple_x_red": ["_leaf"],
//    "apple_x_yellow": ["_leaf"]
//  ]
  
  override public var description : String {
  get {
    var str = "\(self.name)_\(self.material == nil ? CognitiveToyBoxObject.unknownMaterial : self.material!)_\(self.color == nil ? CognitiveToyBoxObject.unknownColor : self.color!)"
    return str
  }
  }
  
  public func equals (theOtherObject:CognitiveToyBoxObject?) -> Bool {
    if let object = theOtherObject {
      return self.id == object.id && self.name == object.name && self.material == object.material && self.color == object.color && self.suffix == object.suffix
    }
    return false
  }
  
  public var glowName: String {
    get {
      if name == "mug" {
        if material == "copper" || material == "steel" {
          return "glow_\(name)_metal"
        }
      }
      
      if name == "spoon" {
        if material == "ceramic" || material == "wood" {
          return "glow_\(name)_\(material!)"
        }
      }
      
      return "glow_\(name)"
    }
  }
  
  public var glowName2: String {
    get {
      let glowName = self.glowName
      let index = advance(glowName.startIndex, 5)
      let head = glowName.substringToIndex(index) // glow_
      let tail = glowName.substringFromIndex(index) // the rest
      return "\(head)2_\(tail)"
    }
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
    
    return name + "s"
  }
  
  public var playtimeImageFileName: String {
    get {
//      if let suffixArray = auxSuffix[self.description] {
//        let suffix = suffixArray[Int(arc4random_uniform(UInt32(suffixArray.count)))]
//        return self.description + suffix
//      }
//      
//      return self.description
      
      if let suffix = self.suffix {
        return self.description + suffix
      }
      
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
  private var _material : String? = nil
  private var _color : String? = nil
  private var _suffix: String? = nil
  
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
  
  public var material: String? {
  get {
    return _material
  }
  set {
    _material = newValue
  }
  }
  
  public var color: String? {
  get {
    return _color
  }
  set {
    _color = newValue
  }
  }
  
  public var suffix: String? {
    get {
      return _suffix
    }
    set {
      _suffix = newValue
    }
  }
  
  public init () {}
  
  public func build () -> CognitiveToyBoxObject {
    self.prepare()
    var object = CognitiveToyBoxObject()
    object._id = id
    object._name = name
    object._material = material
    object._color = color
    object._suffix = suffix
    return object
  }
  
  public func buildFromNSManagedObject (nsmObject:NSManagedObject) -> CognitiveToyBoxObject {
    self.id = nsmObject.valueForKey("id") as! Int
    self.name = nsmObject.valueForKey("name") as! String
    self.material = nsmObject.valueForKey("material") as? String
    self.color = nsmObject.valueForKey("color") as? String
    self.suffix = nsmObject.valueForKey("suffix") as? String
    
    return self.build()
  }
  
  // convert material and color to consistent format
  private func prepare () {
    self.material = self.material == CognitiveToyBoxObject.unknownMaterial ? nil : self.material
    self.color = self.color == CognitiveToyBoxObject.unknownColor ? nil : self.color
    
  }
  
}