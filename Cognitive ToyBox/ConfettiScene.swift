//
//  ConfettiScene.swift
//  Blicket
//
//  Created by Heng Lyu on 6/11/15.
//  Copyright (c) 2015 Cognitive ToyBox. All rights reserved.
//

import UIKit
import SpriteKit

class ConfettiScene: SKScene {
  
  deinit {
    NSLog("Deinit ConfettiScene")
  }
  
  override func didMoveToView(view: SKView) {
    let background = SKSpriteNode(imageNamed: "rewardBackground")
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
    self.addChild(background)
    
    let confettiString = "confetti_000"
    var textures:[SKTexture] = []
    
    for i in 10...23 {
      textures.append(SKTexture(imageNamed: confettiString + String(i)))
    }
    
    let confetti = SKSpriteNode(texture: textures.first!)
//    confetti.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
    
    var animation = SKAction.animateWithTextures(textures, timePerFrame: 1/15)
    var fade = SKAction.fadeAlphaTo(0, duration: 1)
    var wait = SKAction.waitForDuration(2)
    var show = SKAction.fadeAlphaTo(1, duration: 0)
    
    background.addChild(confetti)
    confetti.runAction(SKAction.repeatActionForever(SKAction.sequence([animation, fade, wait, show])))
  }
   
}
