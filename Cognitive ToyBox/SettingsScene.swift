//
//  SettingsScene.swift
//  Cognitive ToyBox
//
//  Created by Heng Lyu on 8/5/14.
//  Copyright (c) 2014 Cognitive ToyBox. All rights reserved.
//

import UIKit
import SpriteKit

class SettingsScene: SKScene, ConfigurableScene {
  
  
  var background : SKSpriteNode! = nil
  var backLabel: SKNode! = nil
  
  private var mainPanel: SKSpriteNode! = nil
  private var navigationPanelHeight: CGFloat = 100
  
//  private var navigationPanel: NavigationPanel! = nil
//  var backgroundTab: SKNode! = nil
//  var taskTab: SKNode! = nil  // not supported yet
//  var actionTab: SKNode! = nil
//  var soundTab: SKNode! = nil
//  var analysisTab: SKNode! = nil
  
  var backgroundSettingsContainer: SKSpriteNode! = nil
  var backgroundIndices = [BackgroundImageNames : Int]()
  var destX = [BackgroundImageNames : CGFloat]()
  let gapSize: CGFloat = 50
  let displaySize = CGSizeMake(640, 480)
  
  override init() {
    super.init()
    GlobalConfiguration.addScene(self)
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    GlobalConfiguration.addScene(self)
  }
  /* initializer used by other initializers */
  override init(size: CGSize) {
    super.init(size: size)
    GlobalConfiguration.addScene(self)
  }
  deinit {
    NSLog("Deinit SettingsScene")
  }
  
  override func didMoveToView(view: SKView) {
    self.backgroundColor = UIColor.whiteColor()
//    self.background = SKSpriteNode(imageNamed: GlobalConfiguration.backgroundImageName.toRaw())
    self.background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
    self.background.zPosition = GameViewController.Layers.Top.rawValue
    self.background.alpha = 0
    self.addChild(background)
    
    initMainPanel()
    
//    initNavigationPanel()
    
    
    /* white mask */
    var whiteMask = SKSpriteNode(color: UIColor.whiteColor(), size: self.frame.size)
    whiteMask.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
    whiteMask.zPosition = self.mainPanel.zPosition + 1
    self.addChild(whiteMask)
  }
  
  func initMainPanel () {
    mainPanel = SKSpriteNode(color: UIColor.clearColor(), size: CGSize(width: self.frame.width, height: self.frame.height - navigationPanelHeight))
    mainPanel.position = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame))
    mainPanel.anchorPoint = CGPointMake(0, 0)
    self.addChild(mainPanel)
    
    initBackgroundSettingsContainer()
  }
  
  /* a panel containing tabs to various setting options */
//  func initNavigationPanel () {
//    navigationPanel = NavigationPanel(color: UIColor.clearColor(), size: CGSize(width: self.frame.width, height: navigationPanelHeight))
//    navigationPanel.anchorPoint = CGPointMake(0, 1) // left top
//    navigationPanel.position = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMaxY(self.frame))
//    
//    backLabel = navigationPanel.createTab(name: "<<Back")
//    
//    backgroundTab = navigationPanel.createTab(name: "Background")
////    taskTab = navigationPanel.createTab(name: "Task")
//    actionTab = navigationPanel.createTab(name: "Action")
//    soundTab = navigationPanel.createTab(name: "Sound")
//    analysisTab = navigationPanel.createTab(name: "Analysis")
//    
//    self.addChild(navigationPanel)
//    
//    
//  }
//  
  /* a wide container contains all background images with certain gap */
  func initBackgroundSettingsContainer () {
    
    backgroundSettingsContainer = SKSpriteNode(color: UIColor.clearColor(), size: CGSize(width: self.frame.width + (gapSize + displaySize.width) * CGFloat(BackgroundImageNames.allValues.count), height: self.displaySize.height))
    backgroundSettingsContainer.anchorPoint = CGPointMake(0, 0.5)
    backgroundSettingsContainer.position = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMidY(self.frame))
    self.mainPanel.addChild(backgroundSettingsContainer)
    
    for i in 0..<BackgroundImageNames.allValues.count {
      var bg = BackgroundImageNames.allValues[i]
      backgroundIndices[bg] = i
      destX[bg] = CGRectGetMinX(view!.bounds) - (gapSize + displaySize.width) * CGFloat(i)
      
      var backgroundImage: SKSpriteNode
      
      if bg == .White {
        backgroundImage = SKSpriteNode(color: UIColor.whiteColor(), size: displaySize)
      } else {
        backgroundImage = SKSpriteNode(texture: SKTexture(imageNamed: bg.rawValue), size: displaySize)
      }
      
      var glow = SKShapeNode()
      glow.path = UIBezierPath(roundedRect: CGRect(origin: CGPointMake(-displaySize.width/2, -displaySize.height/2), size: displaySize), cornerRadius: 1).CGPath
      
      glow.glowWidth = 4
      
      glow.strokeColor = UIColor.yellowColor()
      
      glow.position = CGPointMake(0.5*view!.bounds.width + (gapSize + displaySize.width)*CGFloat(i), 0)
      
      
      glow.addChild(backgroundImage)
      backgroundSettingsContainer.addChild(glow)
    }
    
    backgroundSwitchTo(GlobalConfiguration.backgroundImageName, duration: 0)
  }
  
  func backgroundSwitchTo(backgroundImageName: BackgroundImageNames?, duration: NSTimeInterval = 0.3) {
    
    
    if backgroundImageName == nil {
      backgroundSettingsContainer.runAction(SKAction.moveToX(
        destX[GlobalConfiguration.backgroundImageName]!,
        duration: duration))
      return
    }
    
    backgroundSettingsContainer.runAction(SKAction.moveToX(
      destX[backgroundImageName!]!,
      duration: duration))
    GlobalConfiguration.backgroundImageName = backgroundImageName
    GlobalConfiguration.restartSessionsCount()
  }
//
//  override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
//    
//    /* play touch sound */
//    //        self.runAction(SKAction.playSoundFileNamed(<#soundFile: String?#>, waitForCompletion: false))
//    
//    var touch = touches.anyObject() as UITouch
//    switch nodeAtPoint(touch.locationInNode(self)) {
//    case backLabel:
//      let scene = StartScene(size: self.size)
//      
//      let skView = self.view as SKView
//      skView.ignoresSiblingOrder = true
//      scene.scaleMode = .ResizeFill
//      skView.presentScene(scene)
//      
//      GlobalConfiguration.removeScene(self)
//      self.removeFromParent()
//      
////    case analysisTab:
//      
//      
//    default:
//      return
//    }
//    
//  }
  
}


//private class NavigationPanel: SKSpriteNode {
//  var tabs = [SKNode]()
//  private var gap: CGFloat = 30
//  
//  func createTab (#name: String) -> SKNode {
//    var newTab: SKLabelNode = SKLabelNode(fontNamed: GlobalConfiguration.labelFont)
//    newTab.text = name;
//    newTab.fontSize = 24;
//    newTab.fontColor = UIColor(white: CGFloat(0), alpha: CGFloat(1))
//    
//    /* anchor: right center */
//    newTab.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
//    newTab.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
//    newTab.position = CGPoint(x: (tabs.count==0 ? 0 : tabs[tabs.count-1].position.x) + gap + newTab.frame.width, y: -self.frame.height/2);
//    
//    tabs.append(newTab)
//    self.addChild(newTab)
//    return newTab
//  }
//}