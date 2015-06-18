//
//  QuitScene.swift
//  Cognitive ToyBox
//
//  Created by Heng Lyu on 2/20/15.
//  Copyright (c) 2015 Cognitive ToyBox. All rights reserved.
//

import UIKit
import SpriteKit

class QuitScene: SKScene {
  
  deinit {
    NSLog("Deinit QuitScene")
  }
  
  override func didMoveToView(view: SKView) {
    let background = SKSpriteNode(imageNamed: "rewardBackground")
    background.position = CGPointMake(CGRectGetMidX(view.bounds), CGRectGetMidY(view.bounds))
    self.addChild(background)
  }
   
}
