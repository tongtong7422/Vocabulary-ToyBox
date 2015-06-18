//
//  DragScene.swift
//  Cognitive ToyBox
//
//  Created by Heng Lyu on 3/20/15.
//  Copyright (c) 2015 Cognitive ToyBox. All rights reserved.
//

import SpriteKit

class DragScene: SKScene, ConfigurableScene {
  
  private enum State:Int {
    case Initial=0, MainDisplayed, OptionsDisplayed
  }
  private var state:State = .Initial
  
  let versionNum = UIDevice.currentDevice().systemVersion.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "."))[0].toInt()
  
  let labelFontSize = CGFloat(72)
  
  var background:SKSpriteNode! = nil
  let isBlurred = true
  
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
  
  var mainObjectNode: SKSpriteNode! = nil
  var mainObjectGlow: SKSpriteNode! = nil
  
  var firstObjectList:NSArray = []
  var secondObjectList:NSArray = []
  
  var firstNodeList:[SKSpriteNode] = []
  var secondNodeList:[SKSpriteNode] = []
  
  
  var correctNodeList:[SKSpriteNode] {
    get {
      if gameController.correctIndex == 0 {
        return firstNodeList as [SKSpriteNode]
      } else {
        return secondNodeList as [SKSpriteNode]
      }
    }
  }
  var wrongNodeList:[SKSpriteNode] {
    get {
      if gameController.correctIndex == 1 {
        return firstNodeList as [SKSpriteNode]
      } else {
        return secondNodeList as [SKSpriteNode]
      }
    }
  }
//  var wrongNodeList:[SKSpriteNode]! = nil
  
  var correctNode:SKSpriteNode? = nil
  var wrongNode:SKSpriteNode? = nil
  var reminder:SKNode = SKNode()
  
  var mainFrame:CGRect! = nil
  var leftFrame:CGRect! = nil
  var rightFrame:CGRect! = nil
  
  let mainScaleBefore:CGFloat = 2
  let mainScaleAfter:CGFloat = 0.8
  let optionScale:CGFloat = 0.8
  
//  var topMask : SKNode! = nil
  
  /* wrong time counter */
  private var wrongCounter: Int = 0
  private var selectionRegistered: Bool = false
  
  let descriptionLabel = SKLabelNode(fontNamed: GlobalConfiguration.labelFont)
  
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
    NSLog("Deinit DragScene1")
  }
  
  /* special treatment for toddlers on touching! */
  private var touchedCorrectObject = false
  private var touchedWrongObject = false
  
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
      var node = self.nodeAtPoint(location)
      
      if node.alpha != 1 {
        continue
      }
      
//      if self.correctNode != nil && node === self.correctNode! {
      if node is SKSpriteNode && contains(self.correctNodeList, node as! SKSpriteNode) {
      
        touchedCorrectObject = true
        
        // Start toddler special treatment!
        self.runAction(ActionHelper.touchDelay()) {
          [unowned self] () -> () in
          self.toddlerTouch()
        }
        
//      } else if self.wrongNode != nil && node === wrongNode! {
      } else if node is SKSpriteNode && contains(self.wrongNodeList, node as! SKSpriteNode) {
      
        // wrong once, wrong at all
        
        touchedWrongObject = true
        
        // Start toddler special treatment!
        self.runAction(ActionHelper.touchDelay()) {
          [unowned self] () -> () in
          self.toddlerTouch()
        }
        
        node.runAction(ActionHelper.presentObject())
        
        break
      } else if node === mainObjectNode {
        self.mainTouched()
        
      }
    }
  }
  
//  override func touchesBegan (touches: NSSet, withEvent event: UIEvent) {
//    
//    handleTouch(touches, withEvent: event)
//    
//  }
  
//  override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
//    handleTouch(touches, withEvent: event)
//  }
  
  override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
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
      
      if spriteNode != nil {
        if CGRectContainsPoint(self.correctNode!.frame, spriteNode!.position) {
          correctSelection()
        } else {
          if CGRectContainsPoint(self.wrongNode!.frame, spriteNode!.position) {
            wrongSelection()
          }
          spriteNode?.runAction(SKAction.group([SKAction.moveTo(CGPointMake(CGRectGetMidX(self.mainFrame), CGRectGetMidY(self.mainFrame)), duration: 0.2), SKAction.rotateToAngle(0, duration: 0.2)]))
        }
      }
      
      
      
      
    }
    
    if event.allTouches()?.count == touches.count {
      self.resetDrag()
    }
    
    
    
  }
  
  override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
    
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
      
      spriteNode = node === mainObjectNode ? (node as! SKSpriteNode) : nil
      
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
        
//        self.runAction(SoundSourceHelper.soundTouch())
//      }
    }
    
    
  }
  
  override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
    
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
  
  func resetDrag () {
    self.draggingList.removeAll(keepCapacity: false)
    //    self.prevLocationList.removeAll(keepCapacity: false)
  }
  
  override func didMoveToView(view: SKView) {
    
    SoundSourceHelper.stopBGM()
    
    let mainOffset = self.frame.height/6
    let optionsOffsetX = self.frame.width/5
    let optionsOffsetY = self.frame.height/8
    self.mainFrame = CGRectOffset(CGRectInset(self.frame, 0, mainOffset), 0, mainOffset)
    self.leftFrame = CGRectOffset(CGRectInset(self.frame, optionsOffsetX, optionsOffsetY), -optionsOffsetX*1.6, -optionsOffsetY/2)
    self.rightFrame = CGRectOffset(CGRectInset(self.frame, optionsOffsetX, optionsOffsetY), optionsOffsetX*1.6, -optionsOffsetY/2)
    
    // masks
//    if versionNum >= 8 {
//      self.topMask = SKShapeNode(rect: self.frame)  // iOS 8 only
//    }
//    else {
//      self.topMask = SKSpriteNode(color: UIColor(white: 0, alpha: 1), size: self.frame.size)
//      self.topMask.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
//    }
//    
//    self.topMask.hidden = true
//    
//    self.addChild(self.topMask)
    
    self.initScene()
    self.initLabels()
    
    self.initMain()
    self.initOptions()
    
    descriptionLabel.text = "Put the \(gameController.mainObject.name) with the other \(gameController.mainObject.pluralName)!"
    
    self.initLayers()
    
    displayMain()
    
    self.addChild(reminder)
    resetReminder()
    
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
  }
  
  override func update(currentTime: NSTimeInterval) {
    super.update(currentTime)
    
    if self.mainObjectGlow != nil && self.mainObjectNode != nil {
      self.mainObjectGlow.position = self.mainObjectNode.position
    }
  }
  
  func resetReminder () {
    self.reminder.removeAllActions()
    self.reminder.runAction(SKAction.waitForDuration(30)) {
      [unowned self] () -> () in
      self.runAction(SoundSourceHelper.soundPut(name: self.gameController.mainObject.name))
      
      
    }
  }
  
  func initScene () {
    self.background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
    
    self.background.zPosition = GameViewController.Layers.Bottom.rawValue
    
    self.addChild(self.background)
  }
  
  /* initialize labels */
  func initLabels () {
    self.descriptionLabel.fontSize = self.labelFontSize
    self.descriptionLabel.fontColor = UIColor(white: CGFloat(0), alpha: CGFloat(1))
    
    self.addChild(self.descriptionLabel)
  }
  
  /* initialize main object and label */
  func initMain () {
    
    let imageFileName = self.gameController.getMainObj().description
    let frame = self.frame
    
    // draw label
    
    self.descriptionLabel.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame) + frame.height / 3)
    
    self.mainObjectNode = SKSpriteNode(texture: SKTextureAtlas(named: self.gameController.getMainObj().name).textureNamed(imageFileName))
    self.mainObjectNode.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame) - 0)
    self.mainObjectNode.setScale(self.mainScaleBefore)
    
    self.mainObjectGlow = SKSpriteNode(imageNamed: "glow")
    
    
  }
  
  /* display main object and label */
  func displayMain () {
//    self.descriptionLabel.hidden = false
//    
//    self.addChild(self.mainObjectNode)
//    
//    self.state = .MainDisplayed
//    
//    // play sound effect
//    let name = self.gameController.getMainObj().name
//    self.runAction(SoundSourceHelper.soundIdentify(name: name))
//    
////    self.allowTouching()
//    self.mainObjectNode.runAction(ActionHelper.presentObject()) {
//      [unowned self] () -> () in
//      self.state = .MainDisplayed
//      self.addChild(self.mainObjectGlow)
//      self.mainObjectGlow.runAction(ActionHelper.beaconGlow(scale:self.mainScaleBefore))
//      
//      self.mainObjectNode.runAction(ActionHelper.waitForMain()) {
//        [unowned self] () -> () in
//        self.mainTouched()
//      }
//    }
    
//    self.runAction(SoundSourceHelper.soundPut(name: self.gameController.getMainObj().name))
    
    self.mainObjectNode.position = CGPointMake(CGRectGetMidX(self.mainFrame), CGRectGetMidY(self.mainFrame))
    self.addChild(self.mainObjectNode)
    self.mainObjectNode.setScale(mainScaleAfter)
    self.mainObjectNode.runAction(ActionHelper.presentObject())
    self.addChild(self.mainObjectGlow)
    self.mainObjectGlow.runAction(ActionHelper.beaconGlow(scale: self.mainScaleAfter))
    
    self.state = .OptionsDisplayed
    self.displayOptions()
    
  }
  
  
  func initOptions () {
//    var pair = gameController.getListPair()
    var options = gameController.options
    firstObjectList = options[0]
    secondObjectList = options[1]
    
    correctNode = SKSpriteNode(imageNamed: "questionIcon")
    wrongNode = SKSpriteNode(imageNamed: "questionIcon")
    
    /* determine which set is correct */
    let name = self.gameController.getMainObj().name
    if gameController.correctIndex == 0 {
      firstNodeList.append(correctNode!)
      secondNodeList.append(wrongNode!)
    } else {
      firstNodeList.append(wrongNode!)
      secondNodeList.append(correctNode!)
    }
    
    /* push nodes */
    for obj in firstObjectList {
      let ctbObj = obj as! CognitiveToyBoxObject
      firstNodeList.append(SKSpriteNode(imageNamed: ctbObj.description))
    }
    for obj in secondObjectList {
      let ctbObj = obj as! CognitiveToyBoxObject
      secondNodeList.append(SKSpriteNode(imageNamed: ctbObj.description))
    }
    
    /* set position */
    let firstListCount = firstNodeList.count
    let secondListCount = secondNodeList.count
    var cellHeight = leftFrame.height/CGFloat(firstListCount)
    var y:CGFloat = CGRectGetMaxY(leftFrame) - cellHeight/2
    for node in firstNodeList {
      node.position = CGPointMake(CGRectGetMidX(leftFrame), y)
      node.setScale(optionScale)
      y -= cellHeight
    }
    
    cellHeight = rightFrame.height/CGFloat(secondListCount)
    y = CGRectGetMaxY(rightFrame) - cellHeight/2
    for node in secondNodeList {
      node.position = CGPointMake(CGRectGetMidX(rightFrame), y)
      node.setScale(optionScale)
      y -= cellHeight
    }
    
    
  }
  
  /* initialize GameViewController.Layers */
  func initLayers () {
//    self.topMask.zPosition = GameViewController.Layers.Top.rawValue
    self.descriptionLabel.zPosition = GameViewController.Layers.Label.rawValue
    self.mainObjectNode.zPosition = GameViewController.Layers.BelowLabel.rawValue
    for node in firstNodeList {
      node.zPosition = GameViewController.Layers.AboveMask.rawValue
    }
    for node in secondNodeList {
      node.zPosition = GameViewController.Layers.AboveMask.rawValue
    }
  }
  
  func mainTouched () {
    self.mainObjectNode.removeAllActions()
    self.mainObjectNode.runAction(SKAction.rotateToAngle(0, duration: 0))
//    self.descriptionLabel.hidden = true
    if state.rawValue < State.OptionsDisplayed.rawValue {
      self.translateMain()
      
    } else {
      
    }
    
    
  }
  
  /* transition main */
  func translateMain () {
    self.descriptionLabel.hidden = true
    
    self.mainObjectNode.runAction(ActionHelper.transitionMain(location: CGPointMake(CGRectGetMidX(self.mainFrame), CGRectGetMidY(self.mainFrame)), scaleBy: self.mainScaleAfter/self.mainScaleBefore)) {
      [unowned self] () -> () in
      self.state = .OptionsDisplayed
      self.displayOptions()
      
      if self.mainObjectGlow.parent == nil {
        self.addChild(self.mainObjectGlow)
      }
      self.mainObjectGlow.removeAllActions()
      self.mainObjectGlow.runAction(ActionHelper.beaconGlow(scale: self.mainScaleAfter))
    }
  }
  
  func displayOptions () {
    self.runAction(SoundSourceHelper.soundPut(name: gameController.mainObject.name))
    self.descriptionLabel.hidden = false
    
    for node in firstNodeList {
      self.addChild(node)
    }
    
    for node in secondNodeList {
      self.addChild(node)
    }
  }
  
  func transitionToReviewScene () {
    
    
    self.gameViewController?.presentReviewScene()
  }
  
  func correctSelection () {
    
    if !self.selectionRegistered && statisticsTrack.validate {
      self.selectionRegistered = true
      UserPerformanceHelper.update(name: gameController.mainObject.name, correct: true)
      
      statisticsTrack.setTimeEnd(NSDate(timeIntervalSinceNow: 0))
      statisticsTrack.setCorrect(true)
      statisticsTrack.logEvent()
    }

    
    transitionToReviewScene()
  }
  
  func wrongSelection () {
    
    resetReminder()
    
    if !self.selectionRegistered && statisticsTrack.validate {
      self.selectionRegistered = true
      UserPerformanceHelper.update(name: gameController.mainObject.name, correct: false)
      
      statisticsTrack.setTimeEnd(NSDate(timeIntervalSinceNow: 0))
      statisticsTrack.setCorrect(false)
      statisticsTrack.logEvent()
    }
    
    wrongCounter++
    if wrongCounter<3 {
      self.runAction(SoundSourceHelper.soundTryAgain(1)) {
        [unowned self] in
        self.toddlerLock = false
      }
      return
    } else if wrongCounter == 3 {
      for node in wrongNodeList {
        node.runAction(ActionHelper.fadeHalfAway())
      }
      var node = SKNode()
      self.addChild(node)
      node.runAction(SKAction.waitForDuration(30)) {
        [unowned self] in
        self.gameViewController?.presentGameScene(newScene: true)
      }
    }
    
    self.runAction(SoundSourceHelper.soundPut(name: self.gameController.mainObject.name)) {
      [unowned self] in
      self.toddlerLock = false
    }
  }
  
  /* touch control */
//  func preventTouching () {
//    self.topMask.zPosition = GameViewController.Layers.Top.rawValue
//  }
//  
//  func allowTouching () {
//    self.topMask.zPosition = GameViewController.Layers.Bottom.rawValue
//  }
  
}
