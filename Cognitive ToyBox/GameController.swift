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

enum Mode {
  case Tutorial, Game
}

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
      taskQueue = [.Match, .Drag, .Bucket, .Vocabulary]
//      taskQueue = [.Material, .Color, .Length]
//        taskQueue = [.Vocabulary]
    }
    
    static func nextSession (gameController: GameController) {
      if gameController.mode == .Tutorial {
        taskQueueIndex = 0
        task = taskQueue[0]
        return
      }
      if taskQueue.isEmpty {
        return
      }
      task = taskQueue[taskQueueIndex]
      taskQueueIndex++
      taskQueueIndex %= taskQueue.count
    }
  }
  
  private var _mode:Mode = .Game
  var mode:Mode {
    get {
      return _mode
    }
    set {
      _mode = newValue
      if _mode == .Tutorial {
        _stage = .Tutorial
      } else {
        _stage = GlobalConfiguration.stage
      }
      startNewSession(updateTaskManager: false)
//      if let main = _mainObject {
//        self._sameNameObject = main
//        self._diffNameObject = CognitiveToyBoxObjectSearchHelper.getDiffNameObjectEasy(name: main.name, material: main.material, color: main.color, forNames: _stage.searchCategory)
//      }
    }
  }
  
  private var _stage: Stages = .First
  
  private var firstStageInitialized = false
  private var sessionPassed: Int = 0
  
  
  private var _mainObject : CognitiveToyBoxObject! = nil
  private var _options: [[CognitiveToyBoxObject]] = []
  private var _correctIndex:Int = 0
//  private var _sameNameObject : CognitiveToyBoxObject! = nil//USE LIST
//  private var _diffNameObject : CognitiveToyBoxObject! = nil
//  
//  private var _firstObject : CognitiveToyBoxObject! = nil
//  private var _secondObject : CognitiveToyBoxObject! = nil
  
//  private var _sameNameObjectList: [CognitiveToyBoxObject] = []
//  private var _diffNameObjectList: [CognitiveToyBoxObject] = []
//  private var _firstObjectList: [CognitiveToyBoxObject] = []
//  private var _secondObjectList: [CognitiveToyBoxObject] = []
  
  
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
  
  
//  public var sameNameObject: CognitiveToyBoxObject {
//    get {
//      return _sameNameObject
//    }
//  }
//  
//  public var diffNameObject: CognitiveToyBoxObject {
//    get {
//      return _diffNameObject
//    }
//  }
//  
//  public var firstObject: CognitiveToyBoxObject {
//    get {
//      return _firstObject
//    }
//  }
//  
//  public var secondObject: CognitiveToyBoxObject {
//    get {
//      return _secondObject
//    }
//  }
  
  /* A list of options where each element is a list of objects */
  public var options: [[CognitiveToyBoxObject]] {
    get {
      return _options
    }
  }
  
//  public var sameNameObjectList: [CognitiveToyBoxObject] {
//    get {
//      return _sameNameObjectList
//    }
//  }
//  
//  public var diffNameObjectList: [CognitiveToyBoxObject] {
//    get {
//      return _diffNameObjectList
//    }
//  }
//  
//  public var firstObjectList: [CognitiveToyBoxObject] {
//    get {
//      return _firstObjectList
//    }
//  }
//  
//  public var secondObjectList: [CognitiveToyBoxObject] {
//    get {
//      return _secondObjectList
//    }
//  }
  
  public var correctIndex:Int {
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
  
  public func unregister() {
    GlobalConfiguration.removeGameController(self)
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
      if mode == .Tutorial {
        self._mainObject = CognitiveToyBoxObjectSearchHelper.getRandomObject(entityName:"CTBObject_tutorial")
      } else {
        self._mainObject = CognitiveToyBoxObjectSearchHelper.getRandomObject(forNames: _stage.searchCategory)
      }
    }
    TaskManager.lastName = self._mainObject.name
    
//    self._sameNameObject = nil
//    self._diffNameObject = nil
    self._options = []
    self._correctIndex = 0
    
    let exceptId = self._mainObject.id
    let name = self._mainObject.name
    let material = self._mainObject.material
    let color = self._mainObject.color
    
    switch TaskManager.task {
    case .Match:
        var sameNameObject:CognitiveToyBoxObject!
        var diffNameObject:CognitiveToyBoxObject!
        if mode == .Tutorial {
            sameNameObject = self._mainObject
            diffNameObject = CognitiveToyBoxObjectSearchHelper.getDiffNameObjectTutorial(name: name, material: material, color: color)
            
        } else {
            sameNameObject = CognitiveToyBoxObjectSearchHelper.getSameNameObject (name:name, exceptId:exceptId)
            
            if sameNameObject == nil {
                sameNameObject = self._mainObject
            }
            
            
            /* if already get same material, get diff color, vise versa */
            if sameNameObject.material == material && material != nil && sameNameObject.color != color {
                
                diffNameObject = CognitiveToyBoxObjectSearchHelper.getDiffNameObjectOnColor(name: name, color: color, forNames: _stage.searchCategory)
                
            } else if sameNameObject.color == color && color != nil && sameNameObject.material != material {
                
                diffNameObject = CognitiveToyBoxObjectSearchHelper.getDiffNameObjectOnMaterial(name: name, material: material, forNames: _stage.searchCategory)
                
            }
            
            if diffNameObject == nil {
                diffNameObject = CognitiveToyBoxObjectSearchHelper.getDiffNameObject(name: name, material: material, color: color, forNames: _stage.searchCategory)
            }
        }
        
        /* make sure not crash */
        if diffNameObject == nil {
            self.startNewSession(updateTaskManager: false)
            return
        }
        
        self._options.append([sameNameObject])
        self._options.append([diffNameObject])
        

    case .Vocabulary:
//        if material == nil || color == nil {
//            startNewSession(updateTaskManager: false)
//            return
//        }
        
        var sameNameObject:CognitiveToyBoxObject!
//        var sameColorObject:CognitiveToyBoxObject!
//        var sameMaterialObject:CognitiveToyBoxObject!

        var object1:CognitiveToyBoxObject!
        var object2:CognitiveToyBoxObject!
        
        sameNameObject = CognitiveToyBoxObjectSearchHelper.getSameNameObject (name:name, exceptId:exceptId)
        
        if material == nil && color == nil {
            startNewSession(updateTaskManager: false)
            return
        } else if material == nil {
            object1 = CognitiveToyBoxObjectSearchHelper.getDiffNameObjectOnColor(name: name, color: color, forNames: _stage.searchCategory, material: material)
            object2 = CognitiveToyBoxObjectSearchHelper.getDiffNameObjectOnColor(name: name, color: color, forNames: _stage.searchCategory, material: material)
            while object1.id == object2.id {
                object2 = CognitiveToyBoxObjectSearchHelper.getDiffNameObjectOnColor(name: name, color: color, forNames: _stage.searchCategory, material: material)
            }
        } else if color == nil {
            object1 = CognitiveToyBoxObjectSearchHelper.getDiffNameObjectOnMaterial(name: name, material: material, forNames: _stage.searchCategory, color: color)
            object2 = CognitiveToyBoxObjectSearchHelper.getDiffNameObjectOnMaterial(name: name, material: material, forNames: _stage.searchCategory, color: color)
            while object1.id == object2.id {
                object2 = CognitiveToyBoxObjectSearchHelper.getDiffNameObjectOnMaterial(name: name, material: material, forNames: _stage.searchCategory, color: color)
            }
        } else {
            object1 = CognitiveToyBoxObjectSearchHelper.getDiffNameObjectOnColor(name: name, color: color, forNames: _stage.searchCategory, material: material)
            object2 = CognitiveToyBoxObjectSearchHelper.getDiffNameObjectOnMaterial(name: name, material: material, forNames: _stage.searchCategory, color: color)
        }
        
        if sameNameObject == nil || object1 == nil || object2 == nil {
            startNewSession(updateTaskManager: false)
            return
        }
        
        /* name is the correct choice */
        self._options.append([sameNameObject])
        self._options.append([object1])
        self._options.append([object2])

        
    case .Drag:
      fallthrough
    case .Bucket:
      var sameNameObjectList:[CognitiveToyBoxObject]
      var diffNameObjectList:[CognitiveToyBoxObject]
      
      var listCount:Int = 1
      if self.task == .Drag {
        listCount = 2
      } else if self.task == .Bucket {
        listCount = 5
      }
      sameNameObjectList = getRandomListWithSameName(listCount)
      diffNameObjectList = getRandomListWithDiffName(listCount)
      if sameNameObjectList.count != listCount || diffNameObjectList.count != listCount {
        startNewSession(updateTaskManager: false)
        return
      }
      
      self._options.append(sameNameObjectList)
      self._options.append(diffNameObjectList)
    case .Some:
      if material == nil || color == nil {
        startNewSession(updateTaskManager: false)
        return
      }
      
      var sameNameObject:CognitiveToyBoxObject!
      var sameColorObject:CognitiveToyBoxObject!
      var sameMaterialObject:CognitiveToyBoxObject!
      
      sameNameObject = CognitiveToyBoxObjectSearchHelper.getSameNameObject (name:name, exceptId:exceptId)
      sameColorObject = CognitiveToyBoxObjectSearchHelper.getDiffNameObjectOnColor(name: name, color: color, forNames: _stage.searchCategory, material: material)
      sameMaterialObject = CognitiveToyBoxObjectSearchHelper.getDiffNameObjectOnMaterial(name: name, material: material, forNames: _stage.searchCategory, color: color)
      
      
      if sameNameObject == nil || sameColorObject == nil || sameMaterialObject == nil {
        startNewSession(updateTaskManager: false)
        return
      }
      
      /* material is the correct choice */
      self._options.append([sameMaterialObject])
      self._options.append([sameNameObject])
      self._options.append([sameColorObject])
      
    case .Material:
      if material == nil || color == nil {
        startNewSession(updateTaskManager: false)
        return
      }
      
      /* same material diff color */
      var sameMaterialObject:CognitiveToyBoxObject! = nil
      
      /* same color diff material */
      var sameColorObject:CognitiveToyBoxObject! = nil
      
      sameMaterialObject = CognitiveToyBoxObjectSearchHelper.getSameNameObjectOnMaterial(name: name, exceptId: exceptId, material: material!, color: color!)
      sameColorObject = CognitiveToyBoxObjectSearchHelper.getSameNameObjectOnColor(name: name, exceptId: exceptId, material: material!, color: color!)
      
      if sameColorObject == nil || sameMaterialObject == nil {
        startNewSession(updateTaskManager: false)
        return
      }
      
      /* Material is special. Different material is correct answer */
      self._options.append([sameColorObject])
      self._options.append([sameMaterialObject])
      
    case .Color:
      if material == nil || color == nil {
        startNewSession(updateTaskManager: false)
        return
      }
      
      /* same material diff color */
      var sameMaterialObject:CognitiveToyBoxObject! = nil
      
      /* same color diff material */
      var sameColorObject:CognitiveToyBoxObject! = nil
      
      sameMaterialObject = CognitiveToyBoxObjectSearchHelper.getSameNameObjectOnMaterial(name: name, exceptId: exceptId, material: material!, color: color!)
      sameColorObject = CognitiveToyBoxObjectSearchHelper.getSameNameObjectOnColor(name: name, exceptId: exceptId, material: material!, color: color!)
      
      if sameColorObject == nil || sameMaterialObject == nil {
        startNewSession(updateTaskManager: false)
        return
      }
      
      /* Color is special. Different color is correct answer */
      self._options.append([sameMaterialObject])
      self._options.append([sameColorObject])
      
    case .Length:
      var sameNameObject = CognitiveToyBoxObjectSearchHelper.getSameNameObject (name:name, exceptId:exceptId)
      if sameNameObject == nil {
        startNewSession(updateTaskManager: false)
        return
      }
      
      /* Same attribute is correct answer */
      self._options.append([mainObject])
      self._options.append([sameNameObject!])
      
    }
    
    
    
    /* reshuffle */
    self.reshuffle()
    
  }
  
  /* return the picked object. Must be called AFTER the session starts. */
  public func getMainObj () -> CognitiveToyBoxObject {
    return _mainObject!
  }
  
  /* return a pair of objects shown in the left and right block respectively (game rule part I). */
//  public func getObjPair () -> (CognitiveToyBoxObject, CognitiveToyBoxObject) {
//    return (_firstObject, _secondObject)
//  }
  
//  public func getListPair () -> ([CognitiveToyBoxObject], [CognitiveToyBoxObject]) {
//    return (_firstObjectList, _secondObjectList)
//  }
  
  public func getCorrectObj () -> CognitiveToyBoxObject {
    return self._options[Int(self._correctIndex)].first!
  }
  
  public func getCorrectObjList () -> [CognitiveToyBoxObject] {
    return self._options[Int(self._correctIndex)]
  }
  
  /* return all objects with the same name as picked */
  public func getListWithSameName () -> [CognitiveToyBoxObject] {
    return CognitiveToyBoxObjectSearchHelper.getSameNameAll(name: self._mainObject.name, limit: 10)
  }
  
  /* return all objects with the same material as picked */
  public func getListWithSameMaterial () -> [CognitiveToyBoxObject] {
    return CognitiveToyBoxObjectSearchHelper.getSameMaterialAll(material: self._mainObject.material!, limit: 10)
  }
  
  /* return random objects with the same name */
  public func getRandomListWithSameName(count:Int) -> [CognitiveToyBoxObject] {
    var list = NSMutableArray(array: CognitiveToyBoxObjectSearchHelper.getSameNameObjectList(name: self._mainObject.name, exceptId:self._mainObject.id))
//    list.filterUsingPredicate(NSPredicate(format: "id != %d", self._mainObject.id)!)
//    if list.count <= count {
//      return list as AnyObject as [CognitiveToyBoxObject]
//    }
    
    
    var randomList:[CognitiveToyBoxObject] = []
    while randomList.count < count && list.count > 0 {
      var index = Int(arc4random_uniform(UInt32(list.count)))
      randomList.append(list.objectAtIndex(index) as! CognitiveToyBoxObject)
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
    
    list = NSMutableArray(array: CognitiveToyBoxObjectSearchHelper.getDiffNameObjectList(name: name, material: material, color: color, forNames: _stage.searchCategory))
    
    
    var randomList:[CognitiveToyBoxObject] = []
    while randomList.count < count && list.count > 0 {
      var index = Int(arc4random_uniform(UInt32(list.count)))
      randomList.append(list.objectAtIndex(index) as! CognitiveToyBoxObject)
      list.removeObjectAtIndex(index)
    }
    
    return randomList
  }
  
  /* reshuffle. PRIVATE! */
  private func reshuffle () {
    var correctList = self._options.removeAtIndex(self._correctIndex)
    self._options.shuffle()
    
    self._correctIndex = Int(arc4random_uniform(UInt32(self._options.count+1)))
    self._options.insert(correctList, atIndex: self._correctIndex)
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