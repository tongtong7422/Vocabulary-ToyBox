//
//  ImageSourceHelper.swift
//  Cognitive ToyBox
//
//  Created by Heng Lyu on 6/20/14.
//  Copyright (c) 2014 Cognitive ToyBox. All rights reserved.
//

//import Foundation
import UIKit
import SpriteKit

/*

ImageSourceHelper requests image source and returns an array of CognitiveToyBoxObject containing info of all images in that source (a directory either local or remote). All functions are static.

*/
public class ImageSourceHelper {
  
  public class var imageExtension: String {
    get {
      return "png"
    }
  }
  
  /* get objects from images in local directory */
  public class func getObjFromDir (isTutorial:Bool = false) -> [CognitiveToyBoxObject] {
//    let objPaths = self.listFilesWithExt(ext: imageExtension) as String[]
    var objFileName:String
    var objects:[CognitiveToyBoxObject] = [CognitiveToyBoxObject]()
    
//    let textureAtlas = SKTextureAtlas(named: "Objects")
//    let atlasList = textureAtlas.textureNames as NSArray
    
    var atlasList : NSMutableArray = []
    var allObjects:[String]
    if isTutorial {
      allObjects = CognitiveToyBoxObject.tutorialObjects
    } else {
      allObjects = CognitiveToyBoxObject.allObjects
    }
    for name in allObjects {
      var textureNames = SKTextureAtlas(named: name).textureNames
      
      /* get each texture once */
      atlasList.addObjectsFromArray(textureNames.filter()
        { (textureName) -> Bool in
          return (textureName as! String).stringByDeletingPathExtension.hasSuffix("@2x")
        }
      )
    }
    
    var components : [String]
    var name : String
    var material : String
    var color : String
    var suffix: String?
    
    var builder = CognitiveToyBoxObjectBuilder()
    
    for count in 0..<atlasList.count {
      
      objFileName = ImageSourceHelper.getFileName(path: atlasList[count] as! String)
      if !objectFileMatch(objFileName) {
        continue
      }
    
      components = objFileName.componentsSeparatedByString("_")
      
      
      name = components[0]
      material = components[1]
      color = components[2]
      suffix = nil
      
      if components.count > 3 {
        suffix = ""
        for i in 3..<components.count {
          suffix! += "_\(components[i])"
        }
      }
      
      
      builder.id = count
      builder.name = name
      builder.material = material
      builder.color = color
      builder.suffix = suffix
      
      
      
      objects.append(builder.build())
      
//      objects.append(CognitiveToyBoxObject(name: name, material: material, color: color))
    }
    
    return objects
    
  }
  
//  class func listObjectFiles () -> NSArray {
//    
//  }
  
  //    class func getObjFromURL (dirPath:NSURL) -> CognitiveToyBoxObject[] {
  //
  //    }
  
  /* list all files in the path */
  public class func listFileAtPath (#path:NSString) -> NSArray {
//    NSLog("LISTING ALL FILES FOUND")
    
    var count = 0
    var error:NSErrorPointer = nil
    
    let directoryContent:NSArray = NSFileManager.defaultManager().contentsOfDirectoryAtPath(path as String, error: error)!
    
    if error != nil {
//      
//      for count in 0..directoryContent.count {
//        NSLog("File \(count+1): \(directoryContent[count])")
//      }
      
    }
    else {
      /* exception handling */
    }
    
    return directoryContent;
  }
  
  /* list all files in the resource with ext=ext */
  public class func listFilesWithImageExt () -> NSArray {
    return listFilesWithExt(ext: self.imageExtension)
  }
  
  public class func listFilesWithExt (#ext:String) -> NSArray {
//    NSLog("LISTING ALL \(ext) FILES")
    
    let resPath = NSBundle.mainBundle().resourcePath
    var directoryContent = NSBundle.pathsForResourcesOfType(ext, inDirectory: resPath!)
    
    var count = 0
    var error:NSErrorPointer = nil
    
    if error != nil {
      
//      for count in 0..directoryContent.count {
//        NSLog("File \(count+1): \(directoryContent[count])")
//      }
      
    }
    else {
      /* exception handling */
    }
    
    return directoryContent;
  }
  
  /* remove directory and extension from a path */
  public class func getFileName (#path:String) -> String {
    var fileName = path.stringByDeletingPathExtension.lastPathComponent
    var components = fileName.componentsSeparatedByString("@")
    return components[0]
  }
  
  /* match image files (without ext) */
  public class func objectFileMatch (fileName : String) -> Bool {
    let pattern = "^(?!glow)[a-zA-Z]+_[a-zA-Z]+_[a-zA-Z]+(_[a-zA-Z]+)*$"
    var regex = NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive, error: nil)!
    var matches = regex.matchesInString(fileName, options: nil, range: NSMakeRange(0, count(fileName)))
    return !(matches.isEmpty)
  }
  
  
  
}