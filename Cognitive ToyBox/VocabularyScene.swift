//
//  Vocabulary.swift
//  Blicket
//
//  Created by Tongtong Wu on 7/7/15.
//  Copyright (c) 2015 Cognitive ToyBox. All rights reserved.
//

//
//  SomeScene.swift
//  Blicket
//
//  Created by Heng Lyu on 5/21/15.
//  Copyright (c) 2015 Cognitive ToyBox. All rights reserved.
//

import SpriteKit

/* display the main game logic */
class VocabularyScene: SKScene, ConfigurableScene {
    
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
    var cacheObjectName = ""
    
    var background : SKSpriteNode! = nil
    let isBlurred = true
    
    let mainScaleBefore :CGFloat = 2
    let mainScaleAfter  :CGFloat = 0.7
    let normalScale     :CGFloat = 0.85
    
    let descriptionLabel  = SKLabelNode(fontNamed: GlobalConfiguration.labelFont)
//    let questionLabel     = SKLabelNode(fontNamed: GlobalConfiguration.labelFont)
    let wrongLabel        = SKLabelNode(fontNamed: GlobalConfiguration.labelFont)
    let foundLabel        = SKLabelNode(fontNamed: GlobalConfiguration.labelFont)
  
    var soundPlayButton :SKSpriteNode! = nil
 
  
//    let cacheDescriptionLabel = SKLabelNode(fontNamed: GlobalConfiguration.labelFont)
//    let cacheQuestionLabel = SKLabelNode(fontNamed: GlobalConfiguration.labelFont)
//    let cacheWrongLabel = SKLabelNode(fontNamed: GlobalConfiguration.labelFont)
//    let cacheFoundLabel = SKLabelNode(fontNamed: GlobalConfiguration.labelFont)
    var border : SKSpriteNode! = nil
    var mainObjectNode: SKSpriteNode! = nil
    var secondaryMainNode: SKSpriteNode! = nil
    var objectList: [CognitiveToyBoxObject] = []
    var secondaryMainIndex: Int = 0
    
    var optionNodeList: [SKSpriteNode] = []
    var optionGlowList: [SKSpriteNode] = []
  
    var cacheMainObjectNode: SKSpriteNode! = nil
    var cacheOptionNodeList: [SKSpriteNode] = []
  
    //  var firstOptionNode: SKSpriteNode! = nil
    //  var secondOptionNode: SKSpriteNode! = nil
    //  var thirdOptionNode: SKSpriteNode! = nil
    
    var mainGlow: SKSpriteNode! = nil
    //  var firstOptionGlow: SKSpriteNode! = nil
    //  var secondOptionGlow: SKSpriteNode! = nil
    //  var thirdOptionGlow: SKSpriteNode! = nil
    
    //  var correctNode : SKSpriteNode! = nil
    //  var wrongNodeList : [SKSpriteNode] = []
    
    /* prevent from touching */
    var topMask : SKNode! = nil
    var colorMask : SKNode! = nil
    
    /* frame size and position */
    var initFrame : CGRect! = nil
    var mainFrame : CGRect! = nil
    var secondaryMainFrame : CGRect! = nil
    var optionsFrame : CGRect! = nil
    var correctFrame: CGRect! = nil
    var wrongFrameList: [CGRect] = []
    let touchAreaLength: CGFloat = 240
    
    /* reminder */
    private var reminder: SKNode = SKNode()
    
    /* wrong time counter */
    private var wrongCounter: Int = 0
    
    /* special treatment for toddlers on touching! */
    private var touchedCorrectObject = false
    private var touchedWrongObject = false
    
    var correctNode: SKSpriteNode! {
        get {
            if optionNodeList.isEmpty || gameController == nil {
                return nil
            }
            return optionNodeList[gameController.correctIndex]
        }
    }
    
    
    /* track statistics */
    var statisticsTrack = StatisticsTrackHelper()
    
    /* projection from touchIndex to node */
    var draggingList = [CGPoint: SKSpriteNode] ()
    
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
        NSLog("Deinit VocabularyScene")
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
        
//        if gameController.task == .Vocabulary {
            self.optionsFrame = self.frame
//        } else {
//            self.optionsFrame = CGRectOffset(CGRectInset(self.frame, 0, offset), 0, -offset)
//        }
        //    }
        
        self.initMain()
        self.initOptions()
        
        self.initLayers()

        
        // show scene
        // ActionHelper returns an SKAction object
        self.runAction(ActionHelper.displayMain()) {  // wait a short time before display main object
            [unowned self] () -> () in
//            if self.gameController.task == .Vocabulary {
                self.displayOptions()
                self.emphasizeOptions() {
                    [unowned self] () -> () in
                    self.showGlow()
                    self.allowTouching()
                }
//            } else {
//                self.displayMain()
//            }
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
            
            if state.rawValue>=State.OptionsDisplayed.rawValue && node != topMask && CGRectContainsPoint(correctFrame, location) {
                //      if node === self.correctNode {
                
                touchedCorrectObject = true
                
                // Start toddler special treatment!
                self.runAction(ActionHelper.touchDelay()) {
                    [unowned self] () -> () in
                    self.toddlerTouch()
                }
                
            } else if state.rawValue>=State.OptionsDisplayed.rawValue && node != topMask && isInWrongFrame {
                
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
          if CGRectContainsPoint(soundPlayButton.frame, location){

            self.runAction(SoundSourceHelper.soundFindObject(name: gameController.getMainObj().name))
          }
          
            
            if node.alpha != 1 {
                continue
            }
            
            if !(node is SKSpriteNode) {
                continue
            }
            
            spriteNode = (node === mainObjectNode || node === correctNode || optionNodeList.contains(node as! SKSpriteNode)) ? (node as! SKSpriteNode) : nil
            
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
        
        
        
    }
    
    func resetDrag () {
        let duration:NSTimeInterval = 0.2
        
        if let main = self.mainObjectNode {
            main.runAction(SKAction.group([SKAction.moveTo(CGPointMake(CGRectGetMidX(self.mainFrame), CGRectGetMidY(self.mainFrame)), duration: duration), SKAction.rotateToAngle(0, duration: duration)]))
        }
        
        if let secondary = self.secondaryMainNode {
            secondary.runAction(SKAction.group([SKAction.moveTo(CGPointMake(CGRectGetMidX(self.secondaryMainFrame), CGRectGetMidY(self.secondaryMainFrame)), duration: duration), SKAction.rotateToAngle(0, duration: duration)]))
        }
        
        var index = 0
        for node in optionNodeList {
            node.position = VocabularyScene.optionLocation(frame: optionsFrame, index: index)
            index++
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
    
    self.objectList = self.gameController.getListWithSameName().filter() {
      [unowned self] (object:CognitiveToyBoxObject) -> Bool in
      !object.equals(self.gameController.getMainObj()) && !object.equals(self.gameController.getCorrectObj())
    }
    
    
    if self.objectList.isEmpty {
      objectList.append(self.gameController.mainObject)
    }
    
    // refresh main
    self.objectName = self.gameController.getMainObj().name
    self.descriptionLabel.text = "\(objectName)"
    //        self.questionLabel.text = "\(objectName)"
    
    let labelWidth = self.descriptionLabel.frame.width
    var labelHeight =  self.descriptionLabel.frame.height
//    var size = self.soundPlayButton.size
    
    self.soundPlayButton.size.width = 1.2*labelWidth
    self.soundPlayButton.yScale = 1.2

    
    self.wrongLabel.text = "That's not \(objectName)!"
    self.runAction(ActionHelper.waitForMainObjectSound ()){
        self.runAction(SoundSourceHelper.soundFindObject(name: self.gameController.getMainObj().name))
    }
    
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
        statisticsTrack.setObject4(self.gameController.options[2].first!)
        
//        if gameController.task == .Vocabulary {
            self.foundLabel.text = "\(objectName)!"
            statisticsTrack.setTaskType("Vocabulary")
//        } else {
//            self.foundLabel.text = "Some \(objectName)!"
//            statisticsTrack.setTaskType("Shape Bias")
//        }
    }
  
  //prepare the next group of objects
  func loadNextGroup(){
    
    var success = self.gameController.startNewSession(true)
    
    if success {
      // change label text
      
      self.objectName = self.gameController.getMainObj().name
      self.descriptionLabel.text = "\(objectName)"
//      self.questionLabel.text = "\(objectName)"
      
      var labelWidth = self.descriptionLabel.frame.width
      var labelHeight =  self.descriptionLabel.frame.height
//      var size = self.soundPlayButton.size
      
      self.soundPlayButton.size.width = 1.2*labelWidth
      self.soundPlayButton.yScale = 1.2
      
//      if #available(iOS 8.0, *) {
//        self.soundPlayButton = SKShapeNode(rect: CGRect(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame)+frame.height/3, width: labelWidth, height:labelHeight), cornerRadius: 10.0)
//        
//        self.addChild(self.soundPlayButton)
//        
//      } else {
//        // Fallback on earlier versions
//        self.soundPlayButton = SKShapeNode(rect: CGRect(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame)+frame.height/3, width: labelWidth, height:labelHeight), cornerRadius: 10.0)
//        
//        self.addChild(self.soundPlayButton)
//      }
      
      self.initCache()
      self.playFlipAnimation()
      self.runAction(ActionHelper.waitForMainObjectFlipSound ()){
        self.runAction(SoundSourceHelper.soundFindObject(name: self.gameController.getMainObj().name))
      }
      
    }else {
      self.gameViewController?.isFinished = true
      self.gameViewController!.performSegueWithIdentifier("finalAnalysis", sender: self)

    }
    
//    // refresh main
//    self.cacheObjectName = self.gameController.getMainObj().name
//    self.cacheDescriptionLabel.text = "\(objectName)"
//    self.cacheQuestionLabel.text = "\(objectName)"
//    
//    self.cacheWrongLabel.text = "That's not \(objectName)!"
//    

  }
  
    /* initialize labels */
    func initLabels () {
        self.descriptionLabel.fontSize = self.labelFontSize
        self.descriptionLabel.fontColor = UIColor(white: CGFloat(0), alpha: CGFloat(1))
        self.soundPlayButton = SKSpriteNode(texture: SKTexture(imageNamed:"soundPlayButton"))
        self.soundPlayButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + self.size.height*0.35)
//        self.questionLabel.fontSize = self.labelFontSize
//        self.questionLabel.fontColor = UIColor(white: CGFloat(0), alpha: CGFloat(1))
      
        self.wrongLabel.fontSize = self.labelFontSize
        self.wrongLabel.fontColor = UIColor(white: CGFloat(0), alpha: CGFloat(1))
        self.wrongLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - self.size.height/3)
        self.wrongLabel.alpha = 0
        
        
        self.foundLabel.fontSize = self.labelFontSize
        self.foundLabel.fontColor = UIColor(white: CGFloat(0), alpha: CGFloat(1))
        self.foundLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + self.size.height/3)
        self.foundLabel.hidden = true
        
        self.addChild(self.descriptionLabel)
//        self.addChild(self.questionLabel)
        self.addChild(self.foundLabel)
        self.addChild(self.wrongLabel)
        self.addChild(self.soundPlayButton)
    }
    
    /* initialize GameViewController.Layers */
    func initLayers () {
        self.descriptionLabel.zPosition = GameViewController.Layers.Label.rawValue
//        self.questionLabel.zPosition = GameViewController.Layers.Label.rawValue
        self.wrongLabel.zPosition = GameViewController.Layers.Label.rawValue
        self.foundLabel.zPosition = GameViewController.Layers.Label.rawValue
        self.colorMask.zPosition = GameViewController.Layers.Mask.rawValue
        self.topMask.zPosition = GameViewController.Layers.Top.rawValue
        self.mainObjectNode.zPosition = GameViewController.Layers.AboveMask.rawValue
        self.soundPlayButton.zPosition = GameViewController.Layers.BelowLabel.rawValue
        
        //    self.firstOptionNode.zPosition = GameViewController.Layers.AboveMask.rawValue
        //    self.secondOptionNode.zPosition = GameViewController.Layers.AboveMask.rawValue
        //    self.firstOptionGlow.zPosition = GameViewController.Layers.BearArm.rawValue
        //    self.secondOptionGlow.zPosition = GameViewController.Layers.BearArm.rawValue
        for node in optionNodeList {
            node.zPosition = GameViewController.Layers.AboveMask.rawValue
        }
        for node in optionGlowList {
            node.zPosition = GameViewController.Layers.BearArm.rawValue
        }
        
        self.mainGlow.zPosition = GameViewController.Layers.BearArm.rawValue
    }
    
    
    /* initialize main object and label */
    func initMain () {
        
        let imageFileName = self.gameController.getMainObj().description
        let scale = self.mainScaleBefore
        let frame = self.initFrame
        
        // draw label
        
        self.descriptionLabel.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame) + frame.height / 3)
        
        //    var mainTextureAtlas = SKTextureAtlas(named: self.gameController.getMainObj().name)
        self.mainObjectNode = SKSpriteNode(texture: SKTexture(imageNamed: imageFileName))
        self.mainObjectNode.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame) - 0)
        self.mainObjectNode.xScale = scale
        self.mainObjectNode.yScale = scale
        
        /* main glow */
        //    self.mainGlow = SKSpriteNode(texture: mainTextureAtlas.textureNamed(gameController.getMainObj().glowName))
        self.mainGlow = SKSpriteNode(imageNamed: "glow")
        self.mainGlow.position = self.mainObjectNode.position
        
        
        // wait for display
//        self.descriptionLabel.hidden = true
    }
    
    /* display main object and label */
    func displayMain () {
//        self.descriptionLabel.hidden = false
      
        _ = SKNode()
        
        self.addChild(self.mainObjectNode)
        
        self.state = .MainDisplayed
        
        // play sound effect
        self.runAction(SoundSourceHelper.soundIdentify(name: objectName))
        
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
//        self.descriptionLabel.hidden = true
      
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
//        self.descriptionLabel.hidden = true
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
                self.optionNodeList[self.gameController.correctIndex].runAction(ActionHelper.presentObject()) {
                    [unowned self] in
                    self.runAction(SoundSourceHelper.soundTap(name: self.objectName))
                }
                return
            }
            
            /* wiggle main */
//            self.descriptionLabel.hidden = false
//            self.questionLabel.hidden = true
            self.runAction(SoundSourceHelper.soundIdentify(name: self.objectName))
            self.mainObjectNode.runAction(ActionHelper.presentObject()) {
                [unowned self] () -> () in
                self.runAction(SoundSourceHelper.soundFind(name: self.objectName))
//                self.descriptionLabel.hidden = true
//                self.questionLabel.hidden = false
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
        let frame = self.initFrame
        var index = 0
        
        // draw label
      self.descriptionLabel.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame) + frame.height / 3)
//        self.questionLabel.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame) + frame.height / 3)
      
        for option in self.gameController.options {
            var object = option.first!
            //      var atlas = SKTextureAtlas(named: object.name)
            var node = SKSpriteNode(texture: SKTexture(imageNamed: object.description))
            node.position = VocabularyScene.optionLocation(frame: optionsFrame, index: index)
            node.xScale = normalScale
            node.yScale = normalScale
            
            var glow = SKSpriteNode(imageNamed: "glow")
            glow.position = node.position
            glow.hidden = true
            
            optionNodeList.append(node)
            optionGlowList.append(glow)
            
            index++
        }
        
        for glow in optionGlowList {
            glow.runAction(ActionHelper.beaconGlow())
        }
        
        // wait for display
//        self.questionLabel.hidden = true
      
        adjustOptionsPosition()
        
        correctFrame = CGRect(origin: CGPointApplyAffineTransform(optionNodeList[gameController.correctIndex].position, CGAffineTransformMakeTranslation(-touchAreaLength/2, -touchAreaLength/2)) , size: CGSize(width: touchAreaLength, height: touchAreaLength))
        
        for i in 0..<optionNodeList.count {
            if i == gameController.correctIndex {
                continue
            }
            
            var wrongFrame = CGRect(origin: CGPointApplyAffineTransform(optionNodeList[i].position, CGAffineTransformMakeTranslation(-touchAreaLength/2, -touchAreaLength/2)) , size: CGSize(width: touchAreaLength, height: touchAreaLength))
            wrongFrameList.append(wrongFrame)
        }
        
    }
  
  func initCache () {
    let frame = self.initFrame
    var index = 0
    
    
    
    for option in self.gameController.options {
      var object = option.first!
      //      var atlas = SKTextureAtlas(named: object.name)
      var node = SKSpriteNode(texture: SKTexture(imageNamed: object.description))
      node.position = VocabularyScene.optionLocation(frame: optionsFrame, index: index)
      node.xScale = normalScale
      node.yScale = normalScale
      
      var glow = SKSpriteNode(imageNamed: "glow")
      glow.position = node.position
      glow.hidden = true
      
      cacheOptionNodeList.append(node)
      
      index++
    }
    
    for node in cacheOptionNodeList {
      node.zPosition = GameViewController.Layers.AboveMask.rawValue
    }
    
    adjustOptionsPosition()
    
    correctFrame = CGRect(origin: CGPointApplyAffineTransform(cacheOptionNodeList[gameController.correctIndex].position, CGAffineTransformMakeTranslation(-touchAreaLength/2, -touchAreaLength/2)) , size: CGSize(width: touchAreaLength, height: touchAreaLength))
    
    for i in 0..<cacheOptionNodeList.count {
      if i == gameController.correctIndex {
        continue
      }
      
      var wrongFrame = CGRect(origin: CGPointApplyAffineTransform(cacheOptionNodeList[i].position, CGAffineTransformMakeTranslation(-touchAreaLength/2, -touchAreaLength/2)) , size: CGSize(width: touchAreaLength, height: touchAreaLength))
      wrongFrameList.append(wrongFrame)
    }
    
  }
  
  
  
    /* make sure objects look comfortable.  */
    func adjustOptionsPosition () {
        //    var position1 = firstOptionNode.position
        //    var position2 = secondOptionNode.position
        //    let width1 = firstOptionNode.frame.width
        //    let width2 = secondOptionNode.frame.width
        //
        //    let minInterval:CGFloat = 100
        //
        //    var orientation = UIApplication.sharedApplication().statusBarOrientation
        //
        //    if orientation == UIInterfaceOrientation.Portrait || orientation == UIInterfaceOrientation.PortraitUpsideDown {
        //    } else {
        //      var dx = (position2.x - width2/2) - (position1.x + width1/2)
        //      if dx < minInterval {
        //        let x1 = position1.x - (minInterval - dx)/2
        //        let x2 = position2.x + (minInterval - dx)/2
        //        firstOptionNode.position.x = x1
        //        firstOptionGlow.position.x = x1
        //        secondOptionNode.position.x = x2
        //        secondOptionNode.position.x = x2
        //      }
        //    }
    }
    
    /* display options and label */
    func displayOptions () {
        self.colorMask.hidden = false
//        self.questionLabel.hidden = false
      
        self.addChild(self.colorMask)
        //    self.addChild(self.firstOptionNode)
        //    self.addChild(self.secondOptionNode)

        //    self.addChild(self.firstOptionGlow)
        //    self.addChild(self.secondOptionGlow)
      
        for node in optionNodeList {
            self.addChild(node)
        }
      
//        for glow in optionGlowList {
//            self.addChild(glow)
//        }
      
        
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
  
  func displayCache () {
    self.colorMask.hidden = false
//    self.questionLabel.hidden = false
    
    self.addChild(self.colorMask)
 
    
    for node in cacheOptionNodeList {
      self.addChild(node)
    }
    
    //        for glow in optionGlowList {
    //            self.addChild(glow)
    //        }
    
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
        self.optionNodeList[0].runAction(ActionHelper.presentObject()) {
            [unowned self] () -> () in
            /* Or is it this one? */
            self.optionNodeList[1].runAction(ActionHelper.presentObject()) {
                [unowned self] () -> () in
                /* Or is it this one? */
                self.optionNodeList[2].runAction(ActionHelper.presentObject()) {
                    [unowned self] () -> () in
                    self.showGlow()
                    self.resetReminder()
                }
                self.runAction(SoundSourceHelper.soundSecondOne())
            }
            self.runAction(SoundSourceHelper.soundFirstOne())
        }
        self.runAction(SoundSourceHelper.soundFirstOne())
    }
    
    func emphasizeOptions (completion: (() -> ()) = {}) {
        self.optionNodeList[0].runAction(ActionHelper.presentObject(), completion: completion)
        
        for i in 1..<optionNodeList.count {
            self.optionNodeList[i].runAction(ActionHelper.presentObject())
        }
        
    }
    
    func showGlow () {
        for glow in optionGlowList {
            glow.hidden = false
        }
    }
    
    

  func correctSelection () {
    
    self.preventTouching()
    
    if !self.selectionRegistered && statisticsTrack.validate {
      self.selectionRegistered = true
      UserPerformanceHelper.update(name: objectName, correct: true)
      
      statisticsTrack.setTimeEnd(NSDate(timeIntervalSinceNow: 0))
      statisticsTrack.setCorrect(true)
      statisticsTrack.logEvent()
    }
    
//    self.changeMaskColor(UIColor(red: 0, green: 1, blue: 0, alpha: 0.5))
    self.mainObjectNode.zPosition = GameViewController.Layers.AboveMask.rawValue
    
//    for glow in optionGlowList {
//      glow.hidden = true
//    }

    
//    self.questionLabel.hidden = true
    
//    if self.secondaryMainNode != nil {
//      self.secondaryMainNode.runAction(SKAction.repeatActionForever(ActionHelper.presentObject()))
//      self.secondaryMainNode.zPosition = GameViewController.Layers.AboveMask.rawValue
//    }
    
    self.objectFound()
  }

  
  func wrongSelection () {
    
    self.preventTouching()
    
    if !self.selectionRegistered && statisticsTrack.validate {
      self.selectionRegistered = true
      UserPerformanceHelper.update(name: objectName, correct: false)
      
      statisticsTrack.setTimeEnd(NSDate(timeIntervalSinceNow: 0))
      statisticsTrack.setCorrect(false)
      statisticsTrack.logEvent()
    }
    
//    self.changeMaskColor(UIColor(red: 1, green: 1, blue: 0, alpha: 0.5))
//    let the main object float on top of the green mask
    self.mainObjectNode.zPosition = GameViewController.Layers.AboveMask.rawValue
    
//    for glow in optionGlowList {
//      glow.hidden = true
//    }
    
    //    self.firstOptionGlow.hidden = true
    //    self.secondOptionGlow.hidden = true
    
//    self.questionLabel.hidden = true
    
//    if self.secondaryMainNode != nil {
//      self.secondaryMainNode.runAction(SKAction.repeatActionForever(ActionHelper.presentObject()))
//      self.secondaryMainNode.zPosition = GameViewController.Layers.AboveMask.rawValue
//    }
    
    self.objectFound()
  }
  
    func objectFound () {
        
//        for i in 0..<self.optionNodeList.count {
//            if i == self.gameController.correctIndex {
//                continue
//            }
//            
//            self.optionNodeList[i].runAction(ActionHelper.appearAndFadeAway())
//        }
//            self.wrongNode.runAction(ActionHelper.appearAndFadeAway())
        self.selectionRegistered = false
        self.runAction(SoundSourceHelper.soundBlop()) {
            [unowned self] () -> () in
//            self.transitionToReviewScene()
          self.gameViewController?.updateProgressBar()
//          self.transitionToWelcomeScene ()
          
          self.loadNextGroup()

        }
      
    }
  
    func transitionToReviewScene () {
      
      self.gameViewController?.presentReviewScene()
    }
  
    func transitionToWelcomeScene () {

      self.gameViewController?.presentWelcomeScene()
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
        
        
        for node in optionNodeList {
            node.zPosition = GameViewController.Layers.AboveMask.rawValue
        }
        //    if firstOptionNode != nil {
        //      self.firstOptionNode.zPosition = GameViewController.Layers.AboveMask.rawValue
        //    }
        //    
        //    if secondOptionNode != nil {
        //      self.secondOptionNode.zPosition = GameViewController.Layers.AboveMask.rawValue
        //    }
        //    
        //    if firstOptionGlow != nil {
        //      //      self.firstOptionGlow.hidden = false
        //      //      self.firstOptionGlow.runAction(ActionHelper.beaconGlow())
        //    }
        //    
        //    if secondOptionGlow != nil {
        //      //      self.secondOptionGlow.hidden = false
        //      //      self.secondOptionGlow.runAction(ActionHelper.beaconGlow())
        //    }
        
        if allowTouching {
            self.allowTouching()
        }
    }

  func playFlipAnimation(){
    let firstHalfFlip = SKAction.scaleXTo(0.0, duration: 0.4)
    let secondHalfFlip = SKAction.scaleXTo(1.0, duration: 0.4)
    
    for index in 0..<self.optionNodeList.count {
      var node = self.optionNodeList[index]
      var newNode = self.cacheOptionNodeList[index]
      
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
  
  /* performance on user selection */
  //    func correctSelection () {
  //
  //        self.removeAllActions()
  //        self.resetReminder()
  //        self.mainObjectNode.removeAllActions()
  //
  //        for node in optionNodeList {
  //            node.removeAllActions()
  //        }
  //
  //        var correctNode = optionNodeList[gameController.correctIndex]
  //        //    self.firstOptionNode.removeAllActions()
  //        //    self.secondOptionNode.removeAllActions()
  //        //    self.firstOptionGlow.removeAllActions()
  //        //    self.secondOptionGlow.removeAllActions()
  //
  //        self.mainObjectNode.runAction(SKAction.rotateToAngle(0, duration: 0))
  //        correctNode.runAction(SKAction.rotateToAngle(0, duration: 0))
  //        //    if self.gameController.firstObject.name == self.objectName {
  //        //      self.firstOptionGlow.runAction(SKAction.rotateToAngle(0, duration: 0))
  //        //    } else {
  //        //      self.secondOptionGlow.runAction(SKAction.rotateToAngle(0, duration: 0))
  //        //    }
  //        self.reminder.removeAllActions()
  //
  //        self.mainObjectNode.runAction(SKAction.repeatActionForever(ActionHelper.presentObject()))
  //        correctNode.runAction(SKAction.repeatActionForever(ActionHelper.presentObject()))
  //
  //        self.preventTouching()
  //
  //        if !self.selectionRegistered && statisticsTrack.validate {
  //            self.selectionRegistered = true
  //            UserPerformanceHelper.update(name: objectName, correct: true)
  //
  //            statisticsTrack.setTimeEnd(NSDate(timeIntervalSinceNow: 0))
  //            statisticsTrack.setCorrect(true)
  //            statisticsTrack.logEvent()
  //        }
  //
  //        self.changeMaskColor(UIColor(red: 0, green: 1, blue: 0, alpha: 0.5))
  //        self.mainObjectNode.zPosition = GameViewController.Layers.AboveMask.rawValue
  //
  //        for glow in optionGlowList {
  //            glow.hidden = true
  //        }
  //        //    self.firstOptionGlow.hidden = true
  //        //    self.secondOptionGlow.hidden = true
  //
  //        self.questionLabel.hidden = true
  //
  //        if self.secondaryMainNode != nil {
  //            self.secondaryMainNode.runAction(SKAction.repeatActionForever(ActionHelper.presentObject()))
  //            self.secondaryMainNode.zPosition = GameViewController.Layers.AboveMask.rawValue
  //        }
  //        
  //        self.objectFound()
  //    }
  
  //    func wrongSelection () {
  //
  //        self.removeAllActions()
  //        self.resetReminder()
  //        for node in optionNodeList {
  //            node.removeAllActions()
  //            node.runAction(SKAction.rotateToAngle(0, duration: 0))
  //        }
  //        self.mainObjectNode.runAction(SKAction.rotateToAngle(0, duration: 0))
  //
  //        self.preventTouching()
  //
  //        wrongCounter++
  //
  //        if !self.selectionRegistered && statisticsTrack.validate {
  //            self.selectionRegistered = true
  //            UserPerformanceHelper.update(name: objectName, correct: false)
  //
  //            statisticsTrack.setTimeEnd(NSDate(timeIntervalSinceNow: 0))
  //            statisticsTrack.setCorrect(false)
  //            statisticsTrack.logEvent()
  //        }
  //
  //        if self.state == .WaitingForTap {
  //            /* that's not right */
  //            self.runAction(SoundSourceHelper.soundTryAgain(2)) {
  //                [unowned self] in
  //                /* tap on the xxx */
  //                self.runAction(SoundSourceHelper.soundTap(name: self.objectName))
  //                self.optionNodeList[self.gameController.correctIndex].runAction(ActionHelper.presentObject())
  //                self.allowTouching()
  //            }
  //
  //        } else {
  //
  //            /* That's not a zif */
  //            self.runAction(SKAction.sequence([SoundSourceHelper.soundError()])) {
  //                [unowned self] in
  //
  //                for glow in self.optionGlowList {
  //                    glow.hidden = false
  //                }
  //                //        self.firstOptionGlow.hidden = false
  //                //        self.secondOptionGlow.hidden = false
  //                if self.wrongCounter > 1 {
  //                    /* hide wrong glow */
  //                    for i in 0..<self.optionGlowList.count {
  //                        if i == self.gameController.correctIndex {
  //                            continue
  //                        }
  //
  //                        self.optionGlowList[i].hidden = true
  //                    }
  //                    //          if self.gameController.correctIndex == 1 {
  //                    //            self.firstOptionGlow.hidden = true
  //                    //          } else {
  //                    //            self.secondOptionGlow.hidden = true
  //                    //          }
  //                }
  //
  //                self.allowTouching()
  //                let index = Int(arc4random_uniform(UInt32(self.objectList.count)))
  //                var filename = self.objectList[index].description
  //                switch self.wrongCounter {
  //                case 1:
  //                    /* That’s not it. Try again! */
  //                    self.runAction(SoundSourceHelper.soundTryAgain(1)) {
  //                        [unowned self] () -> () in
  //                        /* Can you find the other apple? */
  //                        self.runAction(SoundSourceHelper.soundFind(name: self.objectName))
  //                    }
  //                case 2:
  //
  //                    /* That’s not right.*/
  //                    self.runAction(SoundSourceHelper.soundTryAgain(2)) {
  //                        /* Remember, this is an apple. */
  //                        self.mainObjectNode.runAction(ActionHelper.presentObject()) {
  //                            [unowned self] () -> () in
  //                            /* These are apples. */
  //                            self.secondaryMainNode = SKSpriteNode(texture: SKTexture(imageNamed: filename))
  //                            self.secondaryMainIndex = index
  //                            self.mainObjectNode.runAction(SKAction.moveByX(-100, y: 0, duration: 0.2))
  //                            self.secondaryMainNode.position = CGPointMake(self.mainObjectNode.position.x + 100, self.mainObjectNode.position.y)
  //                            self.secondaryMainNode.zPosition = GameViewController.Layers.AboveMask.rawValue
  //                            self.secondaryMainNode.xScale = self.mainScaleAfter
  //                            self.secondaryMainNode.yScale = self.mainScaleAfter
  //                            self.addChild(self.secondaryMainNode)
  //
  //                            self.mainFrame = self.mainObjectNode.frame
  //                            self.secondaryMainFrame = self.secondaryMainNode.frame
  //
  //                            self.mainObjectNode.runAction(ActionHelper.presentObject())
  //                            self.secondaryMainNode.runAction(ActionHelper.presentObject(reverseOrder: true))
  //                            self.runAction(SoundSourceHelper.soundMultiple(name: self.objectName)) {
  //                                [unowned self] () -> () in
  //                                /* Can you find the other apple */
  //                                self.emphasizeOptions()
  //                                self.runAction(SoundSourceHelper.soundFind(name: self.objectName))
  //                                self.resetReminder()
  //
  //                            }
  //                        }
  //                        self.runAction(SoundSourceHelper.soundReminder(name: self.objectName))
  //                    }
  //
  //                case 3:
  //                    self.preventTouching()
  //                    /* That’s not right.*/
  //                    self.runAction(SoundSourceHelper.soundTryAgain(2)) {
  //                        [unowned self] () -> () in
  //                        /* Can you find the other apple? */
  //                        self.runAction(SoundSourceHelper.soundFind(name: self.objectName)) {
  //                            [unowned self] () -> () in
  //                            self.runAction(SoundSourceHelper.soundTap(name: self.objectName))
  //                            self.mainObjectNode.runAction(ActionHelper.fadeHalfAway())
  //                            self.secondaryMainNode?.runAction(ActionHelper.fadeHalfAway())
  //
  //                            //              self.wrongNode.runAction(ActionHelper.fadeHalfAway())
  //                            for i in 0..<self.optionNodeList.count {
  //                                if i == self.gameController.correctIndex {
  //                                    continue
  //                                }
  //
  //                                self.optionNodeList[i].runAction(ActionHelper.fadeHalfAway())
  //                            }
  //
  //                            self.allowTouching()
  //                            self.state = .WaitingForTap
  //                            var node = SKNode()
  //                            self.addChild(node)
  //                            node.runAction(SKAction.waitForDuration(30)) {
  //                                [unowned self] in
  //                                self.gameViewController?.presentGameScene(newScene: true)
  //                            }
  //                        }
  //                    }
  //
  //                default:
  //                    break
  //                }
  //            }
  //        }
  //
  //
  //        self.changeMaskColor(UIColor(red: 1, green: 1, blue: 0, alpha: 0.5))
  //        self.mainObjectNode.zPosition = GameViewController.Layers.BelowMask.rawValue
  //        if let thirdOption = self.secondaryMainNode {
  //            thirdOption.zPosition = GameViewController.Layers.BelowMask.rawValue
  //        }
  //
  //        //    self.firstOptionGlow.hidden = true
  //        //    self.secondOptionGlow.hidden = true
  //        for glow in optionGlowList {
  //            glow.hidden = true
  //        }
  //        
  //        self.runAction(ActionHelper.maskDelay()) {
  //            [unowned self] () -> () in
  //            self.resetMask(allowTouching: false)
  //            self.toddlerLock = false
  //        }
  //        
  //        self.resetReminder()
  //    }
    
    /* initialize bear */
    func initScene () {
      self.background = SKSpriteNode(imageNamed: "border")
      
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
  
    class func optionLocation (frame frame : CGRect, index:Int) -> CGPoint {
        var orientation = UIApplication.sharedApplication().statusBarOrientation
        
        if orientation == UIInterfaceOrientation.Portrait || orientation == UIInterfaceOrientation.PortraitUpsideDown {
            
            return CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame) + frame.height * CGFloat(1-index) / 3)
        }
        else {
          
//            return CGPointMake(CGRectGetMidX(frame) + frame.width * CGFloat(index-1) / 3, CGRectGetMidY(frame))
          if index%2 == 0{
            
            return CGPointMake(CGRectGetMidX(frame) - frame.width/6 , CGRectGetMidY(frame) + frame.height * CGFloat(index-1)/6 - frame.height/8)
//            return CGPointMake(CGRectGetMidX(frame) - frame.width/6 , CGRectGetMidY(frame) + frame.height * CGFloat(index-1)/6 )
          }else {
            return CGPointMake(CGRectGetMidX(frame) + frame.width/6 , CGRectGetMidY(frame) + frame.height * CGFloat(index-2)/6 - frame.height/8)
//            return CGPointMake(CGRectGetMidX(frame) + frame.width/6 , CGRectGetMidY(frame) + frame.height * CGFloat(index-2)/6 )
          }
          
        }
        
    }
  
}

