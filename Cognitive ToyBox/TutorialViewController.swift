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

  func presentTutorialScene (round:Int) {
    
    GlobalConfiguration.releaseScene(skView.scene)
    let scene = TutorialScene(size: skView.bounds.size)
    scene.scaleMode = .ResizeFill
    
    // configure initial scene
      scene.tutorialViewController = self
    
    
    
    var object = CognitiveToyBoxObjectBuilder()
    
    object.name = "dog"
    object.filename = "shutterstock_121287229"
    scene.objectList.append(object.build())
    
    object.name = "ball"
    object.filename = "shutterstock_107204279"
    scene.objectList.append(object.build())
    
    object.name = "bird"
    object.filename = "shutterstock_128779304"
    scene.objectList.append(object.build())
    
    object.name = "dress"
    object.filename = "shutterstock_133206035"
    scene.objectList.append(object.build())
    
      
      
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
