//
//  TriadScene.swift
//  Blicket
//
//  Created by Heng Lyu on 5/29/15.
//  Copyright (c) 2015 Cognitive ToyBox. All rights reserved.
//

import SpriteKit

/* display the main game logic */
class TriadScene: SKScene, ConfigurableScene {
  
  private enum State:Int {
    case Initial=0, MainDisplayed, MainInTransfer, OptionsDisplayed, WaitingForTap
  }
  private var state = State.Initial
  
  let versionNum = Int(UIDevice.currentDevice().systemVersion.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "."))[0])
  
  var selectionRegistered = false
  var labelFontSize = CGFloat(72)
  
  var gameController: GameController! = nil
  weak var _gameViewController: GameViewController? = nil
  var gameViewController: GameViewController? {
    get {
      return _gameViewController
    }
    set {
      _gameViewController = newValue
      if let gvc = _gameViewController {
        gameController = gvc.gameController
      }
    }
  }
  
  var objectName = ""
  
  var background : SKSpriteNode! = nil
  let isBlurred = true
  
  let mainScaleBefore:CGFloat = 2
  let mainScaleAfter:CGFloat = 0.7
  let normalScale:CGFloat = 1
  
  let descriptionLabel = SKLabelNode(fontNamed: GlobalConfiguration.labelFont)
  let questionLabel = SKLabelNode(fontNamed: GlobalConfiguration.labelFont)
  let wrongLabel = SKLabelNode(fontNamed: GlobalConfiguration.labelFont)
  let foundLabel = SKLabelNode(fontNamed: GlobalConfiguration.labelFont)
  
  var mainObjectNode: SKSpriteNode! = nil
  var secondaryMainNode: SKSpriteNode! = nil
  var objectList: [CognitiveToyBoxObject] = []
  var secondaryMainIndex: Int = 0
  
  var firstOptionNode: SKSpriteNode! = nil
  var secondOptionNode: SKSpriteNode! = nil
  
  
  
  var mainGlow: SKSpriteNode! = nil
  var firstOptionGlow: SKSpriteNode! = nil
  var secondOptionGlow: SKSpriteNode! = nil
  
  var correctNode : SKSpriteNode! = nil
  var wrongNode : SKSpriteNode! = nil
  
  /* prevent from touching */
  var topMask : SKNode! = nil
  var colorMask : SKNode! = nil
  
  /* frame size and position */
  var initFrame : CGRect! = nil
  var mainFrame : CGRect! = nil
  var secondaryMainFrame : CGRect! = nil
  var optionsFrame : CGRect! = nil
  var correctFrame: CGRect! = nil
  var wrongFrame: CGRect! = nil
  let touchAreaLength: CGFloat = 240
  
  /* reminder */
  private var reminder: SKNode = SKNode()
  
  /* wrong time counter */
  private var wrongCounter: Int = 0
  
  /* special treatment for toddlers on touching! */
  private var touchedCorrectObject = false
  private var touchedWrongObject = false
  
  /* projection from touchIndex to node */
  var draggingList = [CGPoint: SKSpriteNode] ()
  
  /* track statistics */
  var statisticsTrack = StatisticsTrackHelper()
  
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
    NSLog("Deinit GameScene")
  }
  
  override func didMoveToView(view: SKView) {
    
    SoundSourceHelper.stopBGM()
    
    
    
    
    self.initScene()
    
    self.initLabels()
    
    
    // masks
    
    if #available(iOS 8.0, *) {
      self.topMask = SKShapeNode(rect: self.frame)
      self.colorMask = SKShapeNode(rect: self.frame)
    } else {
      self.topMask = SKSpriteNode(color: UIColor(white: 0, alpha: 1), size: self.frame.size)
      self.topMask.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
      
      self.colorMask = SKSpriteNode(color: UIColor(white: 0.5, alpha: 0.5), size: self.frame.size)
      self.colorMask.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
      
    }  // iOS 8 only

    
    self.topMask.hidden = true
    
    self.resetMask()
    self.colorMask.hidden = true
    
    
    self.addChild(self.topMask)
    
    
    
    
    self.nextSession()
    
    self.initFrame = self.frame
    let offset = self.frame.height/6
    
    self.mainFrame = CGRectOffset(CGRectInset(self.frame, 0, offset), 0, offset)
//    
//    if gameController.task == .Vocabulary {
//      self.optionsFrame = self.frame
//    } else {
      self.optionsFrame = CGRectOffset(CGRectInset(self.frame, 0, offset), 0, -offset)
//    }
    //    }
    
    self.initMain()
    self.initOptions()
    
    self.initLayers()
    
    
    
    
    // show scene
    // ActionHelper returns an SKAction object
    self.runAction(ActionHelper.displayMain()) {  // wait a short time before display main object
      [unowned self] () -> () in
//      if self.gameController.task == .Vocabulary {
//        self.displayOptions()
//        self.emphasizeOptions() {
//          [unowned self] () -> () in
//          self.showGlow()
//          self.allowTouching()
//        }
//      } else {
        self.displayMain()
//      }
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
    
    let allTouches = event.allTouches()! as NSSet
    
    for touch : AnyObject in allTouches {
      var location = (touch as! UITouch).locationInNode(self)
      var node = self.nodeAtPoint(location)
      
      if node.alpha != 1 {
        continue
      }
      
      if state.rawValue>=State.OptionsDisplayed.rawValue && node != topMask && CGRectContainsPoint(correctFrame, location) {
        //      if node === self.correctNode {
        
        touchedCorrectObject = true
        
        // Start toddler special treatment!
        self.runAction(ActionHelper.touchDelay()) {
          [unowned self] () -> () in
          self.toddlerTouch()
        }
        
      } else if state.rawValue>=State.OptionsDisplayed.rawValue && node != topMask && CGRectContainsPoint(wrongFrame, location) {
        
        // wrong once, wrong at all
        
        touchedWrongObject = true
        
        // Start toddler special treatment!
        self.runAction(ActionHelper.touchDelay()) {
          [unowned self] () -> () in
          self.toddlerTouch()
        }
        
        break
      } else if node === mainObjectNode || (secondaryMainNode != nil && node === secondaryMainNode) {
        self.mainTouched()
        
      }
    }
  }

  
  override func touchesBegan (touches: Set<UITouch>, withEvent event: UIEvent?) {
    
    handleTouch(touches, withEvent: event)
    
    if state.rawValue < State.OptionsDisplayed.rawValue {
      return
    }
    
    var location : CGPoint
    var node : SKNode
    var spriteNode : SKSpriteNode?
    
    
    
    for touch : AnyObject in touches {
      location = (touch as! UITouch).locationInNode(self)
      node = self.nodeAtPoint(location)
      
      if node.alpha != 1 {
        continue
      }
      
      spriteNode = (node === mainObjectNode || node === correctNode || node === wrongNode || node === secondaryMainNode) ? (node as! SKSpriteNode) : nil
      
      if spriteNode == nil {
        continue
      }
      
      for (location, draggingNode) in draggingList {
        if draggingNode == spriteNode {
          continue
        }
      }
      
      //      if ReviewScene.isCTBObject(spriteNode!) {//&& self.prevLocationList.indexForKey(spriteNode!) == nil {
      
      
      
      spriteNode!.removeAllActions()
      
      self.draggingList[location] = spriteNode!
      //        self.prevLocationList[spriteNode!] = location
      
//      self.runAction(SoundSourceHelper.soundTouch())
      //      }
    }
    
  }

  override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
//    handleTouch(touches, withEvent: event)
    
    var location : CGPoint
    var prevLocation : CGPoint
    var node : SKNode
    var spriteNode : SKSpriteNode?
    
    
    touchLoop: for touch : AnyObject in touches {
      location = (touch as! UITouch).locationInNode(self)
      prevLocation = (touch as! UITouch).previousLocationInNode(self)
      
      // reregister node
      if self.draggingList.indexForKey(prevLocation) != nil {
        spriteNode = self.draggingList[prevLocation]
        
        self.draggingList.removeValueForKey(prevLocation)
        
        
        if self.draggingList.indexForKey(location) == nil {
          
          //          if self.prevLocationList[spriteNode!] == prevLocation {
          spriteNode!.runAction(ActionHelper.dragTo(location, from: prevLocation))
          self.draggingList[location] = spriteNode!
          //            self.prevLocationList[spriteNode!] = location
          //          }
          
        }
        
      }
      
      node = self.nodeAtPoint(location)
      
      spriteNode = node.isMemberOfClass(SKSpriteNode) ? (node as! SKSpriteNode) : nil
      
    }
  }

  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    let velocityScale : CGFloat = 600
    let maxSpeed : CGFloat = 10000
    
    var location : CGPoint
    var prevLocation : CGPoint
    var node : SKNode
    var spriteNode : SKSpriteNode?
    var velocity : CGVector
    
    touchLoop: for touch : AnyObject in touches {
      location = (touch as! UITouch).locationInNode(self)
      prevLocation = (touch as! UITouch).previousLocationInNode(self)
      
      node = self.nodeAtPoint(location)
      
      spriteNode = nil
      // unregister node
      if self.draggingList.indexForKey(prevLocation) != nil {
        
        spriteNode = draggingList[prevLocation]
        self.draggingList.removeValueForKey(prevLocation)
        
      }
      
      if self.draggingList.indexForKey(location) != nil {
        
        spriteNode = draggingList[location]
        self.draggingList.removeValueForKey(location)
        
        
      }
      
      
    }
    
    if event!.allTouches()?.count == touches.count {
      self.resetDrag()
    }
    
    handleTouch(touches, withEvent: event)
    
    
    
  }
  
  func resetDrag () {
    let duration:NSTimeInterval = 0.2
    
    if let main = self.mainObjectNode {
      main.runAction(SKAction.group([SKAction.moveTo(CGPointMake(CGRectGetMidX(self.mainFrame), CGRectGetMidY(self.mainFrame)), duration: duration), SKAction.rotateToAngle(0, duration: duration)]))
    }
    
    if let secondary = self.secondaryMainNode {
      secondary.runAction(SKAction.group([SKAction.moveTo(CGPointMake(CGRectGetMidX(self.secondaryMainFrame), CGRectGetMidY(self.secondaryMainFrame)), duration: duration), SKAction.rotateToAngle(0, duration: duration)]))
    }
    
    if let correct = self.correctNode {
      correct.runAction(SKAction.group([SKAction.moveTo(CGPointMake(CGRectGetMidX(self.correctFrame), CGRectGetMidY(self.correctFrame)), duration: duration), SKAction.rotateToAngle(0, duration: duration)]))
    }
    
    if let wrong = self.wrongNode {
      wrong.runAction(SKAction.group([SKAction.moveTo(CGPointMake(CGRectGetMidX(self.wrongFrame), CGRectGetMidY(self.wrongFrame)), duration: duration), SKAction.rotateToAngle(0, duration: duration)]))
    }
    
    self.draggingList.removeAll(keepCapacity: false)
    //    self.prevLocationList.removeAll(keepCapacity: false)
  }
  
  override func update(currentTime: CFTimeInterval) {
    /* Called before each frame is rendered */
  }
  
  /* refresh GameController */
  func nextSession () {
    
    self.wrongCounter = 0
    
    self.preventTouching()
    
    self.objectList = self.gameController.getListWithSameName().filter() { [unowned self] (object:CognitiveToyBoxObject) -> Bool in
      !object.equals(self.gameController.getMainObj()) && !object.equals(self.gameController.getCorrectObj()) 
    }
    
    // refresh main
    self.objectName = self.gameController.getMainObj().name
    self.descriptionLabel.text = "\(objectName)"
    self.questionLabel.text = "\(objectName)"
    
    
    
    self.wrongLabel.text = "That's not a \(objectName)!"
    
    self.runAction(ActionHelper.delayNextSession()) {
      [unowned self] () -> () in
      self.restartScene()
    }
    
    
    /* update statisticsTrack */
    if let userInfo = UserInfoHelper.getUserInfo() {
      statisticsTrack.validate = true
      statisticsTrack.setUser(userInfo)
    }
    
    statisticsTrack.setDate(NSDate(timeIntervalSinceNow: 0))
    statisticsTrack.setTimeStart(NSDate(timeIntervalSinceNow: 0))
    statisticsTrack.setObject1(self.gameController.mainObject)
    statisticsTrack.setObject2(self.gameController.options[0].first!)
    statisticsTrack.setObject3(self.gameController.options[1].first!)
    
//    if gameController.task == .Vocabulary {
//      self.foundLabel.text = "1 \(objectName)!"
//      statisticsTrack.setTaskType("Vocabulary")
//    } else {
      self.foundLabel.text = "2 \(CognitiveToyBoxObject.getPluralName(objectName))!"
      statisticsTrack.setTaskType("Shape Bias")
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
    self.firstOptionGlow.zPosition = GameViewController.Layers.BearArm.rawValue
    self.secondOptionGlow.zPosition = GameViewController.Layers.BearArm.rawValue
    self.mainGlow.zPosition = GameViewController.Layers.BearArm.rawValue
  }
  
  
  /* initialize main object and label */
  func initMain () {
    
    let imageFileName = self.gameController.getMainObj().description
    let scale = self.mainScaleBefore
    let frame = self.initFrame
    
    // draw label
    
    self.descriptionLabel.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame) + frame.height / 3)
    
    var mainTextureAtlas = SKTextureAtlas(named: self.gameController.getMainObj().name)
    self.mainObjectNode = SKSpriteNode(texture: mainTextureAtlas.textureNamed(imageFileName))
    self.mainObjectNode.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame) - 0)
    self.mainObjectNode.xScale = scale
    self.mainObjectNode.yScale = scale
    
    /* main glow */
    //    self.mainGlow = SKSpriteNode(texture: mainTextureAtlas.textureNamed(gameController.getMainObj().glowName))
    self.mainGlow = SKSpriteNode(imageNamed: "glow")
    self.mainGlow.position = self.mainObjectNode.position
    
    
    // wait for display
    self.descriptionLabel.hidden = true
  }
  
  /* display main object and label */
  func displayMain () {
    self.descriptionLabel.hidden = false
    
    var mainBaseNode = SKNode()
    
    self.addChild(self.mainObjectNode)
    
    self.state = .MainDisplayed
    
    // play sound effect
    let name = self.gameController.getMainObj().name
    self.runAction(SoundSourceHelper.soundIdentify(name: name))
    
    self.allowTouching()
    self.mainObjectNode.runAction(ActionHelper.presentObject()) {
      [unowned self] () -> () in
      if self.state.rawValue < State.MainInTransfer.rawValue {
        self.addChild(self.mainGlow)
        self.mainGlow.runAction(ActionHelper.beaconGlow(self.mainScaleBefore))
      }
      
      self.mainObjectNode.runAction(ActionHelper.waitForMain()) {
        [unowned self] () -> () in
        self.mainTouched()
      }
    }
    
  }
  
  func mainTouched () {
    self.mainObjectNode.removeAllActions()
    self.mainObjectNode.runAction(SKAction.rotateToAngle(0, duration: 0))
    self.descriptionLabel.hidden = true
    
    if self.state.rawValue < State.OptionsDisplayed.rawValue {
      self.preventTouching()
      self.translateMain()
      if self.mainGlow.parent != nil {
        self.mainGlow.removeFromParent()
      }
    } else {
      self.emphasizeOptions()
    }
    
    
  }
  
  /* transition main */
  func translateMain () {
    self.descriptionLabel.hidden = true
    self.state = .MainInTransfer
    
    self.mainObjectNode.runAction(ActionHelper.transitionMain(location: CGPointMake(CGRectGetMidX(self.mainFrame), CGRectGetMidY(self.mainFrame)), scaleBy: self.mainScaleAfter/self.mainScaleBefore)) {
      [unowned self] () -> () in
      self.displayOptions()
      
    }
  }
  
  /* activate reminder */
  private func resetReminder () {
    self.reminder.removeAllActions()
    self.reminder.runAction(ActionHelper.reminderDelay()) {
      [unowned self] () -> () in
      /* tap on the correct object */
      if self.state == .WaitingForTap {
        self.correctNode.runAction(ActionHelper.presentObject()) {
          [unowned self] in
          self.runAction(SoundSourceHelper.soundTap(name: self.gameController.getMainObj().name))
        }
        return
      }
      
      /* wiggle main */
      self.descriptionLabel.hidden = false
      self.questionLabel.hidden = true
      let name = self.gameController.getMainObj().name
      self.runAction(SoundSourceHelper.soundIdentify(name: name))
      self.mainObjectNode.runAction(ActionHelper.presentObject()) {
        [unowned self] () -> () in
        self.runAction(SoundSourceHelper.soundFind(name: name))
        self.descriptionLabel.hidden = true
        self.questionLabel.hidden = false
        self.emphasizeOptions() {
          [unowned self] () -> () in
          self.iterateOptions()
        }
        self.resetReminder()
      }
      if let thirdNode = self.secondaryMainNode {
        thirdNode.runAction(ActionHelper.presentObject(true))
      }
      
      
    }
  }
  
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
    
    let firstAtlas = SKTextureAtlas(named: firstObject.name)
    let secondAtlas = SKTextureAtlas(named: secondObject.name)
    
    self.firstOptionNode = SKSpriteNode(texture: firstAtlas.textureNamed(firstImageFileName))
    self.firstOptionNode.position = TriadScene.firstLocation(frame: optionsFrame)
    
    //    self.firstOptionGlow = SKSpriteNode(texture: firstAtlas.textureNamed(pair.0.glowName))
    self.firstOptionGlow = SKSpriteNode(imageNamed: "glow")
    self.firstOptionGlow.position = TriadScene.firstLocation(frame: optionsFrame)
    self.firstOptionGlow.hidden = true
    
    
    
    
    self.secondOptionNode = SKSpriteNode(texture: secondAtlas.textureNamed(secondImageFileName))
    self.secondOptionNode.position = TriadScene.secondLocation(frame: optionsFrame)
    
    //    self.secondOptionGlow = SKSpriteNode(texture: secondAtlas.textureNamed(pair.1.glowName))
    self.secondOptionGlow = SKSpriteNode(imageNamed: "glow")
    self.secondOptionGlow.position = TriadScene.secondLocation(frame: optionsFrame)
    self.secondOptionGlow.hidden = true
    
    self.firstOptionGlow.runAction(ActionHelper.beaconGlow())
    self.secondOptionGlow.runAction(ActionHelper.beaconGlow())
    
    // wait for display
    self.questionLabel.hidden = true
    
    
    if gameController.correctIndex == 0 {
      self.correctNode = self.firstOptionNode
      self.wrongNode = self.secondOptionNode
    }
    else {
      self.correctNode = self.secondOptionNode
      self.wrongNode = self.firstOptionNode
    }
    
    adjustOptionsPosition()
    
    correctFrame = CGRect(origin: CGPointApplyAffineTransform(correctNode.position, CGAffineTransformMakeTranslation(-touchAreaLength/2, -touchAreaLength/2)) , size: CGSize(width: touchAreaLength, height: touchAreaLength))
    wrongFrame = CGRect(origin: CGPointApplyAffineTransform(wrongNode.position, CGAffineTransformMakeTranslation(-touchAreaLength/2, -touchAreaLength/2)) , size: CGSize(width: touchAreaLength, height: touchAreaLength))
    
  }
  
  /* make sure objects look comfortable.  */
  func adjustOptionsPosition () {
    var position1 = firstOptionNode.position
    var position2 = secondOptionNode.position
    let width1 = firstOptionNode.frame.width
    let width2 = secondOptionNode.frame.width
    
    let minInterval:CGFloat = 100
    
    var orientation = UIApplication.sharedApplication().statusBarOrientation
    
    if orientation == UIInterfaceOrientation.Portrait || orientation == UIInterfaceOrientation.PortraitUpsideDown {
    } else {
      var dx = (position2.x - width2/2) - (position1.x + width1/2)
      if dx < minInterval {
        let x1 = position1.x - (minInterval - dx)/2
        let x2 = position2.x + (minInterval - dx)/2
        firstOptionNode.position.x = x1
        firstOptionGlow.position.x = x1
        secondOptionNode.position.x = x2
        secondOptionNode.position.x = x2
      }
    }
  }
  
  /* display options and label */
  func displayOptions () {
    self.colorMask.hidden = false
    self.questionLabel.hidden = false
    
    self.addChild(self.colorMask)
    self.addChild(self.firstOptionNode)
    self.addChild(self.secondOptionNode)
    
    self.addChild(self.firstOptionGlow)
    self.addChild(self.secondOptionGlow)
    
    
    self.allowTouching()
    // play sound effect
    self.runAction(SoundSourceHelper.soundFind(name: objectName))
    self.emphasizeOptions() {
      [unowned self] () -> () in
      
      self.resetReminder()
      self.showGlow()
      
    }
    
    self.state = .OptionsDisplayed
  }
  
  func iterateOptions () {
    /* Is it this one? */
    self.firstOptionNode.runAction(ActionHelper.presentObject()) {
      [unowned self] () -> () in
      /* Or is it this one? */
      self.secondOptionNode.runAction(ActionHelper.presentObject()) {
        [unowned self] () -> () in
        self.showGlow()
        self.resetReminder()
      }
      self.runAction(SoundSourceHelper.soundSecondOne())
    }
    self.runAction(SoundSourceHelper.soundFirstOne())
  }
  
  func emphasizeOptions (completion: (() -> ()) = {}) {
    self.firstOptionNode.runAction(ActionHelper.presentObject()) {
      //      self.allowTouching()
      completion()
    }
    self.secondOptionNode.runAction(ActionHelper.presentObject(true))
    
    //    self.firstOptionGlow.runAction(ActionHelper.presentObject())
    //    self.secondOptionGlow.runAction(ActionHelper.presentObject(reverseOrder: true))
    
  }
  
  func showGlow () {
    self.firstOptionGlow.hidden = false
    //    self.firstOptionGlow.runAction(ActionHelper.beaconGlow())
    
    self.secondOptionGlow.hidden = false
    //    self.secondOptionGlow.runAction(ActionHelper.beaconGlow())
  }
  
  
  /* performance on user selection */
  func correctSelection () {
    
    self.removeAllActions()
    self.resetReminder()
    self.mainObjectNode.removeAllActions()
    self.firstOptionNode.removeAllActions()
    self.secondOptionNode.removeAllActions()
    //    self.firstOptionGlow.removeAllActions()
    //    self.secondOptionGlow.removeAllActions()
    
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
    
    if !self.selectionRegistered && statisticsTrack.validate {
      self.selectionRegistered = true
      UserPerformanceHelper.update(name: objectName, correct: true)
      
      statisticsTrack.setTimeEnd(NSDate(timeIntervalSinceNow: 0))
      statisticsTrack.setCorrect(true)
      statisticsTrack.logEvent()
    }
    
    self.changeMaskColor(UIColor(red: 0, green: 1, blue: 0, alpha: 0.5))
    self.mainObjectNode.zPosition = GameViewController.Layers.AboveMask.rawValue
    
    self.firstOptionGlow.hidden = true
    self.secondOptionGlow.hidden = true
    
    self.questionLabel.hidden = true
    
    if self.secondaryMainNode != nil {
      self.secondaryMainNode.runAction(SKAction.repeatActionForever(ActionHelper.presentObject()))
      self.secondaryMainNode.zPosition = GameViewController.Layers.AboveMask.rawValue
    }
    
    self.objectFound()
  }
  
  func wrongSelection () {
    
    self.removeAllActions()
    self.resetReminder()
    self.mainObjectNode.removeAllActions()
    self.firstOptionNode.removeAllActions()
    self.secondOptionNode.removeAllActions()
    //    self.firstOptionGlow.removeAllActions()
    //    self.secondOptionGlow.removeAllActions()
    
    self.mainObjectNode.runAction(SKAction.rotateToAngle(0, duration: 0))
    self.correctNode.runAction(SKAction.rotateToAngle(0, duration: 0))
    self.wrongNode.runAction(SKAction.rotateToAngle(0, duration: 0))
    
    self.preventTouching()
    
    wrongCounter++
    
    if !self.selectionRegistered && statisticsTrack.validate {
      self.selectionRegistered = true
      UserPerformanceHelper.update(name: objectName, correct: false)
      
      statisticsTrack.setTimeEnd(NSDate(timeIntervalSinceNow: 0))
      statisticsTrack.setCorrect(false)
      statisticsTrack.logEvent()
    }
    
    if self.state == .WaitingForTap {
      /* that's not right */
      self.runAction(SoundSourceHelper.soundTryAgain(2)) {
        [unowned self] in
        /* tap on the xxx */
        self.runAction(SoundSourceHelper.soundTap(name: self.gameController.getMainObj().name))
        self.correctNode.runAction(ActionHelper.presentObject())
        self.allowTouching()
      }
      
    } else {
      
      /* That's not a zif */
      self.runAction(SKAction.sequence([SoundSourceHelper.soundError()])) {
        [unowned self] in
        self.firstOptionGlow.hidden = false
        self.secondOptionGlow.hidden = false
        if self.wrongCounter > 1 {
          /* hide wrong glow */
          if self.gameController.correctIndex == 1 {
            self.firstOptionGlow.hidden = true
          } else {
            self.secondOptionGlow.hidden = true
          }
        }
        
        self.allowTouching()
        let index = Int(arc4random_uniform(UInt32(self.objectList.count)))
        var filename = self.objectList[index].description
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
            self.mainObjectNode.runAction(ActionHelper.presentObject()) {
              [unowned self] () -> () in
              /* These are apples. */
              self.secondaryMainNode = SKSpriteNode(texture: SKTextureAtlas(named: self.objectName).textureNamed(filename))
              self.secondaryMainIndex = index
              self.mainObjectNode.runAction(SKAction.moveByX(-100, y: 0, duration: 0.2))
              self.secondaryMainNode.position = CGPointMake(self.mainObjectNode.position.x + 100, self.mainObjectNode.position.y)
              self.secondaryMainNode.zPosition = GameViewController.Layers.AboveMask.rawValue
              self.secondaryMainNode.xScale = self.mainScaleAfter
              self.secondaryMainNode.yScale = self.mainScaleAfter
              self.addChild(self.secondaryMainNode)
              
              self.mainFrame = self.mainObjectNode.frame
              self.secondaryMainFrame = self.secondaryMainNode.frame
              
              self.mainObjectNode.runAction(ActionHelper.presentObject())
              self.secondaryMainNode.runAction(ActionHelper.presentObject(true))
              self.runAction(SoundSourceHelper.soundMultiple(name: self.objectName)) {
                [unowned self] () -> () in
                /* Can you find the other apple */
                self.emphasizeOptions()
                self.runAction(SoundSourceHelper.soundFind(name: self.objectName))
                self.resetReminder()
                
              }
            }
            self.runAction(SoundSourceHelper.soundReminder(name: self.objectName))
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
              self.secondaryMainNode?.runAction(ActionHelper.fadeHalfAway())
              self.wrongNode.runAction(ActionHelper.fadeHalfAway())
              self.allowTouching()
              self.state = .WaitingForTap
              var node = SKNode()
              self.addChild(node)
              node.runAction(SKAction.waitForDuration(30)) {
                [unowned self] in
                self.gameViewController?.presentGameScene(true)
              }
            }
          }
          
        default:
          break
        }
      }
    }
    
    
    self.changeMaskColor(UIColor(red: 1, green: 1, blue: 0, alpha: 0.5))
    self.mainObjectNode.zPosition = GameViewController.Layers.BelowMask.rawValue
    if let thirdOption = self.secondaryMainNode {
      thirdOption.zPosition = GameViewController.Layers.BelowMask.rawValue
    }
    
    self.firstOptionGlow.hidden = true
    self.secondOptionGlow.hidden = true
    
    self.runAction(ActionHelper.maskDelay()) {
      [unowned self] () -> () in
      self.resetMask(false)
      self.toddlerLock = false
    }
    
    self.resetReminder()
  }
  
  func objectFound () {
    
    self.wrongNode.runAction(ActionHelper.appearAndFadeAway())
    self.runAction(SoundSourceHelper.soundReward()) {
      [unowned self] () -> () in
      self.transitionToReviewScene()
    }
    
  }
  
  func transitionToReviewScene () {
    
    
    self.gameViewController?.presentReviewScene()
  }
  
  func restartScene () {
    
    statisticsTrack.setTimeEnd(NSDate(timeIntervalSinceNow: 0))
    statisticsTrack.setCorrect(nil)
    statisticsTrack.logEvent()
    
    self.gameViewController?.presentGameScene(false)
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
    
    if secondaryMainNode != nil {
      self.secondaryMainNode.zPosition = GameViewController.Layers.AboveMask.rawValue
    }
    
    if firstOptionNode != nil {
      self.firstOptionNode.zPosition = GameViewController.Layers.AboveMask.rawValue
    }
    
    if secondOptionNode != nil {
      self.secondOptionNode.zPosition = GameViewController.Layers.AboveMask.rawValue
    }
    
    if firstOptionGlow != nil {
      //      self.firstOptionGlow.hidden = false
      //      self.firstOptionGlow.runAction(ActionHelper.beaconGlow())
    }
    
    if secondOptionGlow != nil {
      //      self.secondOptionGlow.hidden = false
      //      self.secondOptionGlow.runAction(ActionHelper.beaconGlow())
    }
    
    if allowTouching {
      self.allowTouching()
    }
  }
  
  
  /* initialize bear */
  func initScene () {
    
    self.background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
    
    self.background.zPosition = GameViewController.Layers.Bottom.rawValue
    
    
    self.addChild(self.background)
    //    self.addChild(self.bear)
  }
  
  /* touch control */
  func preventTouching () {
    self.resetDrag()
    self.topMask.zPosition = GameViewController.Layers.Top.rawValue
  }
  
  func allowTouching () {
    self.topMask.zPosition = GameViewController.Layers.Bottom.rawValue
  }
  
  func zoomIn (duration: NSTimeInterval = 0) {
    
    self.background.runAction(SKAction.scaleTo(1.2, duration: duration))
    
    
  }
  
  func zoomOut (duration: NSTimeInterval = 0) {
    self.background.runAction(SKAction.scaleTo(1, duration: duration))
  }
  
  class func firstLocation (frame frame : CGRect) -> CGPoint {
    var orientation = UIApplication.sharedApplication().statusBarOrientation
    
    if orientation == UIInterfaceOrientation.Portrait || orientation == UIInterfaceOrientation.PortraitUpsideDown {
      
      return CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame) + frame.height / 6)
    }
    else {
      return CGPointMake(CGRectGetMidX(frame) - frame.width/6, CGRectGetMidY(frame))
    }
    
  }
  
  class func secondLocation (frame frame : CGRect) -> CGPoint {
    var orientation = UIApplication.sharedApplication().statusBarOrientation
    
    if orientation == UIInterfaceOrientation.Portrait || orientation == UIInterfaceOrientation.PortraitUpsideDown {
      
      return CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame) - frame.height / 6)
    }
    else {
      return CGPointMake(CGRectGetMidX(frame) + frame.width/6, CGRectGetMidY(frame))
    }
    
  }
}

