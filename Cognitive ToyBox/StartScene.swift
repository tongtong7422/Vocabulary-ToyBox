//
//  StartScene.swift
//  Cognitive ToyBox
//
//  Created by Heng Lyu on 6/27/14.
//  Copyright (c) 2014 Cognitive ToyBox. All rights reserved.

import SpriteKit

class StartScene: SKScene {
  
  weak var gameViewController: GameViewController? = nil
  
  var background : SKSpriteNode! = nil
  var settingsLabel = SKLabelNode(fontNamed: GlobalConfiguration.labelFont)
  
//  var startButton: SKSpriteNode! = nil
//  var startAtlas = SKTextureAtlas(named: "start_button")
//  var parentsButton: SKSpriteNode! = nil
//  var parentsAtlas = SKTextureAtlas(named: "parents_button")
  
//  var newUserIcon : SKSpriteNode = SKSpriteNode(imageNamed: "newUserIcon")
  
  var touchedButton: SKSpriteNode? = nil
  var touchedAtlas: SKTextureAtlas? = nil
  
  deinit {
    NSLog("Deinit StartScene")
  }
  
  override func didMoveToView(view: SKView) {
    /* Setup your scene here */
    self.background = SKSpriteNode(imageNamed: "StartBackground")
    self.background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
    self.background.zPosition = GameViewController.Layers.Bottom.rawValue
    self.addChild(self.background)
    
//    self.newUserIcon.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)/2)
//    self.addChild(self.newUserIcon)
    
    
//    startButton = SKSpriteNode(texture: startAtlas.textureNamed("button"))
//    startButton.anchorPoint = CGPointMake(0.4, 1)
//    startButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - self.frame.height/4)
//    self.addChild(startButton)
    
//    parentsButton = SKSpriteNode(texture: parentsAtlas.textureNamed("button"))
//    parentsButton.anchorPoint = CGPointMake(0, 1)
//    parentsButton.position = CGPointMake(CGRectGetMinX(self.frame) + 20, CGRectGetMaxY(self.frame) - 20)
//    self.addChild(parentsButton)
    
    SoundSourceHelper.playInitialSong()
    
    
    // test node
//    var path = DrawingHelper.trialPath()
//    var testNode = SKShapeNode()
//    testNode.path = path.CGPath
//    testNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
//    self.addChild(testNode)
  }
  
  func transitionToGameScene () {
    let scene = WelcomeScene(size: self.size)
    let skView = self.view! as SKView
    scene.scaleMode = .ResizeFill
    
    
    
    skView.presentScene(scene)
    self.gameViewController?.homeButton.hidden = false
    GlobalConfiguration.releaseScene(self)
  }
  
//  override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
//    
//    /* play touch sound */
//    //        self.runAction(SKAction.playSoundFileNamed(<#soundFile: String?#>, waitForCompletion: false))
//    
//    if touchedButton == nil {
//      return
//    }
//    
//    touchedButton = nil
//    touchedAtlas = nil
//    
//    var touch = touches.anyObject() as UITouch
////    var scene: SKScene
//    if nodeAtPoint(touch.locationInNode(self)) == parentsButton {
//      self.gameViewController.performSegueWithIdentifier("settingsModal", sender: parentsButton)
//      parentsButton.texture = parentsAtlas.textureNamed("button")
//    } else if nodeAtPoint(touch.locationInNode(self)) == startButton{
//      startButton.texture = startAtlas.textureNamed("button")
//      
//      if true { //UserInfoHelper.getUserInfo() == nil {
//        self.gameViewController.performSegueWithIdentifier("userSignUpSegue", sender: startButton)
//        return
//      }
//      
//      transitionToGameScene()
//      
//    } else {
//      return
//    }
//  
//    
//    
//    
//  }
  
//  override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
//    var touch = touches.anyObject() as UITouch
//    
//    touchedButton = nodeAtPoint(touch.locationInNode(self)) as? SKSpriteNode
//    if touchedButton != nil {
//      switch touchedButton! {
//      case startButton:
//        touchedAtlas = startAtlas
//      case parentsButton:
//        touchedAtlas = parentsAtlas
//        
//      default:
//        touchedButton = nil
//        return
//      }
//      
//      touchedButton!.texture = touchedAtlas!.textureNamed("pressed")
//    }
//  }
//  
//  override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
//    
//    if touchedButton == nil {
//      return
//    }
//    
//    var touch = touches.anyObject() as UITouch
//    var textureName: String
//    
//    
//    if touchedButton != nodeAtPoint(touch.locationInNode(self)) {
//      textureName = "button"
//    } else {
//      textureName = "pressed"
//    }
//    
//    touchedButton!.texture = touchedAtlas!.textureNamed(textureName)
//  }
  
  override func update(currentTime: CFTimeInterval) {
    /* Called before each frame is rendered */
  }
}
