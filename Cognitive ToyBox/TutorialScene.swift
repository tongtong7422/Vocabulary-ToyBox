//
//  GameScene.swift
//  Cognitive ToyBox
//
//  Created by Heng Lyu on 6/19/14.
//  Copyright (c) 2014 Cognitive ToyBox. All rights reserved.
//

import SpriteKit

/* display the main game logic */
class TutorialScene: SKScene {
  
  let versionNum = UIDevice.currentDevice().systemVersion.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "."))[0].toInt()
  
  let atlasPrefix = "t_"
  
  //  let objectAtlas = ActionHelper.objectAtlas
  //  let glowAtlas = ActionHelper.glowAtlas
  
  var firstTouch = false
  var labelFontSize = CGFloat(72)
  
  var gameController = GameController()
  weak var userViewController:UserViewController? = nil
  
  var objectName = ""
  
  var background : SKSpriteNode! = nil
  let isBlurred = true
  
  let mainScaleBefore:CGFloat = 2
  let mainScaleAfter:CGFloat = 0.7
  let normalScale:CGFloat = 1
  
  //  var bear : SKSpriteNode! = nil
  //  var bearArms : SKSpriteNode! = nil
  
  let descriptionLabel = SKLabelNode(fontNamed: GlobalConfiguration.labelFont)
  let questionLabel = SKLabelNode(fontNamed: GlobalConfiguration.labelFont)
  let wrongLabel = SKLabelNode(fontNamed: GlobalConfiguration.labelFont)
  let foundLabel = SKLabelNode(fontNamed: GlobalConfiguration.labelFont)
  
  var mainObjectNode: SKSpriteNode! = nil
  
  var firstOptionNode: SKSpriteNode! = nil
  var secondOptionNode: SKSpriteNode! = nil
  var thirdOptionNode: SKSpriteNode! = nil
  var objectList: [CognitiveToyBoxObject] = []
  
  //  var firstOptionGlow: SKSpriteNode! = nil
  //  var secondOptionGlow: SKSpriteNode! = nil
  
  var correctNode : SKSpriteNode! = nil
  var wrongNode : SKSpriteNode! = nil
  
  /* prevent from touching */
  var topMask : SKNode! = nil
  var colorMask : SKNode! = nil
  
  /* frame size and position */
  var initFrame : CGRect! = nil
  var mainFrame : CGRect! = nil
  var optionsFrame : CGRect! = nil
  
  private var optionsDisplayed: Bool = false
  
  /* reminder */
  private var reminder: SKNode = SKNode()
  
  /* wrong time counter */
  private var wrongCounter: Int = 0
  
  /* special treatment for toddlers on touching! */
  var touchedCorrectObject = false
  var touchedWrongObject = false
  
  
  /* track statistics */
//  var statisticsTrack = StatisticsTrackHelper()
  
//  override init() {
//    super.init()
//    GlobalConfiguration.addScene(self)
//  }
//  required init?(coder aDecoder: NSCoder) {
//    super.init(coder: aDecoder)
//    GlobalConfiguration.addScene(self)
//  }
//  override init(size: CGSize) {
//    super.init(size: size)
//    GlobalConfiguration.addScene(self)
//  }
  deinit {
    NSLog("Deinit TutorialScene")
  }
  
  override func didMoveToView(view: SKView) {
    
    self.gameController.unregister()
    self.gameController.mode = .Tutorial
    
    SoundSourceHelper.stopBGM()
    
    //    if let controller = self.gameViewController {
    //      mode = controller.mode
    //    }
    
    
    self.initScene()
    
    self.initLabels()
    
    
    // masks
    if versionNum >= 8 {
      self.topMask = SKShapeNode(rect: self.frame)  // iOS 8 only
      self.colorMask = SKShapeNode(rect: self.frame)
    }
    else {
      self.topMask = SKSpriteNode(color: UIColor(white: 0, alpha: 1), size: self.frame.size)
      self.topMask.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
      
      self.colorMask = SKSpriteNode(color: UIColor(white: 0.5, alpha: 0.5), size: self.frame.size)
      self.colorMask.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
    }
    
    //    self.topMask
    self.topMask.hidden = true
    
    self.resetMask()
    self.colorMask.hidden = true
    
    
    self.addChild(self.topMask)
    
    
    
    
    self.nextSession()
    
    self.initFrame = self.frame
    //    var orientation = UIApplication.sharedApplication().statusBarOrientation
    //
    //    if orientation == UIInterfaceOrientation.Portrait || orientation == UIInterfaceOrientation.PortraitUpsideDown {
    //
    //      let offset = self.frame.height/6
    //
    //      self.mainFrame = CGRectOffset(CGRectInset(self.frame, 0, offset), 0, offset)
    //
    //      self.optionsFrame = CGRectOffset(CGRectInset(self.frame, 0, offset), 0, -offset)
    //
    //    }
    //    else {
    
    let offset = self.frame.height/6
    
    self.mainFrame = CGRectOffset(CGRectInset(self.frame, 0, offset), 0, offset)
    
    if gameController.task == .Vocabulary {
      self.optionsFrame = self.frame
    } else {
      self.optionsFrame = CGRectOffset(CGRectInset(self.frame, 0, offset), 0, -offset)
    }
    //    }
    
    self.initMain()
    self.initOptions()
    
    
    // determine GameViewController.Layers
    self.initLayers()
    
    
    
    
    // show scene
    // ActionHelper returns an SKAction object
    self.runAction(ActionHelper.displayMain()) {  // wait a short time before display main object
      [unowned self] () -> () in
      if self.gameController.task == .Vocabulary {
        self.displayOptions()
        self.emphasizeOptions() {
          [unowned self] () -> () in
          //          self.showGlow()
          self.allowTouching()
        }
      } else {
        self.displayMain()
      }
    }
    // displayOptions runs after displayMain finishes
    
    self.addChild(self.reminder)
  }
  
  
  
  private var toddlerLock:Bool = false
  
  func toddlerTouch () {
    if toddlerLock {
      touchedWrongObject = false
      touchedCorrectObject = false
      return
    }
    
    if !touchedWrongObject && !touchedCorrectObject {
      return
    }
    
    
    
    if touchedWrongObject {
      
      wrongSelection()
      toddlerLock = true
      
    } else if touchedCorrectObject {
      
      
      correctSelection()
    }
    
    touchedWrongObject = false
    touchedCorrectObject = false
    
    
    
  }
  
  private func handleTouch (touches: NSSet!, withEvent event: UIEvent!) {
    /* play touch sound */
    //        self.runAction(SKAction.playSoundFileNamed(<#soundFile: String?#>, waitForCompletion: false))
    
    let allTouches = event.allTouches()! as NSSet
    
    for touch : AnyObject in allTouches {
      var location = (touch as! UITouch).locationInNode(self)
      
      if self.nodeAtPoint(location) == self.correctNode {
        
        touchedCorrectObject = true
        
        // Start toddler special treatment!
        self.runAction(ActionHelper.touchDelay()) {
          [unowned self] () -> () in
          self.toddlerTouch()
        }
        
      } else if self.nodeAtPoint(location) == wrongNode {
        
        // wrong once, wrong at all
        
        touchedWrongObject = true
        
        // Start toddler special treatment!
        self.runAction(ActionHelper.touchDelay()) {
          [unowned self] () -> () in
          self.toddlerTouch()
        }
        
        break
      } else if self.nodeAtPoint(location) == mainObjectNode || (thirdOptionNode != nil && self.nodeAtPoint(location) == thirdOptionNode) {
        self.mainTouched()
        
      }
    }
  }
  
  override func touchesBegan (touches: Set<NSObject>, withEvent event: UIEvent) {
    
    handleTouch(touches, withEvent: event)
    
  }
  
  override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
    handleTouch(touches, withEvent: event)
  }
  
  override func update(currentTime: CFTimeInterval) {
    /* Called before each frame is rendered */
  }
  
  /* refresh GameController */
  func nextSession () {
    
    self.wrongCounter = 0
    
    self.preventTouching()
    self.gameController.startNewSession(updateTaskManager: false)
    self.objectList = self.gameController.getListWithSameName().filter() { [unowned self] (object:CognitiveToyBoxObject) -> Bool in
      !object.equals(self.gameController.getMainObj()) && !object.equals(self.gameController.getCorrectObj()) && object.suffix == nil
    }
    
    // refresh main
    self.objectName = self.gameController.getMainObj().name
    //    let imageFileName = self.gameController.getMainObj().description
    self.descriptionLabel.text = "\(objectName)"
    //    self.descriptionLabel.text = "Look! It's a \(objectName)."
    //    self.mainObjectNode.texture = self.objectAtlas.textureNamed(imageFileName)
    
    // refresh options
    //    let pairs = self.gameController.getObjPair()
    //    let firstImageFileName = pairs.0.description
    //    let secondImageFileName = pairs.1.description
    self.questionLabel.text = "\(objectName)"
    //    self.questionLabel.text = "Can you find the other \(objectName)?"
    //
    //    self.firstOptionNode.texture = self.objectAtlas.textureNamed(firstImageFileName)
    //
    //
    //    self.secondOptionNode.texture = self.objectAtlas.textureNamed(secondImageFileName)
    //
    //
    //
    //    self.firstOptionGlow.texture = self.glowAtlas.textureNamed(pairs.0.glowName)
    //    self.secondOptionGlow.texture = self.glowAtlas.textureNamed(pairs.1.glowName)
    
    
    
    
    self.wrongLabel.text = "That's not a \(objectName)!"
    
    //    self.runAction(ActionHelper.delayNextSession()) {
    //      [unowned self] () -> () in
    //      self.restartScene()
    //    }
    
    
    /* update statisticsTrack */
//    if let userInfo = UserInfoHelper.getUserInfo() {
//      statisticsTrack.validate = true
//      statisticsTrack.setUser(userInfo)
//    }
//    
//    statisticsTrack.setDate(NSDate(timeIntervalSinceNow: 0))
//    statisticsTrack.setTimeStart(NSDate(timeIntervalSinceNow: 0))
//    statisticsTrack.setObject1(self.gameController.mainObject)
//    statisticsTrack.setObject2(self.gameController.firstObject)
//    statisticsTrack.setObject3(self.gameController.secondObject)
//    
//    if gameController.task == .Vocabulary {
//      self.foundLabel.text = "1 \(objectName)!"
//      statisticsTrack.setTaskType("Vocabulary")
//    } else {
//      self.foundLabel.text = "2 \(objectName)s!"
//      statisticsTrack.setTaskType("Shape Bias")
//    }
  }
  
  /* initialize labels */
  func initLabels () {
    self.descriptionLabel.fontSize = self.labelFontSize
    self.descriptionLabel.fontColor = UIColor(white: CGFloat(0), alpha: CGFloat(1))
    
    
    self.questionLabel.fontSize = self.labelFontSize
    self.questionLabel.fontColor = UIColor(white: CGFloat(0), alpha: CGFloat(1))
    
    self.wrongLabel.fontSize = self.labelFontSize
    self.wrongLabel.fontColor = UIColor(white: CGFloat(0), alpha: CGFloat(1))
    self.wrongLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - self.size.height/3)
    self.wrongLabel.alpha = 0
    
    
    self.foundLabel.fontSize = self.labelFontSize
    self.foundLabel.fontColor = UIColor(white: CGFloat(0), alpha: CGFloat(1))
    self.foundLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + self.size.height/3)
    self.foundLabel.hidden = true
    
    self.addChild(self.descriptionLabel)
    self.addChild(self.questionLabel)
    self.addChild(self.foundLabel)
    self.addChild(self.wrongLabel)
  }
  
  /* initialize GameViewController.Layers */
  func initLayers () {
    self.descriptionLabel.zPosition = GameViewController.Layers.Label.rawValue
    self.questionLabel.zPosition = GameViewController.Layers.Label.rawValue
    self.wrongLabel.zPosition = GameViewController.Layers.Label.rawValue
    self.foundLabel.zPosition = GameViewController.Layers.Label.rawValue
    self.colorMask.zPosition = GameViewController.Layers.Mask.rawValue
    self.topMask.zPosition = GameViewController.Layers.Top.rawValue
    self.mainObjectNode.zPosition = GameViewController.Layers.AboveMask.rawValue
    self.firstOptionNode.zPosition = GameViewController.Layers.AboveMask.rawValue
    self.secondOptionNode.zPosition = GameViewController.Layers.AboveMask.rawValue
    //    self.firstOptionGlow.zPosition = GameViewController.Layers.BearArm.rawValue
    //    self.secondOptionGlow.zPosition = GameViewController.Layers.BearArm.rawValue
  }
  
  
  /* initialize main object and label */
  func initMain () {
    
    let imageFileName = self.gameController.getMainObj().description
    let scale = self.mainScaleBefore
    let frame = self.initFrame
    
    // draw label
    
    self.descriptionLabel.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame) + frame.height / 3)
    
    self.mainObjectNode = SKSpriteNode(texture: SKTextureAtlas(named: atlasPrefix+self.gameController.getMainObj().name).textureNamed(imageFileName))
    //    self.mainObjectNode = SKSpriteNode(imageNamed: imageFileName)
    self.mainObjectNode.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame) - 0)
    self.mainObjectNode.xScale = scale
    self.mainObjectNode.yScale = scale
    
    // wait for display
    self.descriptionLabel.hidden = true
  }
  
  /* display main object and label */
  func displayMain () {
    self.descriptionLabel.hidden = false
    
    self.addChild(self.mainObjectNode)
    
    // play sound effect
    let name = self.gameController.getMainObj().name
    //    let soundFile = SoundSourceHelper.soundIdentify(name: name).stringByAppendingPathExtension(SoundSourceHelper.soundExtension)
    //    self.runAction(ActionHelper.playSound(soundFile: soundFile))
    self.runAction(SoundSourceHelper.soundIdentify(name: name))
    //    self.runAction(ActionHelper.waitForMain(), completion: self.translateMain)
    
    self.allowTouching()
    self.mainObjectNode.runAction(ActionHelper.presentObject()) {
      [unowned self] () -> () in
      
      self.mainObjectNode.runAction(ActionHelper.waitForMain()) {
        [unowned self] () -> () in
        self.mainTouched()
      }
    }
    
  }
  
  func mainTouched () {
    //        self.translateMain()
    //    self.preventTouching()
    self.mainObjectNode.removeAllActions()
    self.mainObjectNode.runAction(SKAction.rotateToAngle(0, duration: 0))
    self.descriptionLabel.hidden = true
    //        self.bearGrab()
    if !optionsDisplayed {
      self.preventTouching()
      self.translateMain()
    } else {
      self.emphasizeOptions()
    }
    
    
  }
  
  /* transition main */
  func translateMain () {
    self.descriptionLabel.hidden = true
    
    //    self.mainObjectNode.runAction(ActionHelper.transitionMain(location: CGPointMake(CGRectGetMidX(self.mainFrame)-self.mainFrame.width/4, CGRectGetMidY(self.mainFrame)+self.mainFrame.height/3), scaleBy: 0.5), completion: self.displayOptions)
    self.mainObjectNode.runAction(ActionHelper.transitionMain(location: CGPointMake(CGRectGetMidX(self.mainFrame), CGRectGetMidY(self.mainFrame)), scaleBy: self.mainScaleAfter/self.mainScaleBefore)) {
      [unowned self] () -> () in
      self.displayOptions()
      
    }
    
    //    let positionInBear = CGPointMake(0, -self.bear.size.height/8)
    //    let globalPosition = CGPointMake(self.bear.position.x + positionInBear.x, self.bear.position.y + positionInBear.y)
    //
    //    self.mainObjectNode.runAction(ActionHelper.transitionMain(location: globalPosition, scaleBy: 0.5, duration: 0.4)) {
    //    [unowned self] () -> () in
    //      self.mainObjectNode.removeFromParent()
    //      self.mainObjectNode.position = positionInBear
    //      self.bear.addChild(self.mainObjectNode)
    //      self.bearGrab()
    //    }
  }
  
  /* activate reminder */
  private func resetReminder () {
    self.reminder.removeAllActions()
    self.reminder.runAction(ActionHelper.reminderDelay()) {
      [unowned self] () -> () in
      /* wiggle main */
      self.descriptionLabel.hidden = false
      self.questionLabel.hidden = true
      let name = self.gameController.getMainObj().name
      self.runAction(SoundSourceHelper.soundIdentify(name: name)) {
        [unowned self] () -> () in
        self.runAction(SoundSourceHelper.soundFind(name: name)) {
          [unowned self] () -> () in
          self.iterateOptions()
        }
        self.descriptionLabel.hidden = true
        self.questionLabel.hidden = false
        self.emphasizeOptions()
        self.resetReminder()
      }
      self.mainObjectNode.runAction(ActionHelper.presentObject())
      if let thirdNode = self.thirdOptionNode {
        thirdNode.runAction(ActionHelper.presentObject(reverseOrder: true))
      }
      
      
    }
  }
  
  /* bear comes and grab the object */
  //  func bearGrab () {
  //
  //    self.bear.addChild(self.bearArms)
  //
  //    self.bearArms.runAction(ActionHelper.armGrab())
  //
  //    self.bear.runAction(ActionHelper.bearGrab()) {
  //      [unowned self] () -> () in
  //
  //      self.runAction(ActionHelper.bearGrabWaiting()) {
  //        [unowned self] () -> () in
  //        self.bearArms.runAction(ActionHelper.armWaveWithObject())
  //
  //        self.bear.runAction(ActionHelper.bearWaveWithObject()) {
  //  [unowned self] () -> () in
  //          self.displayOptions()
  //        }
  //      }
  //    }
  //  }
  
  /* initialize options and label */
  func initOptions () {
//    let pair = self.gameController.getObjPair()
    let options = self.gameController.options
    let firstObject = options[0].first!
    let secondObject = options[1].first!
    let firstImageFileName = firstObject.description
    let secondImageFileName = secondObject.description
    let frame = self.initFrame
    
    // draw label
    self.questionLabel.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame) + frame.height / 3)
    
    let firstAtlas = SKTextureAtlas(named: atlasPrefix+firstObject.name)
    let secondAtlas = SKTextureAtlas(named: atlasPrefix+secondObject.name)
    
    self.firstOptionNode = SKSpriteNode(texture: firstAtlas.textureNamed(firstImageFileName))
    //    self.firstOptionNode = SKSpriteNode(imageNamed: firstImageFileName)
    self.firstOptionNode.position = TriadScene.firstLocation(frame: optionsFrame)
    
    //    self.firstOptionGlow = SKSpriteNode(texture: firstAtlas.textureNamed(pair.0.glowName))
    ////    self.firstOptionGlow = SKSpriteNode(imageNamed: pair.0.glowName)
    //    self.firstOptionGlow.position = GameScene.firstLocation(frame: optionsFrame)
    //    self.firstOptionGlow.hidden = true
    
    
    
    
    self.secondOptionNode = SKSpriteNode(texture: secondAtlas.textureNamed(secondImageFileName))
    //    self.secondOptionNode = SKSpriteNode(imageNamed: secondImageFileName)
    self.secondOptionNode.position = TriadScene.secondLocation(frame: optionsFrame)
    
    //    self.secondOptionGlow = SKSpriteNode(texture: secondAtlas.textureNamed(pair.1.glowName))
    ////    self.secondOptionGlow = SKSpriteNode(imageNamed: pair.1.glowName)
    //    self.secondOptionGlow.position = GameScene.secondLocation(frame: optionsFrame)
    //    self.secondOptionGlow.hidden = true
    
    // wait for display
    self.questionLabel.hidden = true
    
    
    let name = self.gameController.getMainObj().name
    
    if gameController.correctIndex == 0 {
      self.correctNode = self.firstOptionNode
      self.wrongNode = self.secondOptionNode
    }
    else {
      self.correctNode = self.secondOptionNode
      self.wrongNode = self.firstOptionNode
    }
    
  }
  
  /* display options and label */
  func displayOptions () {
    self.colorMask.hidden = false
    self.questionLabel.hidden = false
    
    self.addChild(self.colorMask)
    self.addChild(self.firstOptionNode)
    self.addChild(self.secondOptionNode)
    
    //    self.addChild(self.firstOptionGlow)
    //    self.addChild(self.secondOptionGlow)
    
    
    self.allowTouching()
    // play sound effect
    //    let soundFile = SoundSourceHelper.soundFind(name: objectName).stringByAppendingPathExtension(SoundSourceHelper.soundExtension)
    //    self.runAction(ActionHelper.playSound(soundFile: soundFile))
    self.runAction(SoundSourceHelper.soundFind(name: objectName)) {
      [unowned self] () -> () in
      
      //      self.iterateOptions()
      //      self.showGlow()
      
    }
    self.emphasizeOptions()
    
    self.optionsDisplayed = true
  }
  
  func iterateOptions () {
    /* Is it this one? */
    self.firstOptionNode.runAction(ActionHelper.presentObject())
    self.runAction(SoundSourceHelper.soundFirstOne()) {
      [unowned self] () -> () in
      /* Or is it this one? */
      self.secondOptionNode.runAction(ActionHelper.presentObject())
      self.runAction(SoundSourceHelper.soundSecondOne()) {
        [unowned self] () -> () in
        //        self.showGlow()
        self.resetReminder()
      }
    }
  }
  
  func emphasizeOptions (completion: (() -> ()) = {}) {
    self.firstOptionNode.runAction(ActionHelper.presentObject()) {
      //      self.allowTouching()
      completion()
    }
    self.secondOptionNode.runAction(ActionHelper.presentObject(reverseOrder: true))
    
    //    self.firstOptionGlow.runAction(ActionHelper.presentObject())
    //    self.secondOptionGlow.runAction(ActionHelper.presentObject(reverseOrder: true))
    
  }
  
  //  func showGlow () {
  //    self.firstOptionGlow.hidden = false
  //    self.firstOptionGlow.runAction(ActionHelper.beaconGlow(self.gameController.firstObject))
  //
  //    self.secondOptionGlow.hidden = false
  //    self.secondOptionGlow.runAction(ActionHelper.beaconGlow(self.gameController.secondObject))
  //  }
  
  
  /* performance on user selection */
  func correctSelection () {
    
    self.removeAllActions()
    self.resetReminder()
    self.mainObjectNode.removeAllActions()
    self.firstOptionNode.removeAllActions()
    self.secondOptionNode.removeAllActions()
    //    self.firstOptionGlow.removeAllActions()
    //    self.secondOptionGlow.removeAllActions()
    //    self.mainObjectNode.runAction(SKAction.scaleTo(self.normalScale, duration: 0.2))
    //    self.thirdOptionNode.runAction(SKAction.scaleTo(self.normalScale, duration: 0.2))
    self.mainObjectNode.runAction(SKAction.rotateToAngle(0, duration: 0))
    self.correctNode.runAction(SKAction.rotateToAngle(0, duration: 0))
    //    if self.gameController.firstObject.name == self.objectName {
    //      self.firstOptionGlow.runAction(SKAction.rotateToAngle(0, duration: 0))
    //    } else {
    //      self.secondOptionGlow.runAction(SKAction.rotateToAngle(0, duration: 0))
    //    }
    self.reminder.removeAllActions()
    
    self.mainObjectNode.runAction(SKAction.repeatActionForever(ActionHelper.presentObject()))
    self.correctNode.runAction(SKAction.repeatActionForever(ActionHelper.presentObject()))
    
    self.preventTouching()
    touchedCorrectObject = false
    touchedWrongObject = false
    
    if !self.firstTouch{// && statisticsTrack.validate {
      self.firstTouch = true
      UserPerformanceHelper.update(name: objectName, correct: true)
      
//      statisticsTrack.setTimeEnd(NSDate(timeIntervalSinceNow: 0))
//      statisticsTrack.setCorrect(true)
//      statisticsTrack.logEvent()
    }
    
    self.changeMaskColor(UIColor(red: 0, green: 1, blue: 0, alpha: 0.5))
    self.mainObjectNode.zPosition = GameViewController.Layers.AboveMask.rawValue
    //    self.correctNode.zPosition = GameViewController.Layers.AboveMask.rawValue
    //    self.wrongNode.zPosition = GameViewController.Layers.BelowMask.rawValue
    
    //    self.firstOptionGlow.hidden = true
    //    self.secondOptionGlow.hidden = true
    
    self.questionLabel.hidden = true
    
    if self.thirdOptionNode != nil {
      //      self.thirdOptionNode.removeFromParent()
      self.thirdOptionNode.runAction(SKAction.repeatActionForever(ActionHelper.presentObject()))
      self.thirdOptionNode.zPosition = GameViewController.Layers.AboveMask.rawValue
    }
    
//    self.gameViewController?.correctTaskCount++
    self.objectFound()
  }
  
  func wrongSelection () {
    
    self.removeAllActions()
    self.resetReminder()
    
    self.preventTouching()
    touchedCorrectObject = false
    touchedWrongObject = false
    
    wrongCounter++
    
    if !self.firstTouch {// && statisticsTrack.validate {
      self.firstTouch = true
      UserPerformanceHelper.update(name: objectName, correct: false)
      
//      statisticsTrack.setTimeEnd(NSDate(timeIntervalSinceNow: 0))
//      statisticsTrack.setCorrect(false)
//      statisticsTrack.logEvent()
    }
    //    NSLog("Touched: wrong node")
    //    self.wrongNode.runAction(ActionHelper.slightShake())
    
    //    let soundFile = SoundSourceHelper.soundTryAgain().stringByAppendingPathExtension(SoundSourceHelper.soundExtension)
    //    self.runAction(ActionHelper.playSound(soundFile: soundFile))
    
    /* That's not a zif */
    self.runAction(SKAction.sequence([SoundSourceHelper.soundReward()])) {//, SoundSourceHelper.soundTryAgain(name: self.objectName)])) {
      [unowned self] in
      self.allowTouching()
//      var filename = self.objectList[Int(arc4random_uniform(UInt32(self.objectList.count)))].description
      var filename = self.gameController.mainObject.description
      switch self.wrongCounter {
      case 1:
        /* That’s not it. Try again! */
        self.runAction(SoundSourceHelper.soundTryAgain(1)) {
          [unowned self] () -> () in
          /* Can you find the other apple? */
          self.runAction(SoundSourceHelper.soundFind(name: self.objectName))
        }
      case 2:
        /* That’s not right.*/
        self.runAction(SoundSourceHelper.soundTryAgain(2)) {
          /* Remember, this is an apple. */
          self.mainObjectNode.runAction(ActionHelper.presentObject())
          self.runAction(SoundSourceHelper.soundReminder(name: self.objectName)) {
            [unowned self] () -> () in
            /* These are apples. */
            self.thirdOptionNode = SKSpriteNode(texture: SKTextureAtlas(named: self.atlasPrefix+self.objectName).textureNamed(filename))
            self.mainObjectNode.runAction(SKAction.moveByX(-100, y: 0, duration: 0.2))
            self.thirdOptionNode.position = CGPointMake(self.mainObjectNode.position.x + 100, self.mainObjectNode.position.y)
            self.thirdOptionNode.zPosition = GameViewController.Layers.AboveMask.rawValue
            self.thirdOptionNode.xScale = self.mainScaleAfter
            self.thirdOptionNode.yScale = self.mainScaleAfter
            self.addChild(self.thirdOptionNode)
            self.mainObjectNode.runAction(ActionHelper.presentObject())
            self.thirdOptionNode.runAction(ActionHelper.presentObject(reverseOrder: true))
            self.runAction(SoundSourceHelper.soundMultiple(name: self.objectName)) {
              [unowned self] () -> () in
              /* Can you find the other apple */
              self.emphasizeOptions()
              self.runAction(SoundSourceHelper.soundFind(name: self.objectName))
              self.resetReminder()
              
            }
          }
        }
        
      case 3:
        self.preventTouching()
        /* That’s not right.*/
        self.runAction(SoundSourceHelper.soundTryAgain(2)) {
          [unowned self] () -> () in
          /* Can you find the other apple? */
          self.runAction(SoundSourceHelper.soundFind(name: self.objectName)) {
            [unowned self] () -> () in
            self.runAction(SoundSourceHelper.soundTap(name: self.objectName))
            self.mainObjectNode.runAction(ActionHelper.fadeHalfAway())
            self.thirdOptionNode?.runAction(ActionHelper.fadeHalfAway())
            self.wrongNode.runAction(ActionHelper.fadeHalfAway())
            self.correctNode.zPosition = self.topMask.zPosition + 1
          }
        }
        //        self.correctNode.runAction(ActionHelper.slightShake())
        //        /* Look it's a zif */
        //        self.mainObjectNode.runAction(ActionHelper.presentObject())
        //        if self.thirdOptionNode != nil && self.thirdOptionNode.parent != nil {
        //          self.thirdOptionNode.removeFromParent()
        //        }
        //        self.runAction(SoundSourceHelper.soundIdentify(name: self.objectName)) {
        //          [unowned self] () -> () in
        //          /* Look it's another zif */
        //
        //          self.thirdOptionNode = SKSpriteNode(texture: SKTextureAtlas(named: self.objectName).textureNamed(filename))
        //          self.thirdOptionNode.position = CGPointMake(self.mainObjectNode.position.x + 200, self.mainObjectNode.position.y)
        //          self.thirdOptionNode.zPosition = GameViewController.Layers.AboveMask.rawValue
        //          self.thirdOptionNode.xScale = self.mainScaleAfter
        //          self.thirdOptionNode.yScale = self.mainScaleAfter
        //          self.addChild(self.thirdOptionNode)
        //          self.thirdOptionNode.runAction(ActionHelper.presentObject())
        //          self.runAction(SoundSourceHelper.soundIdentify(name: self.objectName)) {
        //            [unowned self] () -> () in
        //            /* Look it's three zifs */
        //            self.mainObjectNode.runAction(ActionHelper.presentObject())
        //            self.correctNode.runAction(ActionHelper.presentObject())
        //            self.thirdOptionNode.runAction(ActionHelper.presentObject())
        //            self.runAction(SoundSourceHelper.soundIdentify(name: self.objectName)) {
        //              [unowned self] () -> () in
        //              /* Can you find the other zif */
        //              self.emphasizeOptions()
        //              self.runAction(SoundSourceHelper.soundFind(name: self.objectName))
        //              self.resetReminder()
        //            }
        //
        //          }
        //        }
        //      case 3:
        ////        self.correctNode.runAction(SKAction.repeatActionForever(ActionHelper.slightShake()))
        //        self.correctSelection()
        //        return
      default:
        self.allowTouching()
        break
      }
    }
    
    
    self.changeMaskColor(UIColor(red: 1, green: 1, blue: 0, alpha: 0.5))
    self.mainObjectNode.zPosition = GameViewController.Layers.BelowMask.rawValue
    if let thirdOption = self.thirdOptionNode {
      thirdOption.zPosition = GameViewController.Layers.BelowMask.rawValue
    }
    //    self.correctNode.zPosition = GameViewController.Layers.BelowMask.rawValue
    //    self.wrongLabel.zPosition = GameViewController.Layers.AboveMask.rawValue
    
    //    self.firstOptionGlow.hidden = true
    //    self.secondOptionGlow.hidden = true
    
    self.runAction(ActionHelper.maskDelay()) {
      [unowned self] () -> () in
      self.resetMask(allowTouching: false)
      self.toddlerLock = false
      //      self.wrongLabel.runAction(ActionHelper.appearAndFadeAway())
    }
    
    self.resetReminder()
  }
  
  func objectFound () {
    //    self.resetMask()
    //    self.foundLabel.hidden = false
    
    /* less distraciton */
    //    self.wrongNode.physicsBody = SKPhysicsBody(rectangleOfSize: self.wrongNode.size)
    //    self.wrongNode.physicsBody?.dynamic = true
    //    self.wrongNode.physicsBody?.affectedByGravity = true
    //
    //    var orientation : CGFloat = self.wrongNode == self.firstOptionNode ? -1 : 1
    //
    //
    //    self.wrongNode.physicsBody?.velocity = CGVectorMake(500*orientation, 500)
    //    self.wrongNode.physicsBody?.applyTorque(-500*orientation*self.wrongNode.physicsBody!.mass)
    
    //    var soundFound = SKAction.playSoundFileNamed(SoundSourceHelper.soundCorrect(name: self.objectName).stringByAppendingPathExtension(SoundSourceHelper.soundExtension), waitForCompletion: true)
    //
    //    self.runAction(soundFound, completion: self.transitionToReviewScene)
    
    self.wrongNode.runAction(ActionHelper.appearAndFadeAway())
    self.runAction(SoundSourceHelper.soundReward()) {
      [unowned self] () -> () in
      self.restartScene()
    }
    
  }
  
  func restartScene () {
    
//    statisticsTrack.setTimeEnd(NSDate(timeIntervalSinceNow: 0))
//    statisticsTrack.setCorrect(nil)
//    statisticsTrack.logEvent()
    
//    self.view?.presentScene(TutorialScene(size: self.frame.size))
    self.userViewController?.presentTutorialScene()
//    self.gameViewController?.presentNextScene()
  }
  
  
  func changeMaskColor (color : UIColor) {
    
    if versionNum >= 8 {
      var colorMask = self.colorMask as! SKShapeNode
      
      colorMask.strokeColor = color
      colorMask.fillColor = color
    }
    else {
      var colorMask = self.colorMask as! SKSpriteNode
      
      colorMask.color = color
    }
    
    
  }
  
  func resetMask (allowTouching:Bool = true) {
    //    self.changeMaskColor(UIColor(white: 0.5, alpha: 0.5))
    self.changeMaskColor(UIColor.clearColor())
    if mainObjectNode != nil {
      self.mainObjectNode.zPosition = GameViewController.Layers.AboveMask.rawValue
    }
    
    if thirdOptionNode != nil {
      self.thirdOptionNode.zPosition = GameViewController.Layers.AboveMask.rawValue
    }
    
    if firstOptionNode != nil {
      self.firstOptionNode.zPosition = GameViewController.Layers.AboveMask.rawValue
    }
    
    if secondOptionNode != nil {
      self.secondOptionNode.zPosition = GameViewController.Layers.AboveMask.rawValue
    }
    
    //    if firstOptionGlow != nil {
    //      self.firstOptionGlow.hidden = false
    //      self.firstOptionGlow.runAction(ActionHelper.beaconGlow(self.gameController.firstObject))
    //    }
    //
    //    if secondOptionGlow != nil {
    //      self.secondOptionGlow.hidden = false
    //      self.secondOptionGlow.runAction(ActionHelper.beaconGlow(self.gameController.secondObject))
    //    }
    
    if allowTouching {
      self.allowTouching()
    }
  }
  
  
  /* initialize bear */
  func initScene () {
    
    self.backgroundColor = UIColor(white: CGFloat(1), alpha: CGFloat(1))
    //    self.background = SKSpriteNode(imageNamed: GlobalConfiguration.backgroundImageName.toRaw())
//    self.background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
    //    self.background.xScale = scale
    //    self.background.yScale = scale
    
    //    var bearAtlas = SKTextureAtlas(named: "bear_grab")
    //    var bearTexture = bearAtlas.textureNamed(bearAtlas.textureNames[0] as String)
    //    self.bear = SKSpriteNode(texture: bearTexture)
    //    self.bear.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
    //
    //    var armAtlas = SKTextureAtlas(named: "arm_grab")
    //    var armTexture = armAtlas.textureNamed(armAtlas.textureNames[0] as String)
    //    self.bearArms = SKSpriteNode(texture: armTexture)
    //    self.bearArms.position = CGPointMake(0, 0)
    
    //    self.bear.xScale = scale
    //    self.bear.yScale = scale
    
//    self.background.zPosition = GameViewController.Layers.Bottom.rawValue
    //    self.bear.zPosition = GameViewController.Layers.BearBody.toRaw()
    //    self.bearArms.zPosition = GameViewController.Layers.BearArm.toRaw()
    
    
//    self.addChild(self.background)
    //    self.addChild(self.bear)
  }
  
  /* touch control */
  func preventTouching () {
    self.topMask.zPosition = GameViewController.Layers.Top.rawValue
  }
  
  func allowTouching () {
    self.topMask.zPosition = GameViewController.Layers.Bottom.rawValue
  }
  
  func zoomIn (duration: NSTimeInterval = 0) {
    
    self.background.runAction(SKAction.scaleTo(1.2, duration: duration))
    //    self.bear.runAction(SKAction.scaleTo(1.2, duration: duration))
    
    
  }
  
  func zoomOut (duration: NSTimeInterval = 0) {
    self.background.runAction(SKAction.scaleTo(1, duration: duration))
    //    self.bear.runAction(SKAction.scaleTo(1, duration: duration))
  }
  
  class func firstLocation (#frame : CGRect) -> CGPoint {
    var orientation = UIApplication.sharedApplication().statusBarOrientation
    
    if orientation == UIInterfaceOrientation.Portrait || orientation == UIInterfaceOrientation.PortraitUpsideDown {
      
      return CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame) + frame.height / 6)
    }
    else {
      return CGPointMake(CGRectGetMidX(frame) - frame.width/6, CGRectGetMidY(frame))
    }
    
  }
  
  class func secondLocation (#frame : CGRect) -> CGPoint {
    var orientation = UIApplication.sharedApplication().statusBarOrientation
    
    if orientation == UIInterfaceOrientation.Portrait || orientation == UIInterfaceOrientation.PortraitUpsideDown {
      
      return CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame) - frame.height / 6)
    }
    else {
      return CGPointMake(CGRectGetMidX(frame) + frame.width/6, CGRectGetMidY(frame))
    }
    
  }
}

