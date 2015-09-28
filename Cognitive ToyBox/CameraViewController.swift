//
//  CameraViewController.swift
//  Cognitive ToyBox
//
//  Created by Heng Lyu on 3/3/15.
//  Copyright (c) 2015 Cognitive ToyBox. All rights reserved.
//

import UIKit

class CameraViewController: UIImagePickerController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
  var userViewController:UserViewController! = nil
  
  deinit {
    NSLog("Deinit CameraViewController")
  }
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
//    var originalImage = editingInfo["UIImagePickerControllerOriginalImage"] as! UIImage
    let newSize = userViewController.cameraButton.frame.size
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
    image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
    let clippedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
//    let shortEdge = min(image.size.width, image.size.height)
    //    let mask = CGImageMaskCreate(shortEdge, shortEdge, <#bitsPerComponent: UInt#>, <#bitsPerPixel: UInt#>, <#bytesPerRow: UInt#>, <#provider: CGDataProvider!#>, nil, false)
    //    image = UIImage(CGImage: CGImageCreateWithMask(image.CGImage, mask))
    userViewController.cameraButton.imageView?.image = clippedImage
    userViewController.userIcon = clippedImage
    //    userViewController.cameraButton.imageView?.layer.cornerRadius = userViewController.cameraButton.frame.size.height/2
    picker.dismissViewControllerAnimated(true) {}

    
  }
  
//  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
//    var originalImage = info["UIImagePickerControllerOriginalImage"] as! UIImage
//    
//    /* resize image */
////    var image = UIImage(CGImage: originalImage.CGImage, scale: userViewController.cameraButton.frame.size.width / originalImage.size.width, orientation: originalImage.imageOrientation)!
//    let newSize = userViewController.cameraButton.frame.size
//    UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
//    originalImage.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
//    var image = UIGraphicsGetImageFromCurrentImageContext()
//    UIGraphicsEndImageContext()
//  
//    
//    let shortEdge = min(image.size.width, image.size.height)
////    let mask = CGImageMaskCreate(shortEdge, shortEdge, <#bitsPerComponent: UInt#>, <#bitsPerPixel: UInt#>, <#bytesPerRow: UInt#>, <#provider: CGDataProvider!#>, nil, false)
////    image = UIImage(CGImage: CGImageCreateWithMask(image.CGImage, mask))
//    userViewController.cameraButton.imageView?.image = image
//    userViewController.userIcon = image
////    userViewController.cameraButton.imageView?.layer.cornerRadius = userViewController.cameraButton.frame.size.height/2
//    picker.dismissViewControllerAnimated(true) {}
//  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    picker.dismissViewControllerAnimated(true) {}
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    self.delegate = self
    self.sourceType = UIImagePickerControllerSourceType.Camera
    
//    var circle = CAShapeLayer()
//    let circularPath = UIBezierPath(roundedRect: self.view.frame, cornerRadius: min(self.view.frame.size.width, self.view.frame.size.height))
//    circle.path = circularPath.CGPath
//    circle.fillColor = UIColor.blackColor().CGColor
//    circle.strokeColor = UIColor.blackColor().CGColor
//    circle.lineWidth = 0
//    self.view.layer.mask = circle
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  
}
