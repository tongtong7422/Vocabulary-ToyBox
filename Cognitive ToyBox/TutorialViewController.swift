//
//  TutorialViewController.swift
//  Vocabulary Assessment Tool
//
//  Created by Tongtong Wu on 9/15/15.
//  Copyright (c) 2015 Cognitive ToyBox. All rights reserved.
//

import UIKit
import SpriteKit

class TutorialViewController: UIViewController {
  @IBOutlet var skView: SKView!
  @IBOutlet weak var questionNumLabel: UILabel!
  var isFinished = false
  
  override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    override func viewWillLayoutSubviews() {
    if skView.scene == nil {
      presentTutorialScene(0)
      //    displayStartScene()
    }
    }
  override func viewWillAppear(animated: Bool) {
    if isFinished {
      self.dismissViewControllerAnimated(false) {}
      
    }
  }

  func presentTutorialScene (round:Int) {
    
    GlobalConfiguration.releaseScene(skView.scene)
    let scene = TutorialScene(size: skView.bounds.size)
    scene.scaleMode = .ResizeFill
    
    // configure initial scene
      scene.tutorialViewController = self
    
    
    
    let object = CognitiveToyBoxObjectBuilder()
    
    object.name = "cat"
    object.filename = "shutterstock_183082052"
    scene.objectList.append(object.build())
    
    object.name = "keys"
    object.filename = "shutterstock_7039687"
    scene.objectList.append(object.build())
    
    object.name = "ball"
    object.filename = "shutterstock_195844679"
    scene.objectList.append(object.build())
    
    object.name = "boat"
    object.filename = "shutterstock_205889836"
    scene.objectList.append(object.build())
    
    
    
    // second round
    object.name = "airplane"
    object.filename = "shutterstock_93645625"
    scene.objectListSecond.append(object.build())
    
    object.name = "dog"
    object.filename = "shutterstock_104236235"
    scene.objectListSecond.append(object.build())
    
    object.name = "bird"
    object.filename = "shutterstock_212438875"
    scene.objectListSecond.append(object.build())
    
    object.name = "ball"
    object.filename = "shutterstock_170247413"
    scene.objectListSecond.append(object.build())
    
      
    skView.presentScene(scene)
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
