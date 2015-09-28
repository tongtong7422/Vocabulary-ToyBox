//
//  GlobalConfiguration.swift
//  Cognitive ToyBox
//
//  Created by Heng Lyu on 7/30/14.
//  Copyright (c) 2014 Cognitive ToyBox. All rights reserved.
//

import UIKit
import SpriteKit
import CoreData
import MediaPlayer

//let _globalConfigurationInstance = GlobalConfiguration()

public enum Stages: Int {
  case First = 0, Second, Third, All, Tutorial, Test
  static let allValues = [First, Second, Third]
//  static let categoriesPerStage = 5
//  
//  var numObjects: Int {
//    get {
//      return (self.toRaw()+1) * Stages.categoriesPerStage
//    }
//  }
  static let difficultyLevels = [NSSet(array: Array(CognitiveToyBoxObject.stage1Objects)), NSSet(array: Array(CognitiveToyBoxObject.stage2Objects)), NSSet(array: Array(CognitiveToyBoxObject.stage3Objects))]
  var searchCategory: NSSet {
    get {
      if self == Tutorial {
        return NSSet(array: Array(CognitiveToyBoxObject.tutorialObjects))
      }
      if self == Test {
        return NSSet(array: Array(CognitiveToyBoxObject.testObjects))
      }
      
      if self != All {
        return Stages.difficultyLevels[self.rawValue]
      }
      
      /* All returns all categories */
      var allCategories = NSMutableSet()
      for level in Stages.difficultyLevels {
        allCategories.unionSet(level as Set<NSObject>)
      }
            
      return allCategories
    }
  }
  
}

public enum Tasks {
  case Match, Vocabulary, Drag, Bucket, Some, Material, Color, Length
  
}

public enum ObjectPresentMode: String {
  case Shake = "Shake"
  case ZoomInAndOut = "ZoomInAndOut"
  case Bounce = "Bounce"
  case DoNothing = "DoNothing"
  static let allValues = [Shake, ZoomInAndOut, Bounce, DoNothing]
}

public enum BackgroundImageNames: String {
  case Classroom = "classroom"
  case Forest = "forest"
  case Space = "space"
  case White = "none"
  case Demo1 = "demo_bg_1"
  case Demo2 = "demo_bg_2"
  
  public static let allValues = [Classroom, Forest, Space, White]
  public static let autoSwitchValues = [Classroom, Forest, Space]
//  public static let allValues = [Demo1, Demo2]
//  public static let autoSwitchValues = [Demo1, Demo2]
  public static let noneValue = White
  
  public var blurredBackground:String {
    get {
      return self.rawValue + "_blur"
    }
  }
  
  public func prev () -> BackgroundImageNames? {
    let seq = BackgroundImageNames.autoSwitchValues
    for i in 0..<seq.count {
      if self == seq[i] {
        return i-1<0 ? nil:seq[i-1]
      }
    }
    
    return seq[0]
  }
  
  public func succ () -> BackgroundImageNames? {
    let seq = BackgroundImageNames.autoSwitchValues
    for i in 0..<seq.count {
      if self == seq[i] {
        return i+1>=seq.count ? nil:seq[i+1]
      }
    }
    
    return seq[0]
  }
  
  
}

public enum RewardSoundName: String {
  //  case Voice = "_found"
  case RightToneOne = "right_tone"
  case RightToneTwo = "right tone2"
  
  static let allValues = [RightToneOne, RightToneTwo]
  
  func soundName (objectName: String) -> String {
    switch self {
      //    case .Voice: return objectName.stringByAppendingString(self.toRaw())
    default: return self.rawValue
    }
    
  }
}

public enum ErrorSoundName: String {
  //  case Voice = "try_again"
  case WrongToneA = "wrong tone a"
  case WrongToneB = "wrong tone b"
  case WrongToneC = "wrong tone c"
  
  static let allValues = [WrongToneA, WrongToneB, WrongToneC]
  
  func soundName (objectName: String) -> String {
    return self.rawValue
  }
}

public enum TouchSoundName: String {
  case Pew = "pew"
  case SqueezeOne = "squeeze-toy-1"
  case SqueezeThree = "squeeze-toy-3"
  case SqueezeFour = "squeeze-toy-4"
  
  public static let allValues = [Pew, SqueezeOne, SqueezeThree, SqueezeFour]
  
  public static func getRandom () -> TouchSoundName {
    return allValues[Int(arc4random_uniform(UInt32(allValues.count)))]
  }
}

public enum PlaytimeSongName: String {
  case FirstSong = "bensound-funnysong_30sec"
  case SecondSong = "bensound_jazzyfrenchy_30sec"
  
  static let allValues = [FirstSong, SecondSong]
}

/* Observer pattern: Observers */
@objc public protocol ConfigurableGameController {
  
  var stage: Stages.RawValue { get set }
//  var categories: NSSet { get set }
  
  var numMatchingTasksBeforeFakeObjects: Int { get set }
  var numFakeObjectsAfterMatchingTasks: Int { get set }
  
  var numMatchingTasksBeforeVocabularyWords: Int { get set }
  var numVocabularyWordsAfterMatchingTasks: Int { get set }
  
}

@objc public protocol ConfigurableScene {
  var background: SKSpriteNode! { get set }
  optional var isBlurred: Bool { get }
  
  optional func hideNextButton (hidden: Bool)
  optional func hideBear (hidden: Bool)
}

@objc public protocol ConfigurableActionHelper {
  var newSessionInterval: NSTimeInterval { get set }
  var objectPresentMode: ObjectPresentMode.RawValue { get set }
  var playtimeInterval: NSTimeInterval { get set }
}

@objc public protocol ConfigurableSoundSourceHelper {
  var rewardSoundName: RewardSoundName.RawValue { get set }
  var errorSoundName: ErrorSoundName.RawValue { get set }
  var playtimeSongName: PlaytimeSongName.RawValue { get set }
  
  func mute(boolValue:Bool)
}

/* Observer pattern: Model */
public class GlobalConfiguration: NSObject, NSCoding {
  
  /* registered observers */
  private var gameControllers = NSMutableArray()
  private var scenes = NSMutableArray()
  private var actionHelpers = NSMutableArray()
  private var soundHelpers = NSMutableArray()
  
  
  /* game controller parameters */
//  private var _categories = NSSet()
//  public class var categories: NSSet {
//    get {
//    return self.sharedInstance._categories
//    }
//    set {
//      var instance = self.sharedInstance
//      instance._categories = newValue
//      instance.updateGameControllers() {
//        (gameController: ConfigurableGameController) -> () in
//        gameController.categories = instance._categories
//      }
//    }
//  }
  
  private let _labelFont: String = "ZNuscriptHeavy"//"Vag Round"
  public class var labelFont: String {
    get {
      return self.sharedInstance._labelFont
    }
  }
  
  
  private var _numMatchingTasksBeforeFakeObjects: Int! = nil
  public class var numMatchingTasksBeforeFakeObjects: Int {
    get {
    return self.sharedInstance._numMatchingTasksBeforeFakeObjects
    }
    set {
      var instance = self.sharedInstance
      instance._numMatchingTasksBeforeFakeObjects = newValue
      instance.updateGameControllers() {
        (gameController: ConfigurableGameController) -> () in
        gameController.numMatchingTasksBeforeFakeObjects = instance._numMatchingTasksBeforeFakeObjects
      }
    }
  }
  private let numMatchingTasksBeforeFakeObjectsStr = "numMatchingTasksBeforeFakeObjects"
  
  
  
  private var _numFakeObjectsAfterMatchingTasks: Int! = nil
  public class var numFakeObjectsAfterMatchingTasks: Int {
    get {
    return self.sharedInstance._numFakeObjectsAfterMatchingTasks
    }
    set {
      var instance = self.sharedInstance
      instance._numFakeObjectsAfterMatchingTasks = newValue
      instance.updateGameControllers() {
        (gameController: ConfigurableGameController) -> () in
        gameController.numFakeObjectsAfterMatchingTasks = instance._numFakeObjectsAfterMatchingTasks
      }
    }
  }
  private let numFakeObjectsAfterMatchingTasksStr = "numFakeObjectsAfterMatchingTasks"
  
  
  
  private var _numMatchingTasksBeforeVocabularyWords: Int! = nil
  public class var numMatchingTasksBeforeVocabularyWords: Int {
    get {
    return self.sharedInstance._numMatchingTasksBeforeVocabularyWords
    }
    set {
      var instance = self.sharedInstance
      instance._numMatchingTasksBeforeVocabularyWords = newValue
      instance.updateGameControllers() {
        (gameController: ConfigurableGameController) -> () in
        gameController.numMatchingTasksBeforeVocabularyWords = instance._numMatchingTasksBeforeVocabularyWords
      }
    }
  }
  private let numMatchingTasksBeforeVocabularyWordsStr = "numMatchingTasksBeforeVocabularyWords"
  
  
  
  private var _numVocabularyWordsAfterMatchingTasks: Int! = nil
  public class var numVocabularyWordsAfterMatchingTasks: Int {
    get {
    return self.sharedInstance._numVocabularyWordsAfterMatchingTasks
    }
    set {
      var instance = self.sharedInstance
      instance._numVocabularyWordsAfterMatchingTasks = newValue
      instance.updateGameControllers() {
        (gameController: ConfigurableGameController) -> () in
        gameController.numVocabularyWordsAfterMatchingTasks = instance._numVocabularyWordsAfterMatchingTasks
      }
    }
  }
  private let numVocabularyWordsAfterMatchingTasksStr = "numVocabularyWordsAfterMatchingTasks"
  
  
  
  private var _stage: Stages! = nil
  public class var stage: Stages! {
    get {
    return self.sharedInstance._stage
    }
    set {
      var instance = self.sharedInstance
      instance._stage = newValue
      instance.updateGameControllers() {
        (gameController: ConfigurableGameController) -> () in
        gameController.stage = instance._stage.rawValue
      }
    }
  }
  private let stageStr = "stage"
  
  
  private let _minDaysBeforeStageUpdate: Int = 2
  private var _lastStageUpdate: NSDate! = nil
  public class func checkStageUpdate () {
    var instance = self.sharedInstance
    let now = NSDate(timeIntervalSinceNow: 0)
    
    /* check interval since last update */
    if instance._lastStageUpdate != nil {
      let calendar = NSCalendar.currentCalendar()
//      let components = calendar.components(.CalendarUnitDay, fromDate: instance._lastStageUpdate, toDate: now, options: nil)
      let components = calendar.components(NSCalendarUnit.NSDayCalendarUnit, fromDate: instance._lastStageUpdate, toDate: now, options: NSCalendarOptions(rawValue: 0))
      if components.day <= instance._minDaysBeforeStageUpdate {
        return
      }
      
    }
    
    
    /* check performance in last two days */
    var performance: [String: PerformanceData]
    
    for days in 0..<instance._minDaysBeforeStageUpdate {
      var dateFrom = DateHelper.getSomeDaysEarlier(now, days: days+1)
      var dateTo = DateHelper.getSomeDaysEarlier(now, days: days)
      
      
//      performance = UserPerformanceHelper.getPerformanceBetween(dateFrom: dateFrom, dateTo: dateTo)
      performance = UserPerformanceHelper.getPerformance()
      
      if performance.isEmpty {
        return
      }
      for (key, value) in performance {
        if value.accuracy != 1 {
          return
        }
      }
    }
    
    /* check if all names are learned */
    //    var firstViewedNames = UserPerformanceHelper.getFirstViewedNames(dateFrom: NSDate(timeIntervalSinceReferenceDate: 0), dateTo: now)
    //    if firstViewedNames.count != instance._stage.numObjects {
    //      return
    //    }
    
    
    /* update stage */
//    var rawStage = self.stage.toRaw()
//    if Stages.fromRaw(rawStage+1) == nil {
//      return
//    }
//    instance._lastStageUpdate = now
//    self.stage = Stages.fromRaw(rawStage+1)!
  }
  public class var lastStageUpdate: NSDate! {
    get {
      return self.sharedInstance._lastStageUpdate
    }
  }
  private let lastStageUpdateStr = "lastStageUpdate"
  
  
  
  
  /* scene background */
  private var _backgroundImageName: BackgroundImageNames! = nil
  public class var backgroundImageName: BackgroundImageNames! {
    get {
    return self.sharedInstance._backgroundImageName
    }
    set {
      var instance = self.sharedInstance
      instance._backgroundImageName = newValue
      
      instance.updateScenes(instance.applySettings)
    }
  }
  private let backgroundImageNameStr = "backgroundImageName"
  
  
  /* background auto switch */
  private var _backgroundAutoSwitch: Int! = nil
  private var _sessionsPassed: Int = 0
  public class func restartSessionsCount () {
    self.sharedInstance._sessionsPassed = 0
  }
  
  public class func passOneSession () {
    var instance = self.sharedInstance
    
    if !instance._allowBackgroundAutoSwitch || instance._backgroundAutoSwitch <= 0 {
      return
    }
    
    if ++instance._sessionsPassed > instance._backgroundAutoSwitch {
      self.switchBackground(instance._backgroundImageName.succ())
      instance._sessionsPassed = 1
    }
  }
  
  public class var backgroundAutoSwitch: Int! {
    get {
    return self.sharedInstance._backgroundAutoSwitch
    }
    set {
      self.sharedInstance._backgroundAutoSwitch = newValue
      self.sharedInstance._sessionsPassed = 0
    }
  }
  private let backgroundAutoSwitchStr = "backgroundAutoSwitch"
  
  public class func switchBackground (background: BackgroundImageNames? = nil) {
    if background == nil {
      switchBackground(BackgroundImageNames.allValues[0])
    } else {
      self.backgroundImageName = background
    }
  }
  
  
  private var _allowBackgroundAutoSwitch: Bool! = nil
  public class var allowBackgroundAutoSwitch: Bool {
    get {
    return self.sharedInstance._allowBackgroundAutoSwitch
    }
    set {
      self.sharedInstance._allowBackgroundAutoSwitch = newValue
    }
  }
  private let allowBackgroundAutoSwitchStr = "allowBackgroundAutoSwitch"
  
  
  
  
  /* next button */
  private var _nextButtonHidden: Bool! = nil
  public class var nextButtonHidden: Bool {
    get {
    return self.sharedInstance._nextButtonHidden
    }
    set {
      var instance = self.sharedInstance
      instance._nextButtonHidden = newValue
      instance.updateScenes() {
        (scene: ConfigurableScene) -> () in
        if scene.hideNextButton != nil {
          scene.hideNextButton!(instance._nextButtonHidden)
        }
      }
    }
  }
  private let nextButtonHiddenStr = "nextButtonHidden"
  
  
  
  /* bear */
  private var _bearHidden: Bool! = nil
  public class var bearHidden: Bool {
    get {
    return self.sharedInstance._bearHidden
    }
    set {
      var instance = self.sharedInstance
      instance._bearHidden = newValue
      instance.updateScenes() {
        (scene: ConfigurableScene) -> () in
        if scene.hideBear != nil {
          scene.hideBear!(instance._bearHidden)
        }
      }
      
      if instance._bearHidden != nil && instance._bearHidden! {
        ActionHelper.clearFrameCache()
      }
    }
  }
  private let bearHiddenStr = "bearHidden"
  
  
  
  
  /* actions parameters */
  private var _newSessionInterval: NSTimeInterval! = nil
  public class var newSessionInterval: NSTimeInterval! {
    get {
    return self.sharedInstance._newSessionInterval
    }
    set {
      var instance = self.sharedInstance
      instance._newSessionInterval = newValue
      instance.updateActionHelpers() {
        (actionHelper: ConfigurableActionHelper) -> () in
        actionHelper.newSessionInterval = instance._newSessionInterval
      }
    }
  }
  private let newSessionIntervalStr = "newSessionInterval"
  
  
  
  
  private var _objectPresentMode: ObjectPresentMode! = nil
  public class var objectPresentMode: ObjectPresentMode! {
    get {
    return self.sharedInstance._objectPresentMode
    }
    set {
      var instance = self.sharedInstance
      instance._objectPresentMode = newValue
      instance.updateActionHelpers() {
        (actionHelper: ConfigurableActionHelper) -> () in
        actionHelper.objectPresentMode = instance._objectPresentMode.rawValue
      }
    }
  }
  private let objectPresentModeStr = "objectPresentMode"
  
  
  private var _playtimeInterval: NSTimeInterval! = nil
  public class var playtimeInterval: NSTimeInterval! {
    get {
    return self.sharedInstance._playtimeInterval
    }
    set {
      var instance = self.sharedInstance
      instance._playtimeInterval = newValue
      instance.updateActionHelpers() {
        (actionHelper: ConfigurableActionHelper) -> () in
        actionHelper.playtimeInterval = instance._playtimeInterval
      }
    }
  }
  private let playtimeIntervalStr = "playtimeInterval"
  
  
  
  /* sound source */
  private var _rewardSoundName: RewardSoundName! = nil
  public class var rewardSoundName: RewardSoundName! {
    get {
    return self.sharedInstance._rewardSoundName
    }
    set {
      var instance = self.sharedInstance
      instance._rewardSoundName = newValue
      instance.updateSoundHelpers() {
        (soundHelper: ConfigurableSoundSourceHelper) -> () in
        soundHelper.rewardSoundName = instance._rewardSoundName.rawValue
      }
    }
  }
  private let rewardSoundNameStr = "rewardSoundName"
  
  
  
  
  private var _errorSoundName: ErrorSoundName! = nil
  public class var errorSoundName: ErrorSoundName! {
    get {
    return self.sharedInstance._errorSoundName
    }
    set {
      var instance = self.sharedInstance
      instance._errorSoundName = newValue
      instance.updateSoundHelpers() {
        (soundHelper: ConfigurableSoundSourceHelper) -> () in
        soundHelper.errorSoundName = instance._errorSoundName.rawValue
      }
    }
  }
  private let errorSoundNameStr = "errorSoundName"
  
  
  
  
  private var _playtimeSongName: PlaytimeSongName! = nil
  public class var playtimeSongName: PlaytimeSongName! {
    get {
    return self.sharedInstance._playtimeSongName
    }
    set {
      var instance = self.sharedInstance
      instance._playtimeSongName = newValue
      instance.updateSoundHelpers() {
        (soundHelper: ConfigurableSoundSourceHelper) -> () in
        soundHelper.playtimeSongName = instance._playtimeSongName.rawValue
      }
    }
  }
  private let playtimeSongNameStr = "playtimeSongName"
  
  
  /* convert settings to string (may be deleted in next version) */
  override public var description: String {
    get {
      var str = ""
      
      /* User Level */
      str += "User Level: "
      switch self._stage! {
      case .First:
        str += "Beginner"
      case .Second:
        str += "Second"
      case .Third:
        str += "Advanced"
      default:
        break
      }
      
      
      str += " | "
      
      
      
      return str
    }
  }
  public class func getDescription () -> String {
    return self.sharedInstance.description
  }
  
  private var _muted:Bool = false
  public class var muted:Bool {
    get {
      return self.sharedInstance._muted
    }
    set {
      self.sharedInstance._muted = newValue
      self.sharedInstance.updateSoundHelpers { (soundHelper) -> () in
        soundHelper.mute(newValue)
      }
      
    }
  }
  private let muteStr = "mute"
  
  
  /* NSCoding */
  public func encodeWithCoder(aCoder: NSCoder) {
    
    /* game controller */
    aCoder.encodeInteger(_numMatchingTasksBeforeFakeObjects, forKey: numMatchingTasksBeforeFakeObjectsStr)
    aCoder.encodeInteger(_numFakeObjectsAfterMatchingTasks, forKey: numFakeObjectsAfterMatchingTasksStr)
    aCoder.encodeInteger(_numMatchingTasksBeforeVocabularyWords, forKey: numMatchingTasksBeforeVocabularyWordsStr)
    aCoder.encodeInteger(_numVocabularyWordsAfterMatchingTasks, forKey: numVocabularyWordsAfterMatchingTasksStr)
    aCoder.encodeInteger(_stage.rawValue, forKey: stageStr)
    aCoder.encodeObject(_lastStageUpdate, forKey: lastStageUpdateStr)
    
    /* scene */
    aCoder.encodeObject(_backgroundImageName.rawValue, forKey: backgroundImageNameStr)
    aCoder.encodeInteger(_backgroundAutoSwitch, forKey: backgroundAutoSwitchStr)
    aCoder.encodeBool(_allowBackgroundAutoSwitch, forKey: allowBackgroundAutoSwitchStr)
    aCoder.encodeBool(_nextButtonHidden, forKey: nextButtonHiddenStr)
    aCoder.encodeBool(_bearHidden, forKey: bearHiddenStr)
    
    /* actions */
    aCoder.encodeDouble(_newSessionInterval, forKey: newSessionIntervalStr)
    aCoder.encodeObject(_objectPresentMode.rawValue, forKey: objectPresentModeStr)
    aCoder.encodeDouble(_playtimeInterval, forKey: playtimeIntervalStr)
    
    /* sound source */
    aCoder.encodeObject(_rewardSoundName.rawValue, forKey: rewardSoundNameStr)
    aCoder.encodeObject(_errorSoundName.rawValue, forKey: errorSoundNameStr)
    aCoder.encodeObject(_playtimeSongName.rawValue, forKey: playtimeSongNameStr)
    
  }
  public required init(coder aDecoder: NSCoder) {
    super.init()
    
    /* game controller */
    _numMatchingTasksBeforeFakeObjects = aDecoder.decodeIntegerForKey(numMatchingTasksBeforeFakeObjectsStr)
    
    /* scene */
    
    /* actions */
    
    /* sound source */
    
    /* update settings */
    updateAll()
    
  }
  
  private override init() {
    super.init()
    resetAll()
  }
  
  /* Singleton pattern */
  class var sharedInstance: GlobalConfiguration {
    get {
      struct Static {
        static var onceToken: dispatch_once_t = 0
        static var instance: GlobalConfiguration? = nil
      }
      
      dispatch_once(&Static.onceToken) {
        Static.instance = GlobalConfiguration()
      }
      
      return Static.instance!
    }
  }
  
  /* add */
  public class func addGameController (gameController: ConfigurableGameController) {
    var instance = self.sharedInstance
    if instance.gameControllers.containsObject(gameController) {
      return
    }
    instance.gameControllers.addObject(gameController)
    instance.applySettings(gameController)
  }
  public class func addScene (scene: ConfigurableScene) {
    var instance = self.sharedInstance
    if instance.scenes.containsObject(scene) {
      return
    }
    instance.scenes.addObject(scene)
    instance.applySettings(scene)
  }
  public class func addActionHelper (actionHelper: ConfigurableActionHelper) {
    var instance = self.sharedInstance
    if instance.actionHelpers.containsObject(actionHelper) {
      return
    }
    instance.actionHelpers.addObject(actionHelper)
    instance.applySettings(actionHelper)
  }
  public class func addSoundHelper (soundHelper: ConfigurableSoundSourceHelper) {
    var instance = self.sharedInstance
    if instance.soundHelpers.containsObject(soundHelper) {
      return
    }
    instance.soundHelpers.addObject(soundHelper)
    instance.applySettings(soundHelper)
  }
  
  /* remove */
  public class func removeGameController (gameController: ConfigurableGameController) {
    self.sharedInstance.gameControllers.removeObject(gameController)
  }
  public class func removeScene (scene: ConfigurableScene) {
    self.sharedInstance.scenes.removeObject(scene)
  }
  public class func removeActionHelper (actionHelper: ConfigurableActionHelper) {
    self.sharedInstance.actionHelpers.removeObject(actionHelper)
  }
  public class func removeSoundHelper (soundHelper: ConfigurableSoundSourceHelper) {
    self.sharedInstance.soundHelpers.removeObject(soundHelper)
  }
  
  /* applySettings */
  private func applySettings (gameController: ConfigurableGameController) {
    gameController.stage = self._stage.rawValue
//    gameController.categories = self._categories
    gameController.numMatchingTasksBeforeFakeObjects = self._numMatchingTasksBeforeFakeObjects
    gameController.numFakeObjectsAfterMatchingTasks = self._numFakeObjectsAfterMatchingTasks
    gameController.numMatchingTasksBeforeVocabularyWords = self._numMatchingTasksBeforeVocabularyWords
    gameController.numVocabularyWordsAfterMatchingTasks = self._numVocabularyWordsAfterMatchingTasks
  }
  private func applySettings (scene: ConfigurableScene) {
    
    
    if self._backgroundImageName == .White {
      
      if scene.background == nil {
        var size = SKSpriteNode(imageNamed: BackgroundImageNames.Classroom.rawValue).size
        scene.background = SKSpriteNode(color: UIColor.whiteColor(), size: size)
      } else {
        scene.background.color = UIColor.whiteColor()
        scene.background.texture = nil
      }
    } else {
      
      let backgroundImageName = (scene.isBlurred != nil && scene.isBlurred!) ? self._backgroundImageName.blurredBackground : self._backgroundImageName.rawValue
      
      if scene.background == nil {
        scene.background = SKSpriteNode(imageNamed: backgroundImageName)
      } else {
        
        scene.background.texture = SKTexture(imageNamed: backgroundImageName)
      }
    }
    
    if scene.hideNextButton != nil {
      scene.hideNextButton!(self._nextButtonHidden)
    }
    
    if scene.hideBear != nil {
      scene.hideBear!(self._bearHidden)
    }
  }
  private func applySettings (actionHelper: ConfigurableActionHelper) {
    actionHelper.newSessionInterval = self._newSessionInterval
    actionHelper.objectPresentMode = self._objectPresentMode.rawValue
    actionHelper.playtimeInterval = self._playtimeInterval
  }
  private func applySettings (soundHelper: ConfigurableSoundSourceHelper) {
    soundHelper.errorSoundName = self._errorSoundName.rawValue
    soundHelper.playtimeSongName = self._playtimeSongName.rawValue
    soundHelper.rewardSoundName = self._rewardSoundName.rawValue
  }
  
  
  /* update */
  private func updateAll () {
    updateGameControllers(applySettings)
    updateScenes(applySettings)
    updateActionHelpers(applySettings)
    updateSoundHelpers(applySettings)
  }
  private func updateGameControllers (pred: (ConfigurableGameController) -> ()) {
    for controller : AnyObject in self.gameControllers {
      pred(controller as! ConfigurableGameController)
    }
  }
  private func updateScenes (pred: (ConfigurableScene) -> ()) {
    for scene: AnyObject in self.scenes {
      pred(scene as! ConfigurableScene)
    }
  }
  private func updateActionHelpers (pred: (ConfigurableActionHelper) -> ()) {
    for actionHelper : AnyObject in self.actionHelpers {
      pred(actionHelper as! ConfigurableActionHelper)
    }
  }
  private func updateSoundHelpers (pred: (ConfigurableSoundSourceHelper) -> ()) {
    for soundHelper: AnyObject in self.soundHelpers {
      pred(soundHelper as! ConfigurableSoundSourceHelper)
    }
  }
  
  public func resetAll () {
    resetGameControllers()
    resetScenes()
    resetActionHelpers()
    resetSoundHelpers()
  }
  
  public func resetGameControllers() {
    self._stage = .Test
    self._numMatchingTasksBeforeFakeObjects = 5
    self._numFakeObjectsAfterMatchingTasks = 1
    self._numMatchingTasksBeforeVocabularyWords = 5
    self._numVocabularyWordsAfterMatchingTasks = 0
    
    updateGameControllers(applySettings)
  }
  public func resetScenes() {
    self._backgroundImageName = BackgroundImageNames.White
    self._backgroundAutoSwitch = 0
    self._nextButtonHidden = false
    self._bearHidden = true
    self._allowBackgroundAutoSwitch = true
    
    updateScenes(applySettings)
  }
  public func resetActionHelpers () {
    self._newSessionInterval = 120
    self._objectPresentMode = .DoNothing
    self._playtimeInterval = 30
    
    updateActionHelpers(applySettings)
  }
  public func resetSoundHelpers () {
    self._rewardSoundName = .RightToneOne
    self._errorSoundName = .WrongToneA
    self._playtimeSongName = .FirstSong
    
    updateSoundHelpers(applySettings)
  }
  
  
  
  
  /* core data related */
  private class func updateCoreData () {
    
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var context:NSManagedObjectContext = appDelegate.managedObjectContext
    
    
    NSLog("Scanning resources...")
    let objs = ImageSourceHelper.getObjFromDir()
    let objs_tutorial = ImageSourceHelper.getObjFromDir(true)
    NSLog("Done.")
    
    
    
    NSLog("Updating Core Data from Resource...")
    var newObj : NSManagedObject
    var saveError : NSErrorPointer = nil
    
    var categories = NSMutableSet()
    
    for obj in objs {
      
      newObj = NSEntityDescription.insertNewObjectForEntityForName("CTBObject", inManagedObjectContext: context) as! NSManagedObject
      
      newObj.setValue(obj.id, forKey: "id")
      newObj.setValue(obj.name, forKey: "name")
//      newObj.setValue(obj.material, forKey: "material")
//      newObj.setValue(obj.color, forKey: "color")
//      newObj.setValue(obj.suffix, forKey: "suffix")
      newObj.setValue(obj.filename, forKey: "filename")
      categories.addObject(obj.name)
      do {
        try context.save()

      } catch let error as NSError {
        // failure
        print("Fetch failed: \(error.localizedDescription)")
        ErrorLogger.logError(error, message: "Error updating object data")
      } catch {
        print("catched")
      }
//      context.save(saveError)
      
//      ErrorLogger.logError(saveError, message: "Error updating object data")
    }
    
    for obj in objs_tutorial {
      
      newObj = NSEntityDescription.insertNewObjectForEntityForName("CTBObject_tutorial", inManagedObjectContext: context) as! NSManagedObject
      
      newObj.setValue(obj.id, forKey: "id")
      newObj.setValue(obj.name, forKey: "name")
//      newObj.setValue(obj.material, forKey: "material")
//      newObj.setValue(obj.color, forKey: "color")
//      newObj.setValue(obj.suffix, forKey: "suffix")
      newObj.setValue(obj.filename, forKey: "filename")
      categories.addObject(obj.name)
      
      do {
        try context.save()
        
      } catch let error as NSError {
        // failure
        print("Fetch failed: \(error.localizedDescription)")
        ErrorLogger.logError(error, message: "Error updating tutorial data")
      }catch{
        print("catched")
      }
//      context.save(saveError)
      
//      ErrorLogger.logError(saveError, message: "Error updating tutorial data")
    }
    
//    GlobalConfiguration.categories = categories
    NSLog("Done.")
    
  }
  
  private class func clearCoreData () {
    
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var context:NSManagedObjectContext = appDelegate.managedObjectContext
    
    NSLog("Clearing Core Data...")
    var request = NSFetchRequest(entityName: "CTBObject")
    request.returnsObjectsAsFaults = false
    request.includesPropertyValues = false
    
    var error : NSErrorPointer = nil
    var saveError : NSErrorPointer = nil
//    var results : NSArray = context.executeFetchRequest(request, error: error)!
    var results = NSArray()
    do{
      results = try context.executeFetchRequest(request)
    }catch let error as NSError{
      print("Fetch failed: \(error.localizedDescription)")
      ErrorLogger.logError(error, message: "Error fetching object data")
    }catch{
      print("catched")
    }
    
//    ErrorLogger.logError(error, message: "Error fetching object data")
    
    if results.count > 0 {
      for res : AnyObject in results {
        context.deleteObject(res as! NSManagedObject)
      }
    }
    
    do {
      try context.save()
      
    } catch let error as NSError {
      // failure
      print("Fetch failed: \(error.localizedDescription)")
      ErrorLogger.logError(error, message: "Error clearing object data")
    }catch{
      print("catched")
    }
//    context.save(saveError)
    
//    ErrorLogger.logError(saveError, message: "Error clearing object data")
    
    /* clear tutorial data */
    request = NSFetchRequest(entityName: "CTBObject_tutorial")
    request.returnsObjectsAsFaults = false
    request.includesPropertyValues = false
    
//    results = context.executeFetchRequest(request, error: error)!
    do{
      results = try context.executeFetchRequest(request)
    }catch let error as NSError{
      print("Fetch failed: \(error.localizedDescription)")
      ErrorLogger.logError(error, message: "Error fetching tutorial data")

    }catch{
      print("catched")
    }
//    ErrorLogger.logError(error, message: "Error fetching tutorial data")
    
    if results.count > 0 {
      for res : AnyObject in results {
        context.deleteObject(res as! NSManagedObject)
      }
    }
    
    do {
      try context.save()
      
    } catch let error as NSError {
      // failure
      print("Fetch failed: \(error.localizedDescription)")
      ErrorLogger.logError(error, message: "Error clearing tutorial data")
    } catch{
      print("catched")
    }
//    context.save(saveError)
    
//    ErrorLogger.logError(saveError, message: "Error clearing tutorial data")
    NSLog("Done.")
    
  }
  
  public class func refreshCoreData () {
    self.clearCoreData()
    self.updateCoreData()
  }
  
  private class func releaseNode (node: SKNode?) {
    
    if node == nil {
      return
    }
    
    node!.removeFromParent()
    node!.removeAllActions()
    for child in node!.children {
      self.releaseNode(child as? SKNode)
    }
  }
  
  public class func releaseScene (scene: SKScene?) {
    
    if scene == nil {
      return
    }
    
    scene!.removeFromParent()
    scene!.removeAllActions()
    //    scene.removeAllChildren()
    self.releaseNode(scene)
    
    if scene!.conformsToProtocol(ConfigurableScene) {
      self.removeScene(scene as! ConfigurableScene)
    }
    
  }
  
}