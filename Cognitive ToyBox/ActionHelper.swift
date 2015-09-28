//
//  ActionHelper.swift
//  Cognitive ToyBox
//
//  Created by Heng Lyu on 7/2/14.
//  Copyright (c) 2014 Cognitive ToyBox. All rights reserved.
//

import UIKit
import SpriteKit

/* returns specific SKActions */
public class ActionHelper: NSObject, ConfigurableActionHelper {
  
  public var newSessionInterval: NSTimeInterval = 120
  public var objectPresentMode: ObjectPresentMode.RawValue = "Shake"
  public var playtimeInterval: NSTimeInterval = 30
  
  private let timePerFrame: NSTimeInterval = 1/15
  
  private struct BearWaving {
    static var onceToken: dispatch_once_t = 0
    static var instance: SKAction? = nil
  }
  private struct BearDancing {
    static var onceToken: dispatch_once_t = 0
    static var instance: SKAction? = nil
  }
  private struct BearDancing2 {
    static var onceToken: dispatch_once_t = 0
    static var instance: SKAction? = nil
  }
  private struct BearHighfive {
    static var onceToken: dispatch_once_t = 0
    static var instance: SKAction? = nil
  }
  private struct BearScratching {
    static var onceToken: dispatch_once_t = 0
    static var instance: SKAction? = nil
  }
  private struct BearTwisting {
    static var onceToken: dispatch_once_t = 0
    static var instance: SKAction? = nil
  }
  
  private var _bearWavingAtlas: SKTextureAtlas! = nil
  public class var bearWavingAtlas: SKTextureAtlas {
    get {
      if self.sharedInstance._bearWavingAtlas == nil {
        self.loadBearWavingAtlas()
      }
      return self.sharedInstance._bearWavingAtlas
    }
  }
  private class var BearWavingAtlasStr: String {
    return "bear_waving"
  }
  
  private var _bearDancingAtlas: SKTextureAtlas! = nil
  public class var bearDancingAtlas: SKTextureAtlas {
    get {
      if self.sharedInstance._bearDancingAtlas == nil {
        self.loadBearDancingAtlas()
      }
      return self.sharedInstance._bearDancingAtlas
    }
  }
  private class var BearDancingAtlasStr: String {
  return "bear_dancing"
  }
  
  private var _bearDancing2Atlas: SKTextureAtlas! = nil
  public class var bearDancing2Atlas: SKTextureAtlas {
    get {
      if self.sharedInstance._bearDancing2Atlas == nil {
        self.loadBearDancing2Atlas()
      }
      return self.sharedInstance._bearDancing2Atlas
    }
  }
  private class var BearDancing2AtlasStr: String {
    return "bear_dancing2"
  }
  
  private var _bearHighfiveAtlas: SKTextureAtlas! = nil
  public class var bearHighfiveAtlas: SKTextureAtlas {
    get {
      if self.sharedInstance._bearHighfiveAtlas == nil {
        self.loadBearHighfiveAtlas()
      }
      return self.sharedInstance._bearHighfiveAtlas
    }
  }
  private class var BearHighfiveAtlasStr: String {
    return "bear_highfive"
  }
  
  private var _bearScratchingAtlas: SKTextureAtlas! = nil
  public class var bearScratchingAtlas: SKTextureAtlas {
    get {
      if self.sharedInstance._bearScratchingAtlas == nil {
        self.loadBearScratchingAtlas()
      }
      return self.sharedInstance._bearScratchingAtlas
    }
  }
  private class var BearScratchingAtlasStr: String {
    return "bear_scratching"
  }
  
  private var _bearTwistingAtlas: SKTextureAtlas! = nil
  public class var bearTwistingAtlas: SKTextureAtlas {
    get {
      if self.sharedInstance._bearTwistingAtlas == nil {
        self.loadBearTwistingAtlas()
      }
      return self.sharedInstance._bearTwistingAtlas
    }
  }
  private class var BearTwistingAtlasStr: String {
    return "bear_twisting"
  }
  
  private class func getAtlasByName (name: String) -> SKTextureAtlas! {
    switch name {
    case self.BearWavingAtlasStr:
      return self.bearWavingAtlas
    case self.BearDancingAtlasStr:
      return self.bearDancingAtlas
    case self.BearDancing2AtlasStr:
      return self.bearDancing2Atlas
    case self.BearHighfiveAtlasStr:
      return self.bearHighfiveAtlas
    case self.BearScratchingAtlasStr:
      return self.bearScratchingAtlas
    case self.BearTwistingAtlasStr:
      return self.bearTwistingAtlas
    default:
//      var name = NSInvalidArgumentException
//      var message = "Invalid atlas name!"
//      var e = NSException(name: name, reason: message, userInfo: nil)
//      Flurry.logError(name, message: message, exception: e)
//      e.raise()
      return SKTextureAtlas(named: name)
    }
    
    return nil
  }
  
  public class func loadBearAtlas () {
    loadBearDancingAtlas()
    loadBearWavingAtlas()
    loadBearDancing2Atlas()
    loadBearHighfiveAtlas()
    loadBearScratchingAtlas()
    loadBearTwistingAtlas()
    
  }
  
  public class func loadBearDancingAtlas () {
    if GlobalConfiguration.bearHidden {
      return
    }
    self.sharedInstance._bearDancingAtlas = SKTextureAtlas(named: self.BearDancingAtlasStr)
    self.sharedInstance._bearDancingAtlas.preloadWithCompletionHandler() {
      NSLog("Atlas preloaded: \(self.BearDancingAtlasStr)")
    }
  }
  
  public class func loadBearWavingAtlas () {
    if GlobalConfiguration.bearHidden {
      return
    }
    self.sharedInstance._bearWavingAtlas = SKTextureAtlas(named: self.BearWavingAtlasStr)
    self.sharedInstance._bearWavingAtlas.preloadWithCompletionHandler() {
      NSLog("Atlas preloaded: \(self.BearWavingAtlasStr)")
    }
  }
  
  public class func loadBearDancing2Atlas () {
    if GlobalConfiguration.bearHidden {
      return
    }
    self.sharedInstance._bearDancing2Atlas = SKTextureAtlas(named: self.BearDancing2AtlasStr)
    self.sharedInstance._bearDancing2Atlas.preloadWithCompletionHandler() {
      NSLog("Atlas preloaded: \(self.BearDancing2AtlasStr)")
    }
  }
  
  public class func loadBearHighfiveAtlas () {
    if GlobalConfiguration.bearHidden {
      return
    }
    self.sharedInstance._bearHighfiveAtlas = SKTextureAtlas(named: self.BearHighfiveAtlasStr)
    self.sharedInstance._bearHighfiveAtlas.preloadWithCompletionHandler() {
      NSLog("Atlas preloaded: \(self.BearHighfiveAtlasStr)")
    }
  }
  
  public class func loadBearScratchingAtlas () {
    if GlobalConfiguration.bearHidden {
      return
    }
    self.sharedInstance._bearScratchingAtlas = SKTextureAtlas(named: self.BearScratchingAtlasStr)
    self.sharedInstance._bearScratchingAtlas.preloadWithCompletionHandler() {
      NSLog("Atlas preloaded: \(self.BearScratchingAtlasStr)")
    }
  }
  
  public class func loadBearTwistingAtlas () {
    if GlobalConfiguration.bearHidden {
      return
    }
    self.sharedInstance._bearTwistingAtlas = SKTextureAtlas(named: self.BearTwistingAtlasStr)
    self.sharedInstance._bearTwistingAtlas.preloadWithCompletionHandler() {
      NSLog("Atlas preloaded: \(self.BearTwistingAtlasStr)")
    }
  }
  
  public class func getPlaytimeRandomAction () -> SKAction {
    var bearAction:SKAction
    switch arc4random_uniform(4) {
    case 0:
      bearAction = bearDancing2()
    case 1:
      bearAction = bearHighfive()
    case 2:
      bearAction = bearScratching()
    case 3:
      bearAction = bearTwisting()
    default:
      bearAction = SKAction()
    }
    
    return SKAction.group([bearAction, SoundSourceHelper.soundBear()])
  }
  
  public class func preloadPlaytimeAction () {
    loadBearDancing2Atlas()
    loadBearHighfiveAtlas()
    loadBearScratchingAtlas()
    loadBearTwistingAtlas()
  }
  
  public class func releaseBearAtlas () {
//    releaseBearDancingAtlas()
//    releaseBearWavingAtlas()
//    releaseBearDancing2Atlas()
//    releaseBearHighfiveAtlas()
//    releaseBearScratchingAtlas()
//    releaseBearTwistingAtlas()
    
    
  }
  
  public class func releaseBearDancingAtlas() {
    self.sharedInstance._bearDancingAtlas = nil
  }
  
  public class func releaseBearWavingAtlas() {
    self.sharedInstance._bearWavingAtlas = nil
  }
  
  public class func releaseBearDancing2Atlas() {
    self.sharedInstance._bearDancing2Atlas = nil
  }
  
  public class func releaseBearHighfiveAtlas() {
    self.sharedInstance._bearHighfiveAtlas = nil
  }
  
  public class func releaseBearScratchingAtlas() {
    self.sharedInstance._bearScratchingAtlas = nil
  }
  
  public class func releaseBearTwistingAtlas() {
    self.sharedInstance._bearTwistingAtlas = nil
  }
  
  override private init() {
    super.init()
    
//    _objectAtlas = SKTextureAtlas(named: "Objects")
//    _glowAtlas = SKTextureAtlas(named: "Glow")
    
    GlobalConfiguration.addActionHelper(self)
  }
  
  override public func isEqual(object: AnyObject!) -> Bool {
    return super.isEqual(object) && self===object
  }
  
  /* Singleton pattern */
  class var sharedInstance: ActionHelper {
    get {
      struct Static {
        static var onceToken: dispatch_once_t = 0
        static var instance: ActionHelper? = nil
      }
      
      dispatch_once(&Static.onceToken) {
        Static.instance = ActionHelper()
        
      }
      
      return Static.instance!
    }
  }
  
  public class func presentObject (reverseOrder : Bool = false) -> SKAction {
    switch ObjectPresentMode(rawValue: self.sharedInstance.objectPresentMode)! {
    case .Shake:
//      return slightShake(reverseOrder: reverseOrder)
      return wiggle(5, reverseOrder: reverseOrder)
    case .ZoomInAndOut:
      return zoomInAndOut()
    case .Bounce:
      return bounce()
    case .DoNothing:
      return doNothing()
    default:
      var name = NSInvalidArgumentException
      var message = "Invalid present mode."
      var e = NSException(name: name, reason: message, userInfo: nil)
      Flurry.logError(name, message: message, exception: e)
      e.raise()
    }
  }
  
  /* zoom in and out */
  public class func zoomInAndOut () -> SKAction {
    let duration = 0.5
    let scale: CGFloat = 1.6
    let zoomIn = SKAction.scaleBy(scale, duration: duration)
    let zoomOut = SKAction.scaleBy(1/scale, duration: duration)
    return SKAction.sequence([zoomIn, zoomOut])
  }
  
  /* slightly shake */
  public class func slightShake (reverseOrder : Bool = false) -> SKAction {
    var duration = 0.1
    var angle = M_PI/9
    
    if reverseOrder {
      angle = -angle
    }
    
    var leftRotate = SKAction.rotateToAngle(CGFloat(angle), duration: duration)
    var rightRotate = SKAction.rotateToAngle(CGFloat(-angle), duration: duration)
    var reset = SKAction.rotateToAngle(0, duration: duration)
    
    var actions = SKAction.sequence([leftRotate, rightRotate, leftRotate, rightRotate, reset])
    return actions
  }
  
  public class func wiggle (times:Int = 1, reverseOrder:Bool = false) -> SKAction {
    var duration = 0.25
    var angle = M_PI/9
    
    if reverseOrder {
      angle = -angle
    }
    
    var leftRotate = SKAction.rotateToAngle(CGFloat(angle), duration: duration)
    var rightRotate = SKAction.rotateToAngle(CGFloat(-angle), duration: duration)
    var reset = SKAction.rotateToAngle(0, duration: duration)
    
    var sequence:[SKAction] = []
    for i in 0..<times {
      sequence.appendContentsOf([leftRotate, rightRotate])
    }
    sequence.append(reset)
    
    var actions = SKAction.sequence(sequence)
    return actions
  }
  
  public class func doNothing()-> SKAction{
    
//    var sequence:[SKAction] = []
    var actions = SKAction()
    return actions
  }
  
  /* bouncing */
  public class func bounce () -> SKAction {
    let duration:NSTimeInterval = 0.12
    let bounceHeight:CGFloat = 20
    
    let dropAction = SKAction.moveByX(0, y: -bounceHeight, duration: duration)
    dropAction.timingMode = .EaseIn
    
//    let riseAction = SKAction.moveByX(0, y: bounceHeight, duration: duration)
//    riseAction.timingMode = .EaseOut
    let riseAction = dropAction.reversedAction()
    
    let squeezeAction = SKAction.group([SKAction.scaleXBy(1, y: 0.8, duration: duration), SKAction.moveByX(0, y: -bounceHeight, duration: duration)])
    squeezeAction.timingMode = .EaseOut
    
//    let recoverAction = SKAction.scaleYTo(1, duration: duration)
//    recoverAction.timingMode = .EaseIn
    let recoverAction = squeezeAction.reversedAction()
    
    return SKAction.repeatAction(SKAction.sequence([riseAction, dropAction, squeezeAction, recoverAction]), count: 3)
    
  }
  
  public class func jostle () -> SKAction {
    let duration:NSTimeInterval = 0.6
    var narrowAction = SKAction.scaleXBy(0.6, y: 1, duration: duration)
    var wideAction = SKAction.reversedAction(narrowAction)
    return SKAction.sequence([narrowAction, wideAction()])
  }
  
  public class func rotateByRandomAngle () -> SKAction {
    let radians:CGFloat = CGFloat(M_PI/8) * CGFloat(arc4random_uniform(16)+1) * (arc4random_uniform(2)==0 ? 1:-1)
    var action = SKAction.rotateByAngle(radians, duration: 1)
    action.timingMode = .EaseOut
    return action
  }
  
  /* fade away */
  public class func appearAndFadeAway () -> SKAction {
    var appear = SKAction.fadeInWithDuration(0)
    var fadeAway = SKAction.fadeOutWithDuration(2)
    return SKAction.sequence([appear, fadeAway])
  }
  
  public class func fadeHalfAway () -> SKAction {
    return SKAction.fadeAlphaTo(0.3, duration: 1)
  }
  
  /* delay function when no response */
  public class func delayNextSession () -> SKAction {
    return SKAction.waitForDuration(self.sharedInstance.newSessionInterval)
  }
  
  /* delay function for playtime (25s)*/
  public class func delayPlaytime () -> SKAction {
    return SKAction.waitForDuration(self.sharedInstance.playtimeInterval)
  }
  
  /* show main object and label in GameScene */
  class func displayMain () -> SKAction {
    return SKAction.waitForDuration(0.1)
  }
  
  /* wait for main */
  public class func waitForMain () -> SKAction {
    return SKAction.waitForDuration(5)
  }
  
  /* delay when the mask changes back */
  public class func maskDelay () -> SKAction {
    return SKAction.waitForDuration(2)
  }
  
  /* delay toddler touch */
  public class func touchDelay () -> SKAction {
    return SKAction.waitForDuration(0.4)
  }
  
  /* show options and label in GameScene */
  class func displayOptions () -> SKAction {
    return SKAction.waitForDuration(2)
  }
  
  /* play one-time sound */
  public class func playSound (soundFile soundFile : String) -> SKAction {
    return SKAction.playSoundFileNamed(soundFile, waitForCompletion: true)
  }
  
  /* transition and rescale (wait for a while when finished) */
  public class func transitionMain (location location : CGPoint, scaleBy : CGFloat, duration : NSTimeInterval = 0.2) -> SKAction {
    
    var transition = SKAction.moveTo(location, duration: duration)
    var rescale = SKAction.scaleBy(scaleBy, duration: duration)
    
    var group = SKAction.group([transition, rescale])
    return SKAction.sequence([group, SKAction.waitForDuration(duration/10)])
  }
  
  /* transition and rescale */
  public class func transitionTo (location location : CGPoint, scale : CGFloat, duration : NSTimeInterval = 1) -> SKAction {
    
    var transition = SKAction.moveTo(location, duration: duration)
    var rescale = SKAction.scaleTo(scale, duration: duration)
    
    var group = SKAction.group([transition, rescale])
    return group
  }
  
  /* shake before explode */
  public class func preExplode (scale scale: CGFloat, duration: NSTimeInterval = 1) -> SKAction {
//    let shakeInterval = 0.05
//    var shake: [SKAction] = []
//    
//    var direction: CGVector
//    var norm: CGFloat
//    let velocityScale:CGFloat = 10
//    
//    for i in 0..<Int(duration/shakeInterval) {
//      direction = CGVectorMake(CGFloat(Int(arc4random_uniform(21))-10), CGFloat(Int(arc4random_uniform(21))-10))
//      
//      if direction.dx == 0 && direction.dy == 0 {
//        direction = CGVectorMake(0, 1)
//      }
//      norm = direction.norm
//      shake.append(SKAction.moveBy(CGVectorMake(direction.dx / norm * velocityScale, direction.dy / norm * velocityScale), duration: shakeInterval))
//    }
//    
//    var rescale = SKAction.scaleTo(scale, duration: duration)
//    
//    var group = SKAction.group([shake, rescale])
//    return group
    return SKAction()
  }
  
  /* delay after "time to play" and showObject */
  public class func timeToPlayDelayBefore () -> SKAction {
    return SKAction.waitForDuration(3)
  }
  
  public class func timeToPlayDelayAfter () -> SKAction {
    return SKAction.waitForDuration(0.3)
  }
  
  /* reminder timer */
  public class func reminderDelay () -> SKAction {
    return SKAction.waitForDuration(10)
  }
  
  // ReviewScene dragging
  public class func dragTo (location: CGPoint, from: CGPoint) -> SKAction {
    let timeScale: CGFloat = 1000
    let delay = SKAction.waitForDuration(0.01)
    let duration = NSTimeInterval(CGVectorMake(location.x-from.x, location.y-from.y).norm / timeScale)
    return SKAction.sequence([delay, SKAction.moveTo(location, duration: duration)])
  }
  
  // Live actions
  public class func playFrames (textureAtlas : SKTextureAtlas, repeatTime : Bool) -> SKAction {
    var textureNames = textureAtlas.textureNames as! [String]
    textureNames.sort(<)
    
    var textures = textureNames.map() {
      (name : String) -> SKTexture in
      return textureAtlas.textureNamed(name)
    }
    
    var timePerFrame = self.sharedInstance.timePerFrame
    var numFrames = textureAtlas.textureNames.count
    var duration = timePerFrame * NSTimeInterval(numFrames)
    
    var action = SKAction.animateWithTextures(textures, timePerFrame: timePerFrame, resize: true, restore: false)
    
    if repeatTime {
      return SKAction.repeatActionForever(action)
    }
    
    return SKAction.group([action, SKAction.waitForDuration(duration)])
  }
  
  public class func beaconGlow (scale:CGFloat = 1) -> SKAction {
//    let textureAtlas: SKTextureAtlas = SKTextureAtlas(named: object.name)
//    return SKAction.repeatActionForever(SKAction.animateWithTextures([textureAtlas.textureNamed(object.glowName), textureAtlas.textureNamed(object.glowName2)], timePerFrame: self.sharedInstance.timePerFrame * 10, resize: true, restore: false))
    let blur = SKAction.scaleTo(scale*0.618, duration: 1)
    let unblur = SKAction.scaleTo(scale, duration: 1)
    return SKAction.repeatActionForever(SKAction.sequence([blur, unblur]))
  }
  
  /* frame index format: 00001 */
  private class func frameIndexFormat (index: Int) -> String {
    return NSString(format: "%05d", index) as String
  }
  
  /* extend texture sequence by adding customized frames */
  private class func playframes (atlasName atlasName: String, frameRange: Range<Int>, repeatTime: Int) -> SKAction {
    
    let atlas = self.getAtlasByName(atlasName)
//    atlas.preloadWithCompletionHandler() {
//      NSLog("Atlas preloaded: \(atlasName)")
//    }
    
    var textureSeq = [SKTexture]()
    
    for i in frameRange {
      textureSeq.append(atlas.textureNamed("\(atlasName)_\(self.frameIndexFormat(i))"))
    }
    
    let duration = self.sharedInstance.timePerFrame * NSTimeInterval(textureSeq.count)
    var action = SKAction.animateWithTextures(textureSeq, timePerFrame: self.sharedInstance.timePerFrame, resize: true, restore: false)
    
    return SKAction.repeatAction(SKAction.group([action, SKAction.waitForDuration(duration)]), count: repeatTime)
  }
  
  public class func clearFrameCache () {
    
    
//    clearBearDancingCache()
//    clearBearWavingCache()
//    clearBearDancing2Cache()
//    clearBearHighfiveCache()
//    clearBearScratchingCache()
//    clearBearTwistingCache()
//    
//    self.releaseBearAtlas()
    
  }
  
  public class func clearBearDancingCache () {
    BearDancing.onceToken = 0
    BearDancing.instance = nil
    
//    self.releaseBearDancingAtlas()
  }
  
  public class func clearBearWavingCache () {
    BearWaving.onceToken = 0
    BearWaving.instance = nil
    
//    self.releaseBearWavingAtlas()
  }
  
  public class func clearBearDancing2Cache () {
    BearDancing2.onceToken = 0
    BearDancing2.instance = nil
    
//    self.releaseBearDancing2Atlas()
  }
  
  public class func clearBearHighfiveCache () {
    BearHighfive.onceToken = 0
    BearHighfive.instance = nil
    
//    self.releaseBearHighfiveAtlas()
  }
  
  public class func clearBearScratchingCache () {
    BearScratching.onceToken = 0
    BearScratching.instance = nil
    
//    self.releaseBearScratchingAtlas()
  }
  
  public class func clearBearTwistingCache () {
    BearTwisting.onceToken = 0
    BearTwisting.instance = nil
    
//    self.releaseBearTwistingAtlas()
  }
  
  
  public class func bearWaving () -> SKAction {
    
    
    /* evaluate only once */
    
    
    dispatch_once(&BearWaving.onceToken) {
    
      let atlasName = "bear_waving"
      var actionSeq = [SKAction]()
      
      /* 0: 8 times */
      actionSeq.append(self.playframes(atlasName: atlasName, frameRange: 0...0, repeatTime: 8))
      
      /* 8-29: 1 time */
      actionSeq.append(self.playframes(atlasName: atlasName, frameRange: 8...29, repeatTime: 1))
      
      /* 30-36: 2 times */
      actionSeq.append(self.playframes(atlasName: atlasName, frameRange: 30...36, repeatTime: 2))
      
      /* 45: 13 times */
      actionSeq.append(self.playframes(atlasName: atlasName, frameRange: 45...45, repeatTime: 13))
      
      /* 58-59: 1 time */
      actionSeq.append(self.playframes(atlasName: atlasName, frameRange: 58...59, repeatTime: 1))
      
      
      BearWaving.instance = SKAction.sequence(actionSeq)
    }
  
    return BearWaving.instance!
  }
  
  public class func bearWavingHelmet () -> SKAction {
    let atlasName = "bear_waving_helmet"
    var actionSeq:[SKAction] = []
    
    /* 0: 8 times */
    actionSeq.append(self.playframes(atlasName: atlasName, frameRange: 0...0, repeatTime: 8))
    
    /* 8-29: 1 time */
    actionSeq.append(self.playframes(atlasName: atlasName, frameRange: 2...23, repeatTime: 1))
    
    /* 30-36: 2 times */
    actionSeq.append(self.playframes(atlasName: atlasName, frameRange: 24...30, repeatTime: 2))
    
    /* 45: 13 times */
    actionSeq.append(self.playframes(atlasName: atlasName, frameRange: 31...31, repeatTime: 13))
    
    /* 58-59: 1 time */
    actionSeq.append(self.playframes(atlasName: atlasName, frameRange: 32...33, repeatTime: 1))
    
    
    return SKAction.sequence(actionSeq)
  }
  
  public class func bearDancing () -> SKAction {
    
    
    /* evaluate only once */
    
    
    dispatch_once(&BearDancing.onceToken) {
    
      let atlasName = "bear_dancing"
      
      var actionSeq = [SKAction]()
      
      /* jumping */
      /* 607: 1 time */
      actionSeq.append(self.playframes(atlasName: atlasName, frameRange: 607...607, repeatTime: 1))
      
      /* 608: 5 times */
      actionSeq.append(self.playframes(atlasName: atlasName, frameRange: 608...608, repeatTime: 5))
      
      /* 613: 4 times */
      actionSeq.append(self.playframes(atlasName: atlasName, frameRange: 613...613, repeatTime: 4))
      
      /* 617: 1 time */
      actionSeq.append(self.playframes(atlasName: atlasName, frameRange: 617...617, repeatTime: 1))
      
      /* 618-633: 5 times */
      actionSeq.append(self.playframes(atlasName: atlasName, frameRange: 618...633, repeatTime: 5))
      
      /* 613: 1 time */
      actionSeq.append(self.playframes(atlasName: atlasName, frameRange: 613...613, repeatTime: 1))
      
      /* 699: 1 time */
      actionSeq.append(self.playframes(atlasName: atlasName, frameRange: 699...699, repeatTime: 1))
      
      /* twisting */
      /* 700-757: 1 time */
      actionSeq.append(self.playframes(atlasName: atlasName, frameRange: 700...757, repeatTime: 1))
      
      /* 607: 2 times */
      actionSeq.append(self.playframes(atlasName: atlasName, frameRange: 607...607, repeatTime: 2))
      
      
      BearDancing.instance = SKAction.sequence(actionSeq)
    }
    
    return BearDancing.instance!
  }
  
  public class func bearDancingHelmet () -> SKAction {
    let atlasName = "bear_dancing_helmet"
    
    var actionSeq = [SKAction]()
    
    /* jumping */
    /* 607: 1 time */
    actionSeq.append(self.playframes(atlasName: atlasName, frameRange: 0...0, repeatTime: 1))
    
    /* 608: 5 times */
    actionSeq.append(self.playframes(atlasName: atlasName, frameRange: 1...1, repeatTime: 5))
    
    /* 613: 4 times */
    actionSeq.append(self.playframes(atlasName: atlasName, frameRange: 2...2, repeatTime: 4))
    
    /* 617: 1 time */
    actionSeq.append(self.playframes(atlasName: atlasName, frameRange: 3...3, repeatTime: 1))
    
    /* 618-633: 5 times */
    actionSeq.append(self.playframes(atlasName: atlasName, frameRange: 4...19, repeatTime: 5))
    
    /* 613: 1 time */
    actionSeq.append(self.playframes(atlasName: atlasName, frameRange: 2...2, repeatTime: 1))
    
    /* 699: 1 time */
    actionSeq.append(self.playframes(atlasName: atlasName, frameRange: 21...21, repeatTime: 1))
    
    /* twisting */
    /* 700-757: 1 time */
    actionSeq.append(self.playframes(atlasName: atlasName, frameRange: 22...79, repeatTime: 1))
    
    /* 607: 2 times */
    actionSeq.append(self.playframes(atlasName: atlasName, frameRange: 0...0, repeatTime: 2))
    
    
    return SKAction.sequence(actionSeq)
  }
  
  public class func bearDancing2 () -> SKAction {
    
    
    /* evaluate only once */
    
    
    dispatch_once(&BearDancing2.onceToken) {
      
      let atlasName = "bear_dancing2"
      
      var actionSeq = [SKAction]()
      
      /* jumping */
      /* 24: 2 times */
      actionSeq.append(self.playframes(atlasName: atlasName, frameRange: 24...24, repeatTime: 2))
      
      /* 36-47: 2 times */
      actionSeq.append(self.playframes(atlasName: atlasName, frameRange: 36...47, repeatTime: 2))
      
      /* 60-61: 1 time */
      actionSeq.append(self.playframes(atlasName: atlasName, frameRange: 60...61, repeatTime: 1))
      
      /* 24: 2 times */
      actionSeq.append(self.playframes(atlasName: atlasName, frameRange: 24...24, repeatTime: 2))
      
      
      BearDancing2.instance = SKAction.sequence(actionSeq)
    }
    
    return BearDancing2.instance!
  }

  public class func bearHighfive () -> SKAction {
    
    
    /* evaluate only once */
    
    
    dispatch_once(&BearHighfive.onceToken) {
      
      let atlasName = "bear_highfive"
      
      var actionSeq = [SKAction]()
      
      /* jumping */
      /* 86-97: 1 time */
      actionSeq.append(self.playframes(atlasName: atlasName, frameRange: 86...97, repeatTime: 1))
      
      /* 98-108: 2 times (no 104) */
      actionSeq.append(self.playframes(atlasName: atlasName, frameRange: 98...103, repeatTime: 1))
      actionSeq.append(self.playframes(atlasName: atlasName, frameRange: 105...108, repeatTime: 1))
      actionSeq.append(self.playframes(atlasName: atlasName, frameRange: 98...103, repeatTime: 1))
      actionSeq.append(self.playframes(atlasName: atlasName, frameRange: 105...108, repeatTime: 1))
      
      /* 86: 3 times */
      actionSeq.append(self.playframes(atlasName: atlasName, frameRange: 86...86, repeatTime: 3))
      
      
      BearHighfive.instance = SKAction.sequence(actionSeq)
    }
    
    return BearHighfive.instance!
  }

  public class func bearScratching () -> SKAction {
    
    
    /* evaluate only once */
    
    
    dispatch_once(&BearScratching.onceToken) {
      
      let atlasName = "bear_scratching"
      
      var actionSeq = [SKAction]()
      
      /* jumping */
      /* 302: 3 time */
      actionSeq.append(self.playframes(atlasName: atlasName, frameRange: 302...302, repeatTime: 3))
      
      /* 313-322: 3 times */
      actionSeq.append(self.playframes(atlasName: atlasName, frameRange: 313...322, repeatTime: 3))
      
      /* 340: 2 times */
      actionSeq.append(self.playframes(atlasName: atlasName, frameRange: 340...340, repeatTime: 2))
      
      /* 360: 3 time */
      actionSeq.append(self.playframes(atlasName: atlasName, frameRange: 360...360, repeatTime: 3))
      
      
      BearScratching.instance = SKAction.sequence(actionSeq)
    }
    
    return BearScratching.instance!
  }

  public class func bearTwisting () -> SKAction {
    
    
    /* evaluate only once */
    
    
    dispatch_once(&BearTwisting.onceToken) {
      
      let atlasName = "bear_twisting"
      
      var actionSeq = [SKAction]()
      
      /* jumping */
      /* 137: 3 times */
      actionSeq.append(self.playframes(atlasName: atlasName, frameRange: 137...137, repeatTime: 3))
      
      /* 139-140: 1 time */
      actionSeq.append(self.playframes(atlasName: atlasName, frameRange: 139...140, repeatTime: 1))
      
      /* 141-152: 2 times */
      actionSeq.append(self.playframes(atlasName: atlasName, frameRange: 141...152, repeatTime: 2))
      
      /* 179: 1 time */
      actionSeq.append(self.playframes(atlasName: atlasName, frameRange: 179...179, repeatTime: 1))
      
      /* 180: 7 times */
      actionSeq.append(self.playframes(atlasName: atlasName, frameRange: 180...180, repeatTime: 7))
      
      
      BearTwisting.instance = SKAction.sequence(actionSeq)
    }
    
    return BearTwisting.instance!
  }
  
  public class func showObjectsTimerInterval () -> SKAction {
    return SKAction.waitForDuration(0.2)
  }
  
  public class func repeatNameTimerInterval () -> SKAction {
    return SKAction.waitForDuration(10)
  }
  
  
  
}
