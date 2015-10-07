//
//  TutorialScene.swift
//  Vocabulary Assessment Tool
//
//  Created by Tongtong Wu on 9/11/15.
//  Copyright (c) 2015 Cognitive ToyBox. All rights reserved.
//


import SpriteKit

/* display the main game logic */
class TutorialScene: SKScene, ConfigurableScene {
  
  //==========================================
  // enums
  //==========================================
  private enum State:Int {
    case Initial=0, MainDisplayed, MainInTransfer, OptionsDisplayed, WaitingForTap
  }
  
  // hard code
  private let h_correctIndex = [0,1]
  
  // constants
  let versionNum = Int(UIDevice.currentDevice().systemVersion.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "."))[0])
  let labelFontSize   :CGFloat = 60
  let mainScaleBefore :CGFloat = 2
  let mainScaleAfter  :CGFloat = 0.7
  let normalScale     :CGFloat = 0.85
  
  let descriptionLabel1  = SKLabelNode(fontNamed: GlobalConfiguration.labelFont)
  let descriptionLabel2  = SKLabelNode(fontNamed: GlobalConfiguration.labelFont)
  
  let touchAreaLength : CGFloat = 240
  
  // private member variables
  private var round:Int        = 0
  
  private var toddlerLock:Bool = false
  
  /* special treatment for toddlers on touching! */
  private var touchedCorrectObject  = false
  private var touchedWrongObject    = false
  
  /* prevent from touching */
  private var topMask : SKNode! = nil
  
  private var optionNodeList: [SKSpriteNode]      = []
  private var cacheOptionNodeList: [SKSpriteNode] = []
  
  /* frame size and position */
  private var initFrame     : CGRect! = nil
  private var optionsFrame  : CGRect! = nil
  private var correctFrame  : CGRect! = nil
  private var wrongFrameList: [CGRect] = []
  
  // shared member variables
  weak var tutorialViewController: TutorialViewController? = nil
  var correctIndex  : Int                           = 0
  var background    : SKSpriteNode!                 = nil
  var objectList    : [CognitiveToyBoxObject]       = []
  
  // properties
  var correctNode: SKSpriteNode! {
    get {
      if optionNodeList.isEmpty {
        return nil
      }
      return optionNodeList[correctIndex]
    }
  }
  
  
  
  
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
    NSLog("Deinit TutorialScene")
  }
  
  override func didMoveToView(view: SKView) {
    
    SoundSourceHelper.stopBGM()
    
    resetScene()
 
    self.initScene()
    
    self.initLabels()
    
    // masks

    if #available(iOS 8.0, *) {
      self.topMask = SKShapeNode(rect: self.frame)
      
    } else {
      self.topMask = SKSpriteNode(color: UIColor(white: 0, alpha: 1), size: self.frame.size)
      self.topMask.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
      // Fallback on earlier versions
    }
    
    
    self.topMask.hidden = true
    
    self.resetMask()
    
    self.addChild(self.topMask)
    
    self.initFrame = self.frame
    
    //        if gameController.task == .Vocabulary {
    self.optionsFrame = self.frame
    //        } else {
    //            self.optionsFrame = CGRectOffset(CGRectInset(self.frame, 0, offset), 0, -offset)
    //        }
    //    }
    
    self.initOptions()
    self.initFrames()
    self.initLayers()
    
    
    // display
    self.displayOptions()
  }
  
  
  
  
  
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
      toddlerLock = true
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
      
      var isInWrongFrame = false
      for wrongFrame in wrongFrameList {
        if CGRectContainsPoint(wrongFrame, location) {
          isInWrongFrame = true
          break
        }
      }
      
      if node != topMask && CGRectContainsPoint(correctFrame, location) {
        //      if node === self.correctNode {
        
        touchedCorrectObject = true
        
        // Start toddler special treatment!
        self.runAction(ActionHelper.touchDelay()) {
          [unowned self] () -> () in
          self.toddlerTouch()
        }
        
      } else if node != topMask && isInWrongFrame {
        
        // wrong once, wrong at all
        
        touchedWrongObject = true
        
        // Start toddler special treatment!
        self.runAction(ActionHelper.touchDelay()) {
          [unowned self] () -> () in
          self.toddlerTouch()
        }
        
        break
      }
    }
  }

  override func touchesBegan (touches: Set<UITouch>, withEvent event: UIEvent?) {
    
    handleTouch(touches, withEvent: event)
    
  }
  
  /* initialize */
  func initScene () {
    
    self.background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
    self.background.zPosition = GameViewController.Layers.Bottom.rawValue
    
    var border = SKSpriteNode(imageNamed: "border")
    border.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
    border.zPosition = GameViewController.Layers.Bottom.rawValue
    
    
    self.addChild(self.background)
    self.addChild(border)
    
  }
  
  /* initialize labels */
  func initLabels () {
    self.descriptionLabel1.fontSize = self.labelFontSize
    self.descriptionLabel1.fontColor = UIColor(white: CGFloat(0), alpha: CGFloat(1))
    self.descriptionLabel1.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame) + frame.height / 3)
    
    self.descriptionLabel2.fontSize = self.labelFontSize
    self.descriptionLabel2.fontColor = UIColor(white: CGFloat(0), alpha: CGFloat(1))
    self.descriptionLabel2.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame) + frame.height / 4)
    
    self.addChild(self.descriptionLabel1)
    self.addChild(self.descriptionLabel2)
  }
  
  /* initialize GameViewController.Layers */
  func initLayers () {
    self.descriptionLabel1.zPosition = GameViewController.Layers.Label.rawValue
    self.descriptionLabel2.zPosition = GameViewController.Layers.Label.rawValue
    self.topMask.zPosition = GameViewController.Layers.Top.rawValue
    
    for node in optionNodeList {
      node.zPosition = GameViewController.Layers.AboveMask.rawValue
    }
  }

  
  /* initialize options */
  func initOptions () {
    
    // init scene
    let frame = self.initFrame
    var index = 0
    
    for object in self.objectList {
      var node = SKSpriteNode(texture: SKTexture(imageNamed: object.description))
      node.position = VocabularyScene.optionLocation(frame: optionsFrame, index: index)
      node.xScale = normalScale
      node.yScale = normalScale
      
      optionNodeList.append(node)
      
      index++
    }
    
    
    
  }
  
  func initFrames ()
  {
    correctFrame = CGRect(origin: CGPointApplyAffineTransform(optionNodeList[correctIndex].position, CGAffineTransformMakeTranslation(-touchAreaLength/2, -touchAreaLength/2)) , size: CGSize(width: touchAreaLength, height: touchAreaLength))
    
    for i in 0..<optionNodeList.count {
      if i == correctIndex {
        continue
      }
      
      var wrongFrame = CGRect(origin: CGPointApplyAffineTransform(optionNodeList[i].position, CGAffineTransformMakeTranslation(-touchAreaLength/2, -touchAreaLength/2)) , size: CGSize(width: touchAreaLength, height: touchAreaLength))
      wrongFrameList.append(wrongFrame)
    }
  }
  
  func initCache () {
    let frame = self.initFrame
    var index = 0
    
    
    for object in self.objectList {
      var node = SKSpriteNode(texture: SKTexture(imageNamed: object.description))
      node.position = VocabularyScene.optionLocation(frame: optionsFrame, index: index)
      node.xScale = normalScale
      node.yScale = normalScale
      
      cacheOptionNodeList.append(node)
      
      index++
    }
    
    for node in cacheOptionNodeList {
      node.zPosition = GameViewController.Layers.AboveMask.rawValue
    }
    
    
    correctFrame = CGRect(origin: CGPointApplyAffineTransform(cacheOptionNodeList[correctIndex].position, CGAffineTransformMakeTranslation(-touchAreaLength/2, -touchAreaLength/2)) , size: CGSize(width: touchAreaLength, height: touchAreaLength))
    
    for i in 0..<cacheOptionNodeList.count {
      if i == correctIndex {
        continue
      }
      
      var wrongFrame = CGRect(origin: CGPointApplyAffineTransform(cacheOptionNodeList[i].position, CGAffineTransformMakeTranslation(-touchAreaLength/2, -touchAreaLength/2)) , size: CGSize(width: touchAreaLength, height: touchAreaLength))
      wrongFrameList.append(wrongFrame)
    }
    
  }
  
  
  /* display options and label */
  func displayOptions () {
    descriptionLabel1.text = "In this game, I’m going to tell you to pick one."
    descriptionLabel2.text = "Put your finger on the chair "
    for node in optionNodeList {
      self.addChild(node)
    }
    
    self.allowTouching()
    // play sound effect
    self.runAction(SoundSourceHelper.soundFind(name: objectList[correctIndex].name))
    self.emphasizeOptions() {
      [unowned self] () -> () in
      
    }
    
  }
  
  func displayCache () {
    
    
    for node in cacheOptionNodeList {
      self.addChild(node)
    }
    
    self.allowTouching()
    // play sound effect
    self.runAction(SoundSourceHelper.soundFind(name: objectList[correctIndex].name))
    self.emphasizeOptions() {
      [unowned self] () -> () in
      
    }
    
  }
  
  func emphasizeOptions (completion: (() -> ()) = {}) {
    self.optionNodeList[0].runAction(ActionHelper.presentObject(), completion: completion)
    
    for i in 1..<optionNodeList.count {
      self.optionNodeList[i].runAction(ActionHelper.presentObject())
    }
    
  }
  
  
  
  func correctSelection () {
    
    self.preventTouching()
    
    self.objectFound()
    
    self.runAction(ActionHelper.maskDelay()) {
      [unowned self] () -> () in
      self.resetMask(false)
      self.toddlerLock = false
    }
  }
  
  
  func wrongSelection () {
    
//    self.preventTouching()
//    
//    self.objectFound()
    
    self.runAction(ActionHelper.maskDelay()) {
      [unowned self] () -> () in
      self.resetMask(false)
      self.toddlerLock = false
    }
  }
  
  func objectFound () {
    
    self.runAction(SoundSourceHelper.soundBlop()) {
      [unowned self] () -> () in
      self.nextRound()
      self.allowTouching()
    }
    
  }
  
  func nextRound()
  {
    ++round
    descriptionLabel1.text = "Now let’s do the next one. "
    descriptionLabel2.text = "Please put your finger on the ball!"
    
    if (round >= h_correctIndex.count)
    {
      self.tutorialViewController?.isFinished = true
      self.tutorialViewController?.performSegueWithIdentifier("startGameSegue", sender: self)

//      self.tutorialViewController?.dismissViewControllerAnimated(false) {
//        
//      }
      self.removeFromParent()
      
    } else {
      self.resetScene()
      
    }
    
    
  }
  
  func resetScene()
  {
    correctIndex = h_correctIndex[round]
    // set label
    // set mask
    // set frame
    if (!self.optionNodeList.isEmpty)
    {
      initFrames()
    }
    
  }
  
  func resetMask (allowTouching:Bool = true) {
    
    
    for node in optionNodeList {
      node.zPosition = GameViewController.Layers.AboveMask.rawValue
    }

    
    if allowTouching {
      self.allowTouching()
    }
  }
  
  func playFlipAnimation(){
    let firstHalfFlip = SKAction.scaleXTo(0.0, duration: 0.4)
    let secondHalfFlip = SKAction.scaleXTo(1.0, duration: 0.4)
    
    for index in 0..<self.optionNodeList.count {
      let node = self.optionNodeList[index]
      let newNode = self.cacheOptionNodeList[index]
      
      node.runAction(firstHalfFlip) {
        [unowned self] in
        node.removeFromParent()
        newNode.xScale = 0
        self.addChild(newNode)
        
        newNode.runAction(secondHalfFlip) {
          [unowned self] in
          self.allowTouching()
          self.toddlerLock = false
        }
      }
      
    }
    
    self.optionNodeList.removeAll(keepCapacity: true)
    self.optionNodeList.appendContentsOf(self.cacheOptionNodeList)
    self.cacheOptionNodeList.removeAll(keepCapacity: true)
    
    
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
    
  }
  
  func zoomOut (duration: NSTimeInterval = 0) {
    self.background.runAction(SKAction.scaleTo(1, duration: duration))
  }
  
  class func optionLocation (frame frame : CGRect, index:Int) -> CGPoint {
    let orientation = UIApplication.sharedApplication().statusBarOrientation
    
    if orientation == UIInterfaceOrientation.Portrait || orientation == UIInterfaceOrientation.PortraitUpsideDown {
      
      return CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame) + frame.height * CGFloat(1-index) / 3)
    }
    else {

      if index%2 == 0{
        
        return CGPointMake(CGRectGetMidX(frame) - frame.width/6 - frame.width/8 , CGRectGetMidY(frame) + frame.height * CGFloat(index-1)/6 - frame.height/8)

      }else {
        return CGPointMake(CGRectGetMidX(frame) + frame.width/6 - frame.width/8 , CGRectGetMidY(frame) + frame.height * CGFloat(index-2)/6 - frame.height/8)

      }
      
    }
    
  }
  
}