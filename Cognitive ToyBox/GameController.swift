//
//  GameController.swift
//  Cognitive ToyBox
//
//  Created by Heng Lyu on 6/24/14.
//  Copyright (c) 2014 Cognitive ToyBox. All rights reserved.
//

import UIKit

/*
Control the core logic of the game.

The game can be described into two parts.

Part I
Show a random image from all categories, then pick two random images from the rest:
one with same name but different material or color;
the other with different name but either same material or color

The player is supposed to choose the object with the same name. If correctly chosen, go to part II

Part II
Show a bunch of images with the same name as the stored image. Three times in different distributions. Then start a new session.

GameController implements the following methods:

func startNewSession ()
pick and store a random object.

func getMainObj () -> CognitiveToyBoxObject
return the picked object. Must be called AFTER the session starts.

func getObjPair () -> (CognitiveToyBoxObject, CognitiveToyBoxObject)
return a pair of objects shown in the left and right block respectively (game rule part I).

func getListWithSameName () -> CognitiveToyBoxObject[]
return all objects with the same name as picked

*/



public class GameController: NSObject {
  
  /* constants */
  
  /* static variables defining parameters for task switching */
  private struct TaskManager {
//    static var matchCount: Int = 0
//    static var vocabularyCount: Int = 0
//    static var drag1Count: Int = 0
//    static var _isFakeTask: Bool = false  // Not Supported
//    static var _isVocabularyTask: Bool = false
    static var lastName: String? = nil
    static var task: Tasks = .Match
    static var taskQueue: [Tasks] = []
    static var taskQueueIndex = 0
    
    
    static func updateTaskQueue (gameController: GameController) {
      taskQueue = [.Match, .Drag1]
    }
    
    static func nextSession (gameController: GameController) {
      
      if taskQueue.isEmpty {
        return
      }
      task = taskQueue[taskQueueIndex]
      taskQueueIndex++
      taskQueueIndex %= taskQueue.count
    }
  }
  
  private var _stage: Stages = .First
  
  private var firstStageInitialized = false
  private var sessionPassed: Int = 0
  
  
  private var _mainObject : CognitiveToyBoxObject! = nil
  private var _sameNameObject : CognitiveToyBoxObject! = nil//USE LIST
  private var _diffNameObject : CognitiveToyBoxObject! = nil
  
  private var _firstObject : CognitiveToyBoxObject! = nil
  private var _secondObject : CognitiveToyBoxObject! = nil
  
  private var _sameNameObjectList: [CognitiveToyBoxObject] = []
  private var _diffNameObjectList: [CognitiveToyBoxObject] = []
  private var _firstObjectList: [CognitiveToyBoxObject] = []
  private var _secondObjectList: [CognitiveToyBoxObject] = []
  
  
  private var _numMatchingTasksBeforeFakeObjects: Int = 5
  private var _numFakeObjectsAfterMatchingTasks: Int = 1
  private var _numMatchingTasksBeforeVocabularyWords: Int = 5
  private var _numVocabularyWordsAfterMatchingTasks: Int = 1
  
  deinit {
    NSLog("Deinit GameController")
  }
  
  
//  public var isFakeTask: Bool {
//    get {
//      return TaskManager._isFakeTask
//    }
//  }
  
  public var task:Tasks {
    get {
      return TaskManager.task
    }
  }
  
  public class func resetTaskCount () {
//    TaskManager.matchCount = 0
//    TaskManager.vocabularyCount = 0
//    TaskManager._isVocabularyTask = false
//    TaskManager._isFakeTask = false
    TaskManager.taskQueueIndex = 0
    TaskManager.task = TaskManager.taskQueue[0]
  }
  
  public var mainObject: CognitiveToyBoxObject {
    get {
      return _mainObject
    }
  }
  
  
  public var sameNameObject: CognitiveToyBoxObject {
    get {
      return _sameNameObject
    }
  }
  
  public var diffNameObject: CognitiveToyBoxObject {
    get {
      return _diffNameObject
    }
  }
  
  public var firstObject: CognitiveToyBoxObject {
    get {
      return _firstObject
    }
  }
  
  public var secondObject: CognitiveToyBoxObject {
    get {
      return _secondObject
    }
  }
  
  public var sameNameObjectList: [CognitiveToyBoxObject] {
    get {
      return _sameNameObjectList
    }
  }
  
  public var diffNameObjectList: [CognitiveToyBoxObject] {
    get {
      return _diffNameObjectList
    }
  }
  
  public var firstObjectList: [CognitiveToyBoxObject] {
    get {
      return _firstObjectList
    }
  }
  
  public var secondObjectList: [CognitiveToyBoxObject] {
    get {
      return _secondObjectList
    }
  }
  
  private var _correctIndex:UInt32 = 0
  public var correctIndex:UInt32 {
    get {
      return _correctIndex
    }
  }
  
  
  /* Configurable extension, cause unknown problem */
  public override init () {
    super.init()
    GlobalConfiguration.addGameController(self)
    TaskManager.updateTaskQueue(self)
  }
  
  override public func isEqual(object: AnyObject!) -> Bool {
    return super.isEqual(object) && self===object
  }
  
  
  /* pick and store a random object. */
  public func startNewSession (updateTaskManager: Bool = true) {
    
    if !firstStageInitialized {
      firstStage()
    }
    
    if updateTaskManager {
      TaskManager.nextSession(self)
    }
    
    while self._mainObject == nil || self._mainObject.name == TaskManager.lastName {
      self._mainObject = CognitiveToyBoxObjectSearchHelper.getRandomObject(forNames: _stage.searchCategory)
    }
    TaskManager.lastName = self._mainObject.name
    
    self._sameNameObject = nil
    self._diffNameObject = nil
    
    let exceptId = self._mainObject.id
    let name = self._mainObject.name
    let material = self._mainObject.material
    let color = self._mainObject.color
    
    if TaskManager.task == .Match || TaskManager.task == .Vocabulary {
      self._sameNameObject = CognitiveToyBoxObjectSearchHelper.getSameNameObject (name:name, exceptId:exceptId)
      
      if self._sameNameObject == nil {
        self._sameNameObject = self._mainObject
      }
      
      
      /* if already get same material, get diff color, vise versa */
      if self._sameNameObject.material == material && material != nil && self._sameNameObject.color != color {
        
        self._diffNameObject = CognitiveToyBoxObjectSearchHelper.getDiffNameObjectOnColor(name: name, color: color, forNames: _stage.searchCategory)
        
      } else if self._sameNameObject.color == color && color != nil && self._sameNameObject.material != material {
        
        self._diffNameObject = CognitiveToyBoxObjectSearchHelper.getDiffNameObjectOnMaterial(name: name, material: material, forNames: _stage.searchCategory)
        
      }
      
      if self._diffNameObject == nil {
        self._diffNameObject = CognitiveToyBoxObjectSearchHelper.getDiffNameObject(name: name, material: material, color: color, forNames: _stage.searchCategory)
      }
      
      
      /* make sure not crash */
      if self._diffNameObject == nil {
        self.startNewSession(updateTaskManager: false)
        return
      }
    } else {
      let listCount = 2
      self._sameNameObjectList = getRandomListWithSameName(2)
      self._diffNameObjectList = getRandomListWithDiffName(2)
      if self._sameNameObjectList.count != listCount || self._diffNameObjectList.count != listCount {
        startNewSession(updateTaskManager: false)
        return
      }
    }
    
    
    
    /* reshuffle */
    self.reshuffle()
    
  }
  
  /* return the picked object. Must be called AFTER the session starts. */
  public func getMainObj () -> CognitiveToyBoxObject {
    return _mainObject!
  }
  
  /* return a pair of objects shown in the left and right block respectively (game rule part I). */
  public func getObjPair () -> (CognitiveToyBoxObject, CognitiveToyBoxObject) {
    return (_firstObject, _secondObject)
  }
  
  public func getListPair () -> ([CognitiveToyBoxObject], [CognitiveToyBoxObject]) {
    return (_firstObjectList, _secondObjectList)
  }
  
  public func getCorrectObj () -> CognitiveToyBoxObject {
//    return _firstObject.name == _mainObject.name ? _firstObject : _secondObject
    switch task {
    case .Match:
      fallthrough
    case .Vocabulary:
      return _sameNameObject
    case .Drag1:
      return _sameNameObjectList[0]
    }
  }
  
  public func getCorrectObjList () -> [CognitiveToyBoxObject] {
    return _sameNameObjectList
  }
  
  /* return all objects with the same name as picked */
  public func getListWithSameName () -> [CognitiveToyBoxObject] {
    return CognitiveToyBoxObjectSearchHelper.getSameNameAll(name: self._mainObject.name, limit: 10)
  }
  
  /* return random objects with the same name */
  public func getRandomListWithSameName(count:Int) -> [CognitiveToyBoxObject] {
    var list = NSMutableArray(array: CognitiveToyBoxObjectSearchHelper.getSameNameObjectList(name: self._mainObject.name, exceptId:self._mainObject.id))
//    list.filterUsingPredicate(NSPredicate(format: "id != %d", self._mainObject.id)!)
//    if list.count <= count {
//      return list as AnyObject as [CognitiveToyBoxObject]
//    }
    
    
    var randomList:[CognitiveToyBoxObject] = []
    while randomList.count < count {
      var index = Int(arc4random_uniform(UInt32(list.count)))
      randomList.append(list.objectAtIndex(index) as CognitiveToyBoxObject)
      list.removeObjectAtIndex(index)
    }
    
    return randomList
  }
  
  /* return random objects with the different name */
  public func getRandomListWithDiffName(count:Int) -> [CognitiveToyBoxObject] {
    var list:NSMutableArray
    
    var name = self._mainObject.name
    var material = self._mainObject.material
    var color = self._mainObject.color
    
    if material != nil && color != nil {
      if arc4random_uniform(2) == 0 {
        material = nil
      } else {
        color = nil
      }
    }
    
    list = NSMutableArray(array: CognitiveToyBoxObjectSearchHelper.getDiffNameObjectList(name: name, material: material, color: color, forNames: Stages(rawValue: self.stage)?.searchCategory))
    
    
    var randomList:[CognitiveToyBoxObject] = []
    while randomList.count < count {
      var index = Int(arc4random_uniform(UInt32(list.count)))
      randomList.append(list.objectAtIndex(index) as CognitiveToyBoxObject)
      list.removeObjectAtIndex(index)
    }
    
    return randomList
  }
  
  /* reshuffle. PRIVATE! */
  private func reshuffle () {
    self._correctIndex = arc4random_uniform(2)
    if self._correctIndex == 0 {
      self._firstObject = self._sameNameObject
      self._secondObject = self._diffNameObject
      self._firstObjectList = self._sameNameObjectList
      self._secondObjectList = self._diffNameObjectList
    }
    else {
      self._firstObject = self._diffNameObject
      self._secondObject = self._sameNameObject
      self._firstObjectList = self._diffNameObjectList
      self._secondObjectList = self._sameNameObjectList
    }
  }
  
  /* first stage */
  public func firstStage () {
    firstStageInitialized = true
    
    chooseStage(.First)
    
    
  }
  
  /* next stage */
  public func nextStage () {
    if Stages(rawValue: _stage.rawValue+1) == nil {
      return
    }
    chooseStage(Stages(rawValue: _stage.rawValue+1)!)
  }
  
  /* choose stage. */
  private func chooseStage (stage: Stages) {
    firstStageInitialized = true
    
    self._stage = stage
  }
  
}

extension GameController: ConfigurableGameController {
  
  public var stage: Stages.RawValue {
    get {
      return _stage.rawValue
    }
    set {
      if let fromRaw = Stages(rawValue: newValue) {
        chooseStage(fromRaw)
      } else {
        NSException(name: NSInvalidArgumentException, reason: "Invalid Stage. Need an Int from \(Stages.First.rawValue) to \(Stages.allValues.count)", userInfo: nil)
      }
    }
  }
  
  public var numMatchingTasksBeforeFakeObjects: Int {
    get {
      return _numMatchingTasksBeforeFakeObjects
    }
    set {
      _numMatchingTasksBeforeFakeObjects = newValue
      TaskManager.updateTaskQueue(self)
    }
  }
  
  public var numFakeObjectsAfterMatchingTasks: Int {
    get {
      return _numFakeObjectsAfterMatchingTasks
    }
    set {
      _numFakeObjectsAfterMatchingTasks = newValue
      TaskManager.updateTaskQueue(self)
    }
  }
  
  public var numMatchingTasksBeforeVocabularyWords: Int {
    get {
      return _numMatchingTasksBeforeVocabularyWords
    }
    set {
      _numMatchingTasksBeforeVocabularyWords = newValue
      TaskManager.updateTaskQueue(self)
    }
  }
  
  public var numVocabularyWordsAfterMatchingTasks: Int {
    get {
      return _numVocabularyWordsAfterMatchingTasks
    }
    set {
      _numVocabularyWordsAfterMatchingTasks = newValue
      TaskManager.updateTaskQueue(self)
    }
  }
  
}