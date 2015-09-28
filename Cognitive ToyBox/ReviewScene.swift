//
//  ReviewScene.swift
//  Cognitive ToyBox
//
//  Created by Heng Lyu on 6/27/14.
//  Copyright (c) 2014 Cognitive ToyBox. All rights reserved.
//

import SpriteKit

extension CGPoint : Hashable {
  public var hashValue: Int {
  get {
//    let p1 = 73856093
//    let p2 = 19349663
//    let p3 = 83492791
    let hashSize = 1 << 15
    
    let x = self.x.hashValue % hashSize
    let y = self.y.hashValue % hashSize
    
    return (x ^ y) % hashSize
//    return ((x * p1) ^ (y * p2) ^ (p3)) % hashSize
  }
  }
}

extension CGVector {
  var norm: CGFloat {
  get {
    return CGFloat(sqrt(self.dx * self.dx + self.dy * self.dy))
  }
  }
}

extension CGFloat {
  init (_ value: UInt32) {
    self.init(Int(value))
  }
}

class ReviewScene: SKScene, ConfigurableScene {
  
  let versionNum = Int(UIDevice.currentDevice().systemVersion.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "."))[0])
  
  weak var gameViewController: GameViewController? = nil
  
//  let objectAtlas = ActionHelper.objectAtlas
  let playgroundScale = CGFloat(1)
  
  var labelFontSize = CGFloat(72)
  
  var background : SKSpriteNode! = nil
  var bear : SKSpriteNode! = nil
  var bearHelmet : SKSpriteNode! = nil
  
  let timeToPlayLabel = SKLabelNode(fontNamed: GlobalConfiguration.labelFont)
  let repeatNameLabel = SKLabelNode(fontNamed: GlobalConfiguration.labelFont)
//  let nextButton = SKLabelNode(fontNamed: GlobalConfiguration.labelFont)
  let nextButton = SKSpriteNode(imageNamed: "nextButton")
  
//  var mainNode : SKSpriteNode! = nil
//  var correctNode : SKSpriteNode! = nil
//  var mainNode_2:SKSpriteNode? = nil
  
  private var newNodeList:[SKSpriteNode] = []
  private var newIdList = NSMutableSet()
  
  var colorMask : SKNode! = nil
  
  
  var objectName : String! = nil
//  var mainId : Int! = nil
//  var correctId : Int! = nil
  
  
  var nodeList = [SKSpriteNode]()
//  var prevLocationList = [SKSpriteNode: CGPoint] ()
  var glowList = [SKSpriteNode]()
  
  var showObjectsIndex = 0
  
  /* projection from touchIndex to node */
  var draggingList = [CGPoint: SKSpriteNode] ()
  
  enum NodeCategory : UInt32 {
    case Border = 1
    case Object = 0b10
  }
  
  enum Mode {
    case Name
  }
  var mode:Mode = .Name
  
//  func didBeginContact(contact:SKPhysicsContact) {
//    NSLog("bodyA velocity: \(contact.bodyA.velocity)")
//    NSLog("bodyB velocity: \(contact.bodyB.velocity)")
//  }
  
  
  private var nextButtonHidden = false
  func hideNextButton(hidden: Bool) {
    nextButtonHidden = hidden
//    if nextButton != nil {
      if nextButton.parent != nil && nextButtonHidden {
        nextButton.removeFromParent()
      } else if nextButton.parent == nil && !nextButtonHidden {
        self.addChild(nextButton)
      }
//    }
  }
  
  private var bearHidden = false
  func bearDance(hidden hidden: Bool) {
    bearHidden = hidden
    if bear != nil {
      if bear.parent != nil && bearHidden {
        bear.removeFromParent()
        bear.removeAllActions()
      } else if bear.parent == nil && !bearHidden {
        self.addChild(bear)
        self.bear.runAction(SKAction.repeatActionForever(ActionHelper.bearDancing())) {
          [unowned self] () -> () in
          ActionHelper.clearFrameCache()
        }
        
        self.showHelmet()
      }
    }
  }
  
  func showHelmet () {
    if GlobalConfiguration.backgroundImageName == BackgroundImageNames.Space {
      var helmetAtlas = SKTextureAtlas(named: "bear_dancing_helmet")
      helmetAtlas.preloadWithCompletionHandler({})
      bearHelmet = SKSpriteNode(texture: helmetAtlas.textureNamed(helmetAtlas.textureNames.first as String!))
      bearHelmet.runAction(SKAction.repeatActionForever(ActionHelper.bearDancingHelmet()))
      self.bear.addChild(bearHelmet)
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
    NSLog("Deinit ReviewScene")
  }
  
  override func didMoveToView(view: SKView) {
    super.didMoveToView(view)

    
    ActionHelper.preloadPlaytimeAction()
//    self.backgroundColor = UIColor(white: 1, alpha: 1)
    
//    self.background = SKSpriteNode(imageNamed: GlobalConfiguration.backgroundImageName.toRaw())
    self.background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
    self.background.zPosition = GameViewController.Layers.Bottom.rawValue
    self.addChild(self.background)
    
    /* init bear */
//    let bearAtlas = ActionHelper.bearDancingAtlas
//    var bearTexture = bearAtlas.textureNamed(bearAtlas.textureNames[0] as String)
//    self.bear = SKSpriteNode(texture: bearTexture)
    self.bear = SKSpriteNode()
    self.bear.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 50)
    self.bear.zPosition = GameViewController.Layers.BearBody.rawValue
    
    // add boundaries
    self.buildBoundaryWalls()
    
//    self.addChild(self.mainNode)
//    self.addChild(self.correctNode)
//    if self.mainNode_2 != nil {
//      self.addChild(self.mainNode_2!)
//    }
    for node in self.newNodeList {
      self.addChild(node)
    }
    
    self.initLabels()
    
    // masks
    var color = UIColor(red: 0, green: 1, blue: 0, alpha: 0.5)

      if #available(iOS 8.0, *) {
          self.colorMask = SKShapeNode(rect: self.frame)
          var colorMask = self.colorMask as! SKShapeNode
          colorMask.strokeColor = color
          colorMask.fillColor = color
      } else {
          self.colorMask = SKSpriteNode(color: color, size: self.frame.size)
          self.colorMask.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
      }
      

    
    self.colorMask.hidden = true
    self.colorMask.zPosition = GameViewController.Layers.AboveBottom.rawValue
    self.addChild(self.colorMask)
    
    
    // add pictures
    self.initNodes()
    
    self.timeToPlay()
    
    
  }

  
  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    super.touchesEnded(touches, withEvent: event)
    
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
      velocity = CGVectorMake((location.x-prevLocation.x)*velocityScale, (location.y-prevLocation.y)*velocityScale)
      if velocity.norm > maxSpeed {
        velocity = CGVectorMake(velocity.dx / velocity.norm * maxSpeed, velocity.dy / velocity.norm * maxSpeed)
      }
      
      node = self.nodeAtPoint(location)
      
      
      if node === self.nextButton {
        self.nextSession()
        return
      }
      
      if node === self.bear {
        bear.removeAllActions()
        bear.runAction(ActionHelper.getPlaytimeRandomAction()) {
          [unowned self] in
          self.bear.runAction(SKAction.repeatActionForever(ActionHelper.bearDancing()))
          self.showHelmet()
        }
        if self.bearHelmet != nil {
          self.bearHelmet.removeFromParent()
        }
      }
      
      // unregister node
      if self.draggingList.indexForKey(prevLocation) != nil {
        
        spriteNode = draggingList[prevLocation]
//        spriteNode!.runAction(ActionHelper.dragTo(location, from: prevLocation)) {
//        [unowned self] () -> () in
          spriteNode!.physicsBody?.velocity = velocity
          spriteNode!.physicsBody?.mass = 1
//        }
        self.draggingList.removeValueForKey(prevLocation)
//        self.prevLocationList.removeValueForKey(spriteNode!)
      }
      
      if self.draggingList.indexForKey(location) != nil {
        
        spriteNode = draggingList[location]
//        spriteNode!.runAction(ActionHelper.dragTo(location, from: prevLocation)) {
//        [unowned self] () -> () in
          spriteNode!.physicsBody?.velocity = velocity
          spriteNode!.physicsBody?.mass = 1
//        }
        self.draggingList.removeValueForKey(location)
//        self.prevLocationList.removeValueForKey(spriteNode!)
      }
      
      
      
      
    }
    
    if event!.allTouches()?.count == touches.count {
      self.resetDrag()
    }
    
    
    
  }
 
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    super.touchesBegan(touches, withEvent: event)
    
    var location : CGPoint
    var node : SKNode
    var spriteNode : SKSpriteNode?
    
    
    
    for touch : AnyObject in touches {
      location = (touch as! UITouch).locationInNode(self)
      node = self.nodeAtPoint(location)
      
      spriteNode = node.isMemberOfClass(SKSpriteNode) ? (node as! SKSpriteNode) : nil
      
      if spriteNode == nil {
        continue
      }
      
      for (location, draggingNode) in draggingList {
        if draggingNode == spriteNode {
          continue
        }
      }
      
      if ReviewScene.isCTBObject(spriteNode!) {//&& self.prevLocationList.indexForKey(spriteNode!) == nil {
        
        
        
        
        self.colorMask.hidden = false
        spriteNode!.removeAllActions()
        spriteNode!.physicsBody?.velocity = CGVectorMake(0, 0)
        spriteNode!.physicsBody?.mass = 1000
        
        self.draggingList[location] = spriteNode!
//        self.prevLocationList[spriteNode!] = location
        
        self.runAction(SoundSourceHelper.soundTouch())
      }
    }
    
    
  }


  override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    super.touchesMoved(touches, withEvent: event)
    
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
        spriteNode!.physicsBody?.velocity = CGVectorMake(0, 0)
        
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
      
      if spriteNode == nil {
        continue
      }
      
      if ReviewScene.isCTBObject(spriteNode!) && self.draggingList[location] != spriteNode! {
        
        
        let forceScale = CGFloat(1000000)
        var dx : CGFloat
        var dy : CGFloat
        var force : CGVector
        var minDiff = CGFloat(50)
        
            
        dx = spriteNode!.position.x - location.x
        dy = spriteNode!.position.y - location.y
        
        if abs(dx) < minDiff {
          dx = dx > 0 ? minDiff : -minDiff
        }
        if abs(dy) < minDiff {
          dy = dy > 0 ? minDiff : -minDiff
        }
        
//        force = CGVectorMake(forceScale/(dx), forceScale/(dy))
        force = CGVectorMake(dx * forceScale / (dx*dx + dy*dy), dy * forceScale / (dx*dx + dy*dy))
        spriteNode!.physicsBody?.applyForce(force, atPoint: touch.locationInNode(spriteNode!))
        
      }
    }
  }
  
  override func update(currentTime: CFTimeInterval) {
    /* Called before each frame is rendered */
    
    // change gravity
//    var gravity = self.physicsWorld.gravity
//    var gravityChange = CGVectorMake(<#dx: CGFloat#>, <#dy: CGFloat#>)
//    println(self.mainNode.position)
    var minX = CGRectGetMinX(self.frame)
    var minY = CGRectGetMinY(self.frame)
    var maxX = CGRectGetMaxX(self.frame)
    var maxY = CGRectGetMaxY(self.frame)
    
    for node in nodeList {
      if node.position.x < minX || node.position.x > maxX || node.position.y < minY || node.position.y > maxY {
        node.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
      }
    }
    
    for i in 0..<glowList.count {
      glowList[i].position = nodeList[i].position
    }
  }
  
  var presentingObjects:Int = 0
  
  func initLabels () {
//    self.timeToPlayLabel.text = "Two \(objectName)s!"
    switch self.mode {
    case .Name:
      if presentingObjects == 1 {
        self.timeToPlayLabel.text = "\(presentingObjects) \(objectName)"
      } else {
        self.timeToPlayLabel.text = "\(presentingObjects) \(CognitiveToyBoxObject.getPluralName(objectName))"
      }
//    case .Material:
//      self.timeToPlayLabel.text = "Some \(objectName)"
    }
    
    self.timeToPlayLabel.fontSize = self.labelFontSize
    self.timeToPlayLabel.fontColor = UIColor(white: CGFloat(0), alpha: CGFloat(1))
    self.timeToPlayLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + self.size.height/3)
    self.timeToPlayLabel.hidden = true
    self.timeToPlayLabel.zPosition = GameViewController.Layers.Label.rawValue
    self.addChild(self.timeToPlayLabel)
    
    self.repeatNameLabel.text = CognitiveToyBoxObject.getPluralName(objectName)//"Look at all the \(objectName)s!"
    self.repeatNameLabel.fontSize = self.labelFontSize
    self.repeatNameLabel.fontColor = UIColor(white: CGFloat(0), alpha: CGFloat(1))
    self.repeatNameLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + self.size.height/3)
    self.repeatNameLabel.alpha = 0
    self.repeatNameLabel.zPosition = GameViewController.Layers.Label.rawValue
    self.addChild(self.repeatNameLabel)
    
//    self.nextButton.text = "next >>"
//    self.nextButton.fontSize = self.labelFontSize
//    self.nextButton.fontColor = UIColor.greenColor()
//    self.nextButton.position = CGPointMake(self.size.width*8/10, self.size.height/10)
    self.nextButton.anchorPoint = CGPointMake(1, 1)
    self.nextButton.position = CGPointMake(self.size.width - 100, self.size.height - 20)
//    self.nextButton.runAction(ActionHelper.delayPlaytime(), completion: self.nextSession)
//    self.nextButton.hidden = true
    self.nextButton.zPosition = GameViewController.Layers.Label.rawValue
    self.nextButton.setScale(1.2)
    
    /* added in hideNextButton */
//    self.addChild(self.nextButton)
    self.hideNextButton(GlobalConfiguration.nextButtonHidden)
    
  }
  
  func initNodes () {
    let limit = 5
    var objectAtlas:SKTextureAtlas! = nil
    var objectList:[CognitiveToyBoxObject]
    let scale = self.playgroundScale
    var node : SKSpriteNode
    
    switch self.mode {
    case .Name:
      objectList = CognitiveToyBoxObjectSearchHelper.getSameNameAll(name: self.objectName, limit: limit)
      objectAtlas = SKTextureAtlas(named: self.objectName)
    
    }
    
    
    for object in objectList {
      
//      if object.id == mainId || object.id == correctId {
      if newIdList.containsObject(object.id) {
        continue
      }
      
//      node = SKSpriteNode(imageNamed: object.toString().stringByAppendingPathExtension(ImageSourceHelper.imageExtension))
//      node = SKSpriteNode(texture: self.objectAtlas.textureNamed(object.playtimeImageFileName))
      if objectAtlas != nil {
        node = SKSpriteNode(texture: objectAtlas.textureNamed(object.playtimeImageFileName))
      } else {
        node = SKSpriteNode(texture: SKTexture(imageNamed: object.playtimeImageFileName))
      }
      node.xScale = scale
      node.yScale = scale
      
      node.position = CGPointMake(CGFloat(arc4random_uniform(UInt32(self.view!.bounds.width.native))), CGFloat(arc4random_uniform(UInt32(self.view!.bounds.height.native))))
      node.zPosition = GameViewController.Layers.BearObject.rawValue
//      node.hidden = true
      
      
      
      self.nodeList.append(node)
      
//      self.addChild(node)
    }
    
    while nodeList.count+presentingObjects > limit && !nodeList.isEmpty {
      nodeList.removeLast()
    }
  }
  
  func nextSession () {
    
    SoundSourceHelper.stopBGM()
    
    self.gameViewController?.presentWelcomeScene()
    
    ActionHelper.clearFrameCache()
  }
  
  
  /* build boundaries, restrict the area objects can move */
  func buildBoundaryWalls () {
    
    self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
    self.physicsBody?.dynamic = false

  }
  
  
  /* time to play: show label, move nodes. completion: showObjects */
  func timeToPlay () {
    self.timeToPlayLabel.hidden = false
    
    
    let scale = self.playgroundScale
    
    for node in newNodeList {
      if node === newNodeList.first {
      node.runAction(ActionHelper.transitionTo(location: CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)), scale: scale), completion: self.explode)
      } else {
        node.runAction(ActionHelper.transitionTo(location: CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)), scale: scale))
      }
      node.runAction(SKAction.group([SKAction.fadeAlphaTo(1, duration: 1), SKAction.rotateToAngle(0, duration: 1)]))
    }
    
    /* how many objects are presented? play the correct sound */
    let soundAction = SoundSourceHelper.soundCorrect(name: self.objectName)
    self.runAction(soundAction) {
      [unowned self] () -> () in
      self.bearDance(hidden: GlobalConfiguration.bearHidden)
      
      SoundSourceHelper.playPlaytimeSong()
    }
    
  }
  
  /* drop displayed objects into playground */
//  func dropIn () {
//    /* fade out timeToPlayLabel and put it at the bottom level */
//    self.timeToPlayLabel.runAction(ActionHelper.appearAndFadeAway(), completion: {[unowned self] () -> () in self.timeToPlayLabel.zPosition = GameViewController.Layers.Bottom.rawValue})
//    
//    
//    let duration = 0.4
//    let delayActionBefore = ActionHelper.timeToPlayDelayBefore()
//    let delayActionAfter = ActionHelper.timeToPlayDelayAfter()
//    
//    var position = CGPointMake(CGFloat(arc4random_uniform(UInt32(self.view!.bounds.width.native)-20)+10), CGFloat(arc4random_uniform(UInt32(self.view!.bounds.height.native)-20)+10))
//    var transition = ActionHelper.transitionTo(location: position, scale: self.playgroundScale, duration: duration)
//    self.mainNode.runAction(SKAction.sequence([delayActionBefore, transition, delayActionAfter])) {
//      [unowned self] () -> () in
////        NSRunLoop.currentRunLoop().addTimer(self.showObjectsTimer, forMode: NSDefaultRunLoopMode)
//      self.showObjects()
//    }
//    
//    if self.mainNode_2 != nil {
//      self.mainNode_2!.runAction(SKAction.sequence([delayActionBefore, transition, delayActionAfter]))
//    }
//    
//    position = CGPointMake(CGFloat(arc4random_uniform(UInt32(self.view!.bounds.width.native)-20)+10), CGFloat(arc4random_uniform(UInt32(self.view!.bounds.height.native)-20)+10))
//    transition = ActionHelper.transitionTo(location: position, scale: self.playgroundScale, duration: duration)
//    self.correctNode.runAction(SKAction.sequence([delayActionBefore, transition, delayActionAfter]))
//    
//  }
  
  /* explode the object pile, distribute objects with random speed */
  func explode () {
    /* fade out timeToPlayLabel and put it at the bottom level */
    self.timeToPlayLabel.runAction(ActionHelper.appearAndFadeAway(), completion: {[unowned self] () -> () in self.timeToPlayLabel.zPosition = GameViewController.Layers.Bottom.rawValue})
    
    let duration = 1.0
    let delayActionBefore = ActionHelper.timeToPlayDelayBefore()
    
    var position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
    var preExplode = ActionHelper.preExplode(scale: self.playgroundScale, duration: duration)
    
    for node in newNodeList {
      if node === newNodeList.first {
        node.runAction(SKAction.sequence([delayActionBefore, preExplode])) {
          [unowned self] () -> () in
          self.showObjects(false)
        }
      } else {
        node.runAction(SKAction.sequence([delayActionBefore, preExplode]))
      }
    }
  }
  
  /* show nodes one by one */
  func showObjects (oneByOne:Bool = true) {
    
    
    if self.showObjectsIndex >= self.nodeList.count {
//      self.showObjectsTimer.invalidate()
      self.applyPhysics()
      self.runAction(ActionHelper.delayPlaytime(), completion: self.nextSession)
      self.repeatName()
      self.timeToPlayLabel.hidden = true
      return
    }
    
    
    self.addChild(self.nodeList[self.showObjectsIndex])
    self.showObjectsIndex++
    
    if oneByOne {
      self.runAction(ActionHelper.showObjectsTimerInterval()) {
        [unowned self] () -> () in
        self.showObjects()
      }
    } else {
      self.showObjects(oneByOne)
    }
    
    
    
  }
  
  /* repeat: Look at all the objects! */
  func repeatName () {
    self.repeatNameLabel.zPosition = GameViewController.Layers.Label.rawValue
    self.repeatNameLabel.runAction(ActionHelper.appearAndFadeAway()) {
      [unowned self] () -> () in
      self.repeatNameLabel.zPosition = GameViewController.Layers.Bottom.rawValue
    }
    self.runAction(SoundSourceHelper.soundTimeToPlay(name: self.objectName))
    self.runAction(ActionHelper.repeatNameTimerInterval()) {
      [unowned self] () -> () in
      self.repeatName()
    }
  }
  
//  func didBeginContact(contact: SKPhysicsContact!) {
//    self.runAction(SoundSourceHelper.soundTouch())
//  }
  
  /* setup physics body */
  func applyPhysics () {
    
//    self.physicsWorld.contactDelegate = self
    
    self.nodeList.appendContentsOf(self.newNodeList)
//    self.mainNode.hidden = false
//    self.nodeList.append(self.mainNode)
//    self.nodeList.append(self.correctNode)
//    
//    if let mainNode_2 = self.mainNode_2 {
//      mainNode_2.hidden = false
//      self.nodeList.append(mainNode_2)
//    }
    
//    let midTop = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame))
    var direction : CGVector
    var norm : CGFloat
    let velocityScale = CGFloat(10000)
    
    for node in self.nodeList {
      
      // physics body
      if #available(iOS 8.0, *) {
          node.physicsBody = SKPhysicsBody(texture: node.texture!, size: node.size)
      } else {
          // Fallback on earlier versions
      }
//      node.physicsBody = SKPhysicsBody(rectangleOfSize: node.size)
//      node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width/3)
//      var path = CGPathCreateWithEllipseInRect(node.frame, nil)
//      node.physicsBody = SKPhysicsBody(polygonFromPath: path)
      node.physicsBody?.dynamic = true
      node.physicsBody?.usesPreciseCollisionDetection = true
      node.physicsBody?.affectedByGravity = false
      node.physicsBody?.mass = 1
      node.physicsBody?.categoryBitMask = NodeCategory.Object.rawValue
      node.physicsBody?.contactTestBitMask = NodeCategory.Object.rawValue | NodeCategory.Border.rawValue
      node.physicsBody?.collisionBitMask = NodeCategory.Object.rawValue | NodeCategory.Border.rawValue
      node.physicsBody?.restitution = 0.8
      
      direction = CGVectorMake(CGFloat(Int(arc4random_uniform(21))-10), CGFloat(Int(arc4random_uniform(21))-10))
      
      if direction.dx == 0 && direction.dy == 0 {
        direction = CGVectorMake(0, 1)
      }
      norm = direction.norm
      
      
      node.physicsBody?.velocity = CGVectorMake(direction.dx / norm * velocityScale, direction.dy / norm * velocityScale)
    }
    
    addGlows()
    
  }
  
  func addGlows () {
    for node in nodeList {
      var glow = SKSpriteNode(imageNamed: "glow")
      glow.position = node.position
      glow.zPosition = node.zPosition - 1
      glow.runAction(ActionHelper.beaconGlow())
      glowList.append(glow)
      self.addChild(glow)
      glow.runAction(SKAction.fadeOutWithDuration(5)) {
        [unowned self] in
        glow.removeFromParent()
        glow.removeAllActions()
        self.glowList.removeAll()
      }
    }
  }
  
  func resetDrag () {
    self.draggingList.removeAll(keepCapacity: false)
//    self.prevLocationList.removeAll(keepCapacity: false)
    
    for node in self.nodeList {
      if ReviewScene.isCTBObject(node) {
        node.physicsBody?.mass = 1
      }
      
    }
    
    self.colorMask.hidden = true
  }
  
  /* get node and id from the previous scene */
  func addNode (node:SKSpriteNode, id:Int) {
    node.physicsBody = nil
    presentingObjects++
    newNodeList.append(node)
    newIdList.addObject(id)
  }

  
  class func isCTBObject (node : SKSpriteNode) -> Bool {
    if node.physicsBody != nil && node.physicsBody?.categoryBitMask == NodeCategory.Object.rawValue {
      return true
    } else {
      return false
    }
  }
  
  
  
}

