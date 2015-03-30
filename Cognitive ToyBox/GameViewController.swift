//
//  GameViewController.swift
//  Cognitive ToyBox
//
//  Created by Heng Lyu on 6/19/14.
//  Copyright (c) 2014 Cognitive ToyBox. All rights reserved.
//

import UIKit
import SpriteKit

/* import music player lib */
//import AVFoundation

extension SKNode {
  class func unarchiveFromFile(file : NSString) -> SKNode? {
    
    let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks")
    
    var sceneData = NSData(contentsOfFile: path!, options: .DataReadingMappedIfSafe, error: nil)
    var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData!)
    
    archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
    let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as GameScene
    archiver.finishDecoding()
    return scene
  }
  
  override public func isEqual(object: AnyObject?) -> Bool {
    return super.isEqual(object) && self===object
  }
}

public class GameViewController: UIViewController {
  @IBOutlet weak var homeButton: UIButton!
  @IBOutlet weak var skView: SKView!
  @IBOutlet weak var homePanel: UIView!
  
  var gameController = GameController()
  
  enum Layers : CGFloat {
    case Bottom = -1000
    case Top = 200
    case AboveBottom = 0
    case BearBody = 1
    case BearObject = 2
    case BearArm = 3
    case BelowMask = 8
    case Mask = 9
    case AboveMask = 10
    case BelowLabel = 19
    case Label = 20
  }
  
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var howToPlayButton: UIButton!
  @IBOutlet weak var settingButton: UIButton!
  @IBOutlet weak var infoButton: UIButton!
  @IBOutlet weak var timeCountLabel: UILabel!
  @IBOutlet weak var taskCountLabel: UIButton!
  
  @IBOutlet weak var continueButton: UIButton!
  @IBAction func continueGame(sender: UIButton) {
    self.continueButton.hidden = true
    self.quitButton.hidden = true
    self.homeButton.hidden = false
    setTimer()
//    self.displayStartScene()
    self.counterReset = true
    self.presentWelcomeScene()
  }
  @IBOutlet weak var quitButton: UIButton!
  @IBAction func quitGame(sender: UIButton) {
    GlobalConfiguration.releaseScene(self.skView.scene)
    ActionHelper.releaseBearAtlas()
    self.dismissViewControllerAnimated(false) {}
  }
  
  @IBAction func stayInGame(sender: UIButton) {
    homePanel.hidden = true
    skView.paused = false
  }
  
  
  let playInterval:NSTimeInterval = 1800
  
  private var _counted = false
  var counted:Bool {
    get {
      return _counted
    }
    set {
      _counted = newValue
    }
  }
  var counterReset = true
  var _taskCount = 0
  var taskCount:Int {
    get {
      return _taskCount
    }
    set {
      _taskCount = newValue
      self.taskCountLabel.setTitle(String(_taskCount), forState: UIControlState.allZeros)
    }
  }
  
  private var _timed = false
  var timed:Bool {
    get {
      return _timed
    }
    set {
      _timed = newValue
    }
  }
  var timer:NSTimer? = nil
  
//  var _startTime = NSDate()
//  var _elapsedTime = NSDateComponents()
//  var _taskCount = 0
//  
//  var taskCount: Int {
//    get {
//      return _taskCount
//    }
//    set {
//      _taskCount = newValue
//      taskCountLabel.text = NSString(format: "%04d", _taskCount)
//    }
//  }
  
//  @IBAction func login(sender: UIButton) {
//    loginButton.hidden = true
//    howToPlayButton.hidden = true
//    self.performSegueWithIdentifier("userSignUpSegue", sender: sender)
//  }
//  @IBAction func settingTouched(sender: UIButton) {
//    self.performSegueWithIdentifier("settingsModal", sender: sender)
//    self.displayStartScene()
//    loginButton.hidden = false
//    howToPlayButton.hidden = false
////    self.skView.paused = true
//  }
  
  @IBAction func homeTouched(sender: UIButton) {
//    displayStartScene()
//    loginButton.hidden = false
//    howToPlayButton.hidden = false
    quitGame(sender)
  }
  @IBAction func homeTouchedInitial(sender: UIButton) {
    homePanel.hidden = false
    skView.paused = true
  }
  
  func longPressHandler () {
    homeTouched(self.homeButton)
  }
  
  public func presentWelcomeScene () {
    if self.counted {
      if taskCount % 5 == 0 && !counterReset {
        self.displayQuitPanel()
        return
      }
    }
    
    GlobalConfiguration.releaseScene(skView.scene)
    let scene = WelcomeScene(size: skView.bounds.size)
    scene.scaleMode = .ResizeFill
    scene.gameViewController = self
    skView.presentScene(scene)
  }
  
  public func presentGameScene (newScene:Bool = true) {
    GlobalConfiguration.releaseScene(skView.scene)
    var scene:SKScene
    gameController.startNewSession(updateTaskManager: newScene)
    if gameController.task == .Match || gameController.task == .Vocabulary {
      scene = GameScene(size: skView.bounds.size)
      (scene as GameScene).gameViewController = self
    } else if gameController.task == .Drag1 {
      scene = DragScene1(size: skView.bounds.size)
      (scene as DragScene1).gameViewController = self
    } else {
      NSException().raise()
      return
    }
    scene.scaleMode = .ResizeFill
    
    skView.presentScene(scene)
    
    self.taskCount++
    self.counterReset = false
  }
  
  /* from GameScene */
  public func presentReviewScene () {
    GlobalConfiguration.releaseScene(skView.scene)
    let scene = ReviewScene(size: skView.bounds.size)
    scene.scaleMode = .ResizeFill
    scene.gameViewController = self
    
    /* transfer data */
    scene.objectName = gameController.getMainObj().name
    if let fromScene = skView.scene as? GameScene {
//      scene.mainId = gameController.getMainObj().id
//      scene.correctId = gameController.getCorrectObj().id
      scene.timeToPlayLabel.text = fromScene.foundLabel.text
//
//      
      fromScene.mainObjectNode.removeAllActions()
      fromScene.mainObjectNode.runAction(SKAction.rotateToAngle(0, duration: 0))
      fromScene.correctNode.removeAllActions()
      fromScene.correctNode.runAction(SKAction.rotateToAngle(0, duration: 0))
      if gameController.task != .Vocabulary {
        scene.addNode(fromScene.mainObjectNode.copy() as SKSpriteNode, id: gameController.getMainObj().id)
      }
      scene.addNode(fromScene.correctNode.copy() as SKSpriteNode, id: gameController.getCorrectObj().id)
      
//      scene.mainNode = gameScene.mainObjectNode.copy() as SKSpriteNode
//      scene.mainNode.hidden = (gameScene.gameController.task == .Vocabulary)
//      if !scene.mainNode.hidden {
//        scene.presentingObjects++
//      }
//      scene.correctNode = gameScene.correctNode.copy() as SKSpriteNode
//      scene.presentingObjects++
//      
      if let mainNode_2 = fromScene.thirdOptionNode {
        mainNode_2.removeAllActions()
        mainNode_2.runAction(SKAction.rotateToAngle(0, duration: 0))
        scene.addNode(mainNode_2.copy() as SKSpriteNode, id: fromScene.objectList[fromScene.thirdOptionIndex].id)
//        scene.mainNode_2 = mainNode_2.copy() as? SKSpriteNode
//        scene.mainNode_2?.hidden = (gameScene.gameController.task == .Vocabulary)
//        if !scene.mainNode_2!.hidden {
//          scene.presentingObjects++
//        }
      }
      
      
    } else if let fromScene = skView.scene as? DragScene1 {
      fromScene.mainObjectNode.removeAllActions()
      fromScene.mainObjectNode.runAction(SKAction.rotateToAngle(0, duration: 0))
      fromScene.correctNode?.removeAllActions()
      fromScene.wrongNode?.removeAllActions()
      
      scene.addNode(fromScene.mainObjectNode.copy() as SKSpriteNode, id: gameController.getMainObj().id)
      var correctObjList = gameController.getCorrectObjList()
      var correctNodeList = fromScene.correctNodeList
      for index in 0..<correctObjList.count {
        scene.addNode(correctNodeList[index+1].copy() as SKSpriteNode, id: correctObjList[index].id)
      }
    }
    
    skView.presentScene(scene)
    
  }
  
  func displayQuitPanel () {
    GlobalConfiguration.releaseScene(self.skView.scene)
    ActionHelper.releaseBearAtlas()
    let scene = QuitScene(size: skView.bounds.size)
    scene.scaleMode = .ResizeFill
    skView.presentScene(scene)
    self.homeButton.hidden = true
    self.continueButton.hidden = false
    self.quitButton.hidden = false
    self.timer?.invalidate()
  }
  
  @IBOutlet weak var containerView: UIView!
  
  var scene: SKScene! = nil
  
  deinit {
    NSLog("Deinit GameViewController")
  }
  
  /* declare background music player */
//  var bgmPlayer:AVAudioPlayer = AVAudioPlayer()
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    
    /* auto stage */
    GlobalConfiguration.checkStageUpdate()
    
    /* assign user */
//    UserInfoHelper.switchUser(UserInfoHelper.getUserList().first)
    UserInfoHelper.switchUser(UserInfoHelper.getUserInfo())
    
    
//    var infoViewController = self.storyboard.instantiateViewControllerWithIdentifier("infoViewController") as UIViewController
    
    
    
    
    //        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
    //            // Configure the view.
    //            let skView = self.view as SKView
    //            skView.showsFPS = true
    //            skView.showsNodeCount = true
    //
    //            /* Sprite Kit applies additional optimizations to improve rendering performance */
    //            skView.ignoresSiblingOrder = true
    //
    //            /* Set the scale mode to scale to fit the window */
    //            scene.scaleMode = .AspectFill
    //
    //            skView.presentScene(scene)
    //        }
    
    self.continueButton.hidden = true
    self.quitButton.hidden = true
    self.homePanel.hidden = true
    
    var longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressHandler")
    longPressRecognizer.minimumPressDuration = 3
//    self.homeButton.addGestureRecognizer(longPressRecognizer)
    
  }
  
  func setTimer () {
    if self.timed {
      self.timer = NSTimer(timeInterval: playInterval, target: self, selector: "displayQuitPanel", userInfo: nil, repeats: false)
      NSRunLoop.currentRunLoop().addTimer(self.timer!, forMode: NSDefaultRunLoopMode)
    }
  }
  
  override public func viewWillLayoutSubviews() {
    if skView.scene == nil {
      presentWelcomeScene()
//    displayStartScene()
    }
  }
  
  func displayStartScene () {
    
    GlobalConfiguration.releaseScene(skView.scene)
    
//    self.homeButton.hidden = true
    
//    let scene = StartScene(size: skView.bounds.size)
    let scene = StartScene(size: skView.bounds.size)
    scene.scaleMode = .ResizeFill
//    scene.gameViewController = self
    skView.presentScene(scene)
  }
  
  override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
    if segue.identifier == "userSignUpSegue" {
      (segue.destinationViewController as UserViewController).sourceViewController = self
    } else if segue.identifier == "settingsModal" {
//      (segue.destinationViewController as SettingsViewController).gameViewController = self
    }
  }
  
  override public func shouldAutorotate() -> Bool {
    return true
  }
  
  override public func supportedInterfaceOrientations() -> Int {
    if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
      return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
    } else {
      return Int(UIInterfaceOrientationMask.All.rawValue)
    }
  }
  
  override public func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Release any cached data, images, etc that aren't in use.
  }
  
  
}
