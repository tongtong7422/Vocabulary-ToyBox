//
//  WelcomeScene.swift
//  Cognitive ToyBox
//
//  Created by Heng Lyu on 7/18/14.
//  Copyright (c) 2014 Cognitive ToyBox. All rights reserved.
//

import SpriteKit


/* displayMain -> transitionMain -> displayOptions -> objectFound -> timeToPlay -> transitionToReviewScene */
class WelcomeScene: SKScene, ConfigurableScene {
  
  var background : SKSpriteNode! = nil
  var bear : SKSpriteNode! = nil
  var bearHelmet : SKSpriteNode! = nil
  
  weak var gameViewController: GameViewController? = nil
  
  
  private var bearHidden = false
  
  override init() {
    super.init()
    GlobalConfiguration.addScene(self)
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    GlobalConfiguration.addScene(self)
  }
  override init(size: CGSize) {
    super.init(size: size)
    GlobalConfiguration.addScene(self)
  }
  deinit {
    NSLog("Deinit WelcomeScene")
  }
  
  override func didMoveToView(view: SKView) {
    
    ActionHelper.loadBearAtlas()
    
    self.runAction(SoundSourceHelper.soundBlop())
    SoundSourceHelper.stopBGM()
    
    GlobalConfiguration.passOneSession()
    
    self.initScene()
    
    
    // show scene
    // ActionHelper returns an SKAction object
//    self.runAction(ActionHelper.displayMain(), completion: self.displayMain)
    // displayOptions runs after displayMain finishes
    
    if bearHidden {
      self.transitionToGameScene(view)
      return
    }
    
    bear.runAction(ActionHelper.bearWaving()) {
      [unowned self] () -> () in
      self.transitionToGameScene()
    }
    
    if GlobalConfiguration.backgroundImageName == BackgroundImageNames.Space {
      var helmetAtlas = SKTextureAtlas(named: "bear_waving_helmet")
      helmetAtlas.preloadWithCompletionHandler({})
      bearHelmet = SKSpriteNode(texture: helmetAtlas.textureNamed(helmetAtlas.textureNames.first!))
      bearHelmet.runAction(ActionHelper.bearWavingHelmet())
      self.bear.addChild(bearHelmet)
    }
    
  }

  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    super.touchesEnded(touches, withEvent: event)
    
    var location : CGPoint
    var node : SKNode
    
    touchLoop: for touch : AnyObject in touches {
      location = (touch as! UITouch).locationInNode(self)
      
      node = self.nodeAtPoint(location)
      
      if node === self.bear {
        if self.bearHelmet != nil {
          self.bearHelmet.removeFromParent()
        }
        bear.runAction(ActionHelper.getPlaytimeRandomAction()) {
          [unowned self] in
          self.transitionToGameScene()
        }
      }
      
    }
    
    
    
  }
  
  
  func hideBear(hidden: Bool) {
    bearHidden = hidden
    
//    if bearHidden && self.view != nil {
//      transitionToGameScene ()
//    }
  }
  
  /* initialize bear */
  func initScene () {
    
    //    self.backgroundColor = UIColor(white: CGFloat(1), alpha: CGFloat(1))
//    self.background = SKSpriteNode(imageNamed: GlobalConfiguration.backgroundImageName.toRaw())
    self.background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
//    self.background.xScale = scale
//    self.background.yScale = scale
    
//    var bearAtlas = ActionHelper.bearWavingAtlas
//    var bearTexture = bearAtlas.textureNamed(bearAtlas.textureNames[0] as String)
//    self.bear = SKSpriteNode(texture: bearTexture)
    self.bear = SKSpriteNode()
    self.bear.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 50)
    
    self.background.zPosition = GameViewController.Layers.Bottom.rawValue
    self.bear.zPosition = GameViewController.Layers.BearBody.rawValue
    
    self.addChild(self.background)
    self.addChild(self.bear)
    
  }
  
  func transitionToGameScene (view:SKView! = nil) {
    ActionHelper.clearFrameCache()
    self.gameViewController?.presentGameScene()
  }
}
