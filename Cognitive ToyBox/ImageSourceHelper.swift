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
      return "jpg"
    }
  }
  
  /* get objects from images in local directory */
  public class func getObjFromDir (isTutorial:Bool = false) -> [CognitiveToyBoxObject] {
//    let objPaths = self.listFilesWithExt(ext: imageExtension) as String[]
    var objFileName:String
    var objects:[CognitiveToyBoxObject] = []
    
//    let textureAtlas = SKTextureAtlas(named: "Objects")
//    let atlasList = textureAtlas.textureNames as NSArray
    
    var atlasList : NSMutableArray = []
    var allObjects:[String]
    if isTutorial {
      allObjects = CognitiveToyBoxObject.tutorialObjects
    } else {
      allObjects = CognitiveToyBoxObject.allObjects
    }
    
     var count : Int = 0
    for name in allObjects {
      let textureNames = SKTextureAtlas(named: name).textureNames
      
      /* get each texture once */
//      atlasList.addObjectsFromArray(textureNames.filter()
//        { (textureName) -> Bool in
//          return (textureName as! String).stringByDeletingPathExtension.hasSuffix("@2x")
//        }
//      )
      
        
        for textureName in textureNames{
          //textureName = "ABALL@2x.jpg"
//          let newPath = NSURL(fileURLWithPath: textureName)
//          let fileName = newPath.URLByDeletingPathExtension?.

          
            var fileName :String
            let builder = CognitiveToyBoxObjectBuilder()
            
            builder.id = count++
            builder.name = name
            builder.filename = textureName
            objects.append(builder.build())
            
                      
          
//            if textureName.stringByDeletingPathExtension.hasSuffix("@2x"){
//                
//                var fileName :String
//                var builder = CognitiveToyBoxObjectBuilder()
//                
//                builder.id = count++
//                builder.name = name
//                builder.filename = textureName
//                objects.append(builder.build())
//              
//                
//            }
        }

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
  public class func listFileAtPath (path path:NSString) -> NSArray {
    //    NSLog("LISTING ALL FILES FOUND")
    
    var count = 0
    //    var error:NSErrorPointer = nil
    let directoryContent:NSArray
    do {
      directoryContent =  try NSFileManager.defaultManager().contentsOfDirectoryAtPath(path as String)
      return directoryContent;
      
      
    }catch let error as NSError{
      let message  = "imageSourceHelper function listFileAtPath"
      ErrorLogger.logError(error, message:message)
      return NSArray()
    }
    
    //
    //    if error != nil {
    ////
    ////      for count in 0..directoryContent.count {
    ////        NSLog("File \(count+1): \(directoryContent[count])")
    ////      }
    //
    //    }
    //    else {
    //      /* exception handling */
    //    }
    
  }
  
  /* list all files in the resource with ext=ext */
  public class func listFilesWithImageExt () -> NSArray {
    return listFilesWithExt(ext: self.imageExtension)
  }
  
  public class func listFilesWithExt (ext ext:String) -> NSArray {
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
  public class func getFileName (path path:String) -> String {
    let newPath = NSURL(fileURLWithPath: path)
    let fileName = newPath.URLByDeletingPathExtension?.lastPathComponent
    
//    var fileName = path.stringByDeletingPathExtension.lastPathComponent
    var components = fileName!.componentsSeparatedByString("@")
    return components[0]
  }
  
  /* match image files (without ext) */
  public class func objectFileMatch (fileName : String) -> Bool {
//    let pattern = "^(?!glow)[a-zA-Z]+_[a-zA-Z]+_[a-zA-Z]+(_[a-zA-Z]+)*$"
//    var regex = NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive, error: nil)!
//    var matches = regex.matchesInString(fileName, options: nil, range: NSMakeRange(0, count(fileName)))
//    return !(matches.isEmpty)
    return true
  }
  
  
  
}