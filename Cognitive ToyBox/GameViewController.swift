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
    
    let path = NSBundle.mainBundle().pathForResource(file as String, ofType: "sks")
    var sceneData = NSData()
    do{
      sceneData = try NSData(contentsOfFile: path!, options: NSDataReadingOptions.DataReadingMappedIfSafe)
    }catch let error as NSError{
      ErrorLogger.logError(error, message: "\(error.localizedDescription)")
    }
    
    let archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
    
    archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
    let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! TriadScene
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
  @IBOutlet weak var progressBar: UIProgressView!
  @IBOutlet weak var progressNumber: UILabel!
  
  @IBAction func analysisButton(sender: AnyObject) {
    self.performSegueWithIdentifier("finalAnalysis", sender: self)
    return
  }
  
  var gameController = GameController()
  
  enum Layers : CGFloat {
    case Bottom = -1000
    case Top = 100
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
  @IBOutlet weak var taskCountLabelTrophy: UILabel!
  
  @IBOutlet weak var rewardView: SKView!
  @IBOutlet weak var continueButton: UIButton!
  @IBAction func continueGame(sender: UIButton) {
    SoundSourceHelper.stopBGM()
    
//    self.continueButton.hidden = true
//    self.quitButton.hidden = true
//    self.homeButton.hidden = false
    setTimer()
//    self.displayStartScene()
    self.counterReset = true
    self.rewardView.hidden = true
    rewardView.presentScene(nil)
    
    self.presentWelcomeScene()
    skView.paused = false
    
  }
  @IBOutlet weak var continueButtonBorder: UIImageView!
  @IBOutlet weak var quitButton: UIButton!
  @IBAction func quitGame(sender: UIButton) {
    SoundSourceHelper.stopBGM()
    GlobalConfiguration.releaseScene(self.skView.scene)
    ActionHelper.releaseBearAtlas()
    self.dismissViewControllerAnimated(false) {}
  }
  @IBOutlet weak var quitButtonBorder: UIImageView!
  
  @IBAction func stayInGame(sender: UIButton) {
    
    homePanel.hidden = true
    skView.paused = false
    
  }
  
  @IBAction func playSoundButton(sender: AnyObject) {
    
  }
  
  func displayQuitPanel () {
    skView.paused = true
    GlobalConfiguration.releaseScene(self.skView.scene)
    ActionHelper.releaseBearAtlas()
    //    let scene = QuitScene(size: skView.bounds.size)
    //    scene.scaleMode = .ResizeFill
    //    skView.presentScene(scene)
    
    //    self.homeButton.hidden = true
    //    self.continueButton.hidden = false
    //    self.quitButton.hidden = false
    self.rewardView.hidden = false
    
    let scene = ConfettiScene(size: rewardView.bounds.size)
    scene.scaleMode = .ResizeFill
    rewardView.presentScene(scene)
    
    self.timer?.invalidate()
    
    SoundSourceHelper.playTrophySound()
  }

  private var _isFinished = false
  var isFinished:Bool {
    get {
      return _isFinished
    }
    set {
      _isFinished = newValue
    }
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
      self.taskCountLabel.setTitle(String(_taskCount), forState: UIControlState())
      self.taskCountLabelTrophy.text = String(_taskCount)
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
    // stop showing confetti panel
    self.counted = false
    
    if self.counted {
      if taskCount % 5 == 0 && !counterReset {
        counterReset = true
        self.displayQuitPanel()
        return
      }
    }
    
    taskCount++
    counterReset = false
    
    GlobalConfiguration.releaseScene(skView.scene)
    let scene = WelcomeScene(size: skView.bounds.size)
    scene.scaleMode = .ResizeFill
    scene.gameViewController = self
    skView.presentScene(scene)
  }
  
  public func presentGameScene (newScene:Bool = true) {
    GlobalConfiguration.releaseScene(skView.scene)
    var scene:SKScene
    var success = gameController.startNewSession(newScene)
    if !success  {
      

      self.isFinished = true
      self.performSegueWithIdentifier("finalAnalysis", sender: self)
      
      return
    }
    switch gameController.task {
//    case .Match:
//      scene = TriadScene(size: skView.bounds.size)
//      (scene as! TriadScene).gameViewController = self
    case .Vocabulary:
      scene = VocabularyScene(size: skView.bounds.size)
      (scene as! VocabularyScene).gameViewController = self
//    case .Drag:
//      scene = DragScene(size: skView.bounds.size)
//      (scene as! DragScene).gameViewController = self
//    case .Bucket:
//      scene = BucketScene(size: skView.bounds.size)
//      (scene as! BucketScene).gameViewController = self
//    case .Material:
//      fallthrough
//    case .Color:
//      fallthrough

    default:
      return
    }
    scene.scaleMode = .ResizeFill
    
    skView.presentScene(scene)
    
  }
  
  /* from GameScene */
  public func presentReviewScene () {
    GlobalConfiguration.releaseScene(skView.scene)
    let scene = ReviewScene(size: skView.bounds.size)
    scene.scaleMode = .ResizeFill
    scene.gameViewController = self
    
    /* transfer data */
    scene.objectName = gameController.getMainObj().name
    if let fromScene = skView.scene as? VocabularyScene {
        scene.objectName = gameController.getMainObj().name
        scene.mode = .Name

        scene.timeToPlayLabel.text = fromScene.foundLabel.text
      
        fromScene.correctNode.removeAllActions()
        fromScene.correctNode.runAction(SKAction.rotateToAngle(0, duration: 0))

        scene.addNode(fromScene.correctNode.copy() as! SKSpriteNode, id: gameController.getCorrectObj().id)
        
      
    }
    
    skView.presentScene(scene)
    
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
//    GlobalConfiguration.checkStageUpdate()
    
    /* assign user */
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
    
//    self.continueButton.hidden = true
//    self.quitButton.hidden = true
    
    self.rewardView.hidden = true
    self.homePanel.hidden = true
    
    
    
    /* make button alive */
    continueButton.imageView?.animationImages = [UIImage(named: "bearWaving1")!, UIImage(named: "bearWaving2")!]
    continueButton.imageView?.animationDuration = 0.4
    continueButton.imageView?.startAnimating()
    
    quitButton.imageView?.animationImages = [UIImage(named: "bearSleeping1")!, UIImage(named: "bearSleeping2")!, UIImage(named: "bearSleeping3")!]
    quitButton.imageView?.animationDuration = 0.6
    quitButton.imageView?.startAnimating()
    
    var buttonBorderImages = [UIImage(named: "emptyButton1")!, UIImage(named:"emptyButton2")!]
    continueButtonBorder.animationImages = buttonBorderImages
    continueButtonBorder.animationDuration = 0.4
    continueButtonBorder.startAnimating()
    
    quitButtonBorder.animationImages = buttonBorderImages
    quitButtonBorder.animationDuration = 0.4
    quitButtonBorder.startAnimating()
    
    
    
    var longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressHandler")
    longPressRecognizer.minimumPressDuration = 3
//    self.homeButton.addGestureRecognizer(longPressRecognizer)
    
//    self.skView.showsPhysics = true
    
    progressBar.setProgress(Float(UserPerformanceHelper.getTestNumber())/Float(GlobalConfiguration.stage.searchCategory.count * 5), animated: true)
    progressNumber.text = "\(UserPerformanceHelper.getTestNumber())/\(GlobalConfiguration.stage.searchCategory.count * 5)"
    
  }
  
//  func addControls() {
//    // Create Progress View Control
//    progressBar = UIProgressView(progressViewStyle: UIProgressViewStyle.Default)
////    progressBar?.center = self.view.center
//    view.addSubview(progressBar!)
//    
//    // Add Label
//    progressNumber = UILabel()
////    let frame = CGRectMake(view.center.x - 25, view.center.y - 100, 100, 50)
////    progressLabel?.frame = frame
//    view.addSubview(progressNumber!)
//  }
//  
  
  func updateProgressBar() {
    progressBar?.progress += (1.0/Float(GlobalConfiguration.stage.searchCategory.count * 5))
//    let progressValue = self.progressBar?.progress
    progressNumber?.text = "\(UserPerformanceHelper.getTestNumber())/\(GlobalConfiguration.stage.searchCategory.count * 5)"
  }

  
  public override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    ActionHelper.clearFrameCache()
    GlobalConfiguration.removeGameController(gameController)
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
      (segue.destinationViewController as! UserViewController).sourceViewController = self
    } else if segue.identifier == "settingsModal" {
//      (segue.destinationViewController as SettingsViewController).gameViewController = self
    } else if segue.identifier == "finalAnalysis"
    {
      (segue.destinationViewController as! AnalysisViewController).sourceViewController = self
    }
  }
  
  override public func shouldAutorotate() -> Bool {
    return true
  }
  public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
       if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
          return UIInterfaceOrientationMask.AllButUpsideDown
        } else {
          return UIInterfaceOrientationMask.All
        }
  }
//  override public func supportedInterfaceOrientations() -> Int {
//    if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
//      return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
//    } else {
//      return Int(UIInterfaceOrientationMask.All.rawValue)
//    }
//  }
  
  override public func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Release any cached data, images, etc that aren't in use.
  }
  
  
}
