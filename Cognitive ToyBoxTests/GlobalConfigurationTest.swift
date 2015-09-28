////
////  GlobalConfigurationTest.swift
////  Cognitive ToyBox
////
////  Created by Heng Lyu on 8/5/14.
////  Copyright (c) 2014 Cognitive ToyBox. All rights reserved.
////
//
//import UIKit
//import SpriteKit
//import XCTest
//import Blicket
//
//class GlobalConfigurationTest: XCTestCase {
//  
//  override func setUp() {
//    super.setUp()
//    // Put setup code here. This method is called before the invocation of each test method in the class.
//  }
//  
//  override func tearDown() {
//    // Put teardown code here. This method is called after the invocation of each test method in the class.
//    super.tearDown()
//  }
//  
//  func testExample() {
//    // This is an example of a functional test case.
//    XCTAssert(true, "Pass")
//  }
//  
//  func testPerformanceExample() {
//    // This is an example of a performance test case.
//    self.measureBlock() {
//      // Put the code you want to measure the time of here.
//    }
//  }
//  
//  func testBackgroundImageNames () {
//    XCTAssert(BackgroundImageNames.autoSwitchValues[0].prev() == nil)
//    XCTAssert(BackgroundImageNames.autoSwitchValues[BackgroundImageNames.autoSwitchValues.count-1].succ() == nil)
//    XCTAssert(BackgroundImageNames.autoSwitchValues[0].succ() == BackgroundImageNames.autoSwitchValues[1])
//    XCTAssert(BackgroundImageNames.autoSwitchValues[0] == BackgroundImageNames.autoSwitchValues[1].prev())
//  }
//  
//  func testConfigurableGameController () {
//    var configurableGameControllers = [ConfigurableGameController]()
//    for i in 0..<100 {
//      configurableGameControllers.append(TestGameController())
//    }
//    
//    GlobalConfiguration.numMatchingTasksBeforeFakeObjects = 1
//    GlobalConfiguration.numFakeObjectsAfterMatchingTasks = 2
//    GlobalConfiguration.numMatchingTasksBeforeVocabularyWords = 3
//    GlobalConfiguration.numVocabularyWordsAfterMatchingTasks = 4
//    GlobalConfiguration.stage = .Second
//    
//    for c in configurableGameControllers {
//      XCTAssert(c.numMatchingTasksBeforeFakeObjects == 1)
//      XCTAssert(c.numFakeObjectsAfterMatchingTasks == 2)
//      XCTAssert(c.numMatchingTasksBeforeVocabularyWords == 3)
//      XCTAssert(c.numVocabularyWordsAfterMatchingTasks == 4)
//      XCTAssert(c.stage == Stages.Second.rawValue)
//    }
//  }
//  
//  func testConfigurableScene () {
//    var configurableScene = [ConfigurableScene]()
//    for i in 0..<100 {
//      configurableScene.append(TestScene())
//    }
//    
//    GlobalConfiguration.backgroundImageName = .Forest
//    
//    for c in configurableScene {
//      XCTAssert(c.background != nil)
//    }
//  }
//  
//  func testConfigurableActionHelper () {
//    var configurableActionHelper = [ConfigurableActionHelper]()
//    for i in 0..<100 {
//      configurableActionHelper.append(TestActionHelper())
//    }
//    
//    GlobalConfiguration.newSessionInterval = 10
//    GlobalConfiguration.objectPresentMode = ObjectPresentMode.Shake
//    GlobalConfiguration.playtimeInterval = 20
//    
//    for c in configurableActionHelper {
//      XCTAssert(c.newSessionInterval == 10)
//      XCTAssert(c.objectPresentMode == ObjectPresentMode.Shake.rawValue)
//      XCTAssert(c.playtimeInterval == 20)
//    }
//  }
//  
//  func testConfigurableSoundSourceHelper () {
//    var configurableSoundSourceHelper = [ConfigurableSoundSourceHelper]()
//    for i in 0..<100 {
//      var t = TestSoundSourceHelper()
//      configurableSoundSourceHelper.append(t)
//    }
//    
//    GlobalConfiguration.rewardSoundName = RewardSoundName.RightToneOne
//    GlobalConfiguration.errorSoundName = ErrorSoundName.WrongToneA
//    GlobalConfiguration.playtimeSongName = .FirstSong
//    
//    for c in configurableSoundSourceHelper {
//      XCTAssert(c.rewardSoundName == RewardSoundName.RightToneOne.rawValue)
//      XCTAssert(c.errorSoundName == ErrorSoundName.WrongToneA.rawValue)
//      XCTAssert(c.playtimeSongName == PlaytimeSongName.FirstSong.rawValue)
//    }
//  }
//  
//}
//
//private class TestGameController: NSObject, ConfigurableGameController {
//  @objc var stage: Stages.RawValue = 0
//  var categories = NSSet()
//  
//  @objc var numMatchingTasksBeforeFakeObjects: Int = 0
//  @objc var numFakeObjectsAfterMatchingTasks: Int = 0
//  
//  @objc var numMatchingTasksBeforeVocabularyWords: Int = 0
//  @objc var numVocabularyWordsAfterMatchingTasks: Int = 0
//  
//  override init () {
//    super.init()
//    GlobalConfiguration.addGameController(self)
//  }
//}
//
//private class TestScene: SKScene, ConfigurableScene {
//  @objc var background: SKSpriteNode! = nil
//  override init() {
//    super.init()
//  }
//  required init?(coder aDecoder: NSCoder) {
//    super.init(coder: aDecoder)
//  }
//  override init(size: CGSize) {
//    super.init(size: size)
//    GlobalConfiguration.addScene(self)
//  }
//  
//}
//
//private class TestActionHelper: NSObject, ConfigurableActionHelper {
//  @objc var newSessionInterval: NSTimeInterval = 0
//  @objc var objectPresentMode: ObjectPresentMode.RawValue = ""
//  @objc var playtimeInterval: NSTimeInterval = 0
//  override init () {
//    super.init()
//    GlobalConfiguration.addActionHelper(self)
//  }
//}
//
//private class TestSoundSourceHelper: NSObject, ConfigurableSoundSourceHelper {
//  @objc var rewardSoundName: RewardSoundName.RawValue = RewardSoundName.RightToneOne.rawValue
//  @objc var errorSoundName: ErrorSoundName.RawValue = ErrorSoundName.WrongToneA.rawValue
//  @objc var playtimeSongName: PlaytimeSongName.RawValue = PlaytimeSongName.FirstSong.rawValue
//  
//  @objc func mute(boolValue: Bool) {
//    return
//  }
//  override init () {
//    super.init()
//    GlobalConfiguration.addSoundHelper(self)
//  }
//}