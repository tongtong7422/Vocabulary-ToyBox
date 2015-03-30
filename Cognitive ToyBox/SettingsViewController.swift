//
//  SettingsViewController.swift
//  Cognitive ToyBox
//
//  Created by Heng Lyu on 8/7/14.
//  Copyright (c) 2014 Cognitive ToyBox. All rights reserved.
//

import UIKit
import SpriteKit

class SettingsViewController: UIViewController {
  
  var settingsScene: SettingsScene! = nil
  let soundPlayKey = "sound"
  
//  var gameViewController: GameViewController! = nil
  
  /* stage */
  @IBOutlet weak var stageSeg: UISegmentedControl!
  @IBAction func stageChanged(sender: UISegmentedControl) {
    GlobalConfiguration.stage = Stages.allValues[sender.selectedSegmentIndex]
  }
  private func initStage (stage: Stages) {
    if stage == Stages.All {
      stageSeg.selectedSegmentIndex = stageSeg.numberOfSegments - 1
      return
    }
    for i in 0..<Stages.allValues.count {
      if stage == Stages.allValues[i] {
        stageSeg.selectedSegmentIndex = i
        return
      }
    }
  }
  
  /* newSessionInterval */
  @IBOutlet weak var newSessionIntervalLabel: UILabel!
  @IBOutlet weak var newSessionIntervalSlider: UISlider!
  @IBAction func newSessionIntervalChanged(sender: UISlider) {
    var value = Int(sender.value/10)*10
    newSessionIntervalLabel.text = "\(value)"
    GlobalConfiguration.newSessionInterval = NSTimeInterval(value)
  }
  private func initNewSessionInterval (value: NSTimeInterval) {
    newSessionIntervalSlider.value = Float(value)
    newSessionIntervalLabel.text = "\(Int(value/10)*10)"
  }
  
  /* objectPresentMode */
  @IBOutlet weak var objectPresentModeSeg: UISegmentedControl!
  @IBAction func objectPresentModeChanged(sender: UISegmentedControl) {
    GlobalConfiguration.objectPresentMode = ObjectPresentMode.allValues[sender.selectedSegmentIndex]
  }
  private func initObjectPresentMode (value: ObjectPresentMode) {
    for i in 0..<ObjectPresentMode.allValues.count {
      if value == ObjectPresentMode.allValues[i] {
        objectPresentModeSeg.selectedSegmentIndex = i
        break
      }
    }
  }
  
  /* playtimeInterval */
  @IBOutlet weak var playtimeIntervalLabel: UILabel!
  @IBOutlet weak var playtimeIntervalSlider: UISlider!
  @IBAction func playtimeIntervalChanged(sender: UISlider) {
    var value = Int(sender.value/5)*5
    playtimeIntervalLabel.text = "\(value)"
    GlobalConfiguration.playtimeInterval = NSTimeInterval(value)
  }
  private func initPlaytimeInterval (value: NSTimeInterval) {
    playtimeIntervalSlider.value = Float(value)
    playtimeIntervalLabel.text = "\(Int(value/5)*5)"
  }
  
  /* rewardSound */
  @IBOutlet weak var rewardSoundSeg: UISegmentedControl!
  @IBAction func rewardSoundChanged(sender: UISegmentedControl) {
    GlobalConfiguration.rewardSoundName = RewardSoundName.allValues[sender.selectedSegmentIndex]
    SoundSourceHelper.playSoundOnce(GlobalConfiguration.rewardSoundName.rawValue)
  }
  private func initRewardSound (value: RewardSoundName) {
    for i in 0..<RewardSoundName.allValues.count {
      if value == RewardSoundName.allValues[i] {
        rewardSoundSeg.selectedSegmentIndex = i
        break
      }
    }
  }
  
  /* errorSound */
  @IBOutlet weak var errorSoundSeg: UISegmentedControl!
  @IBAction func errorSoundChanged(sender: UISegmentedControl) {
    GlobalConfiguration.errorSoundName = ErrorSoundName.allValues[sender.selectedSegmentIndex]
    SoundSourceHelper.playSoundOnce(GlobalConfiguration.errorSoundName.rawValue)
  }
  private func initErrorSound (value: ErrorSoundName) {
    for i in 0..<ErrorSoundName.allValues.count {
      if value == ErrorSoundName.allValues[i] {
        errorSoundSeg.selectedSegmentIndex = i
        break
      }
    }
  }
  
  /* playtimeSong */
  @IBOutlet weak var playtimeSongSeg: UISegmentedControl!
  @IBAction func playtimeSongChanged(sender: UISegmentedControl) {
    GlobalConfiguration.playtimeSongName = PlaytimeSongName.allValues[sender.selectedSegmentIndex]
    SoundSourceHelper.playSongOnce(GlobalConfiguration.playtimeSongName.rawValue)
  }
  private func initPlaytimeSong (value: PlaytimeSongName) {
    for i in 0..<PlaytimeSongName.allValues.count {
      if value == PlaytimeSongName.allValues[i] {
        playtimeSongSeg.selectedSegmentIndex = i
        break
      }
    }
  }
  
  /* background */
  @IBOutlet weak var bgSeg: UISegmentedControl!
  @IBAction func bgChanged(sender: UISegmentedControl) {
    
    var index = sender.selectedSegmentIndex
    
    /* option all */
    if index >= BackgroundImageNames.allValues.count {
      GlobalConfiguration.allowBackgroundAutoSwitch = true
      return
    }
    
    GlobalConfiguration.allowBackgroundAutoSwitch = false
    settingsScene.backgroundSwitchTo(BackgroundImageNames.allValues[index], duration: 0)
    settingsScene.background.runAction(ActionHelper.appearAndFadeAway())
  }
  private func initBackground (value: BackgroundImageNames, allowBackgroundAutoSwitch: Bool) {
    if allowBackgroundAutoSwitch {
      bgSeg.selectedSegmentIndex = BackgroundImageNames.allValues.count
      
    } else {
      for i in 0..<BackgroundImageNames.allValues.count {
        if value == BackgroundImageNames.allValues[i] {
          bgSeg.selectedSegmentIndex = i
          break
        }
      }
    }
  }
  
  /* backgroundAutoSwitch */
  @IBOutlet weak var bgAutoChangeLabel: UILabel!
  @IBOutlet weak var bgAutoChangeStepper: UIStepper!
  @IBAction func bgAutoChangeModified(sender: UIStepper) {
    var value = Int(sender.value)
    bgAutoChangeLabel.text = "\(value)"
    GlobalConfiguration.backgroundAutoSwitch = value
  }
  private func initBackgroundAutoChange (value: Int) {
    bgAutoChangeStepper.value = Double(value)
    bgAutoChangeLabel.text = "\(value)"
  }
  
  /* showNextButton */
  @IBOutlet weak var showNextButtonSwitch: UISwitch!
  @IBAction func showNextButtonChanged(sender: UISwitch) {
    GlobalConfiguration.nextButtonHidden = !sender.on
  }
  private func initShowNextButton (value: Bool) {
    showNextButtonSwitch.setOn(value, animated: false)
  }
  
  /* showBear */
  @IBOutlet weak var showBearSwitch: UISwitch!
  @IBAction func showBearChanged(sender: UISwitch) {
    GlobalConfiguration.bearHidden = !sender.on
  }
  private func initShowBear (value: Bool) {
    showBearSwitch.setOn(value, animated: false)
  }
  
  /* numVocabularyWordsAfterMatchingTasks */
  @IBOutlet weak var numVocabularyWordsAfterMatchingTasksLabel: UILabel!
  @IBOutlet weak var numVocabularyWordsAfterMatchingTasksStepper: UIStepper!
  @IBAction func numVocabularyWordsAfterMatchingTasksChanged(sender: UIStepper) {
    let value = Int(sender.value)
    self.numVocabularyWordsAfterMatchingTasksLabel.text = "\(value)"
    GlobalConfiguration.numVocabularyWordsAfterMatchingTasks = value
    GameController.resetTaskCount()
  }
  private func initNumVocabularyWordsAfterMatchingTasks (value: Int) {
    self.numVocabularyWordsAfterMatchingTasksLabel.text = "\(value)"
    self.numVocabularyWordsAfterMatchingTasksStepper.value = Double(value)
  }
  
  /* numMatchingTasksBeforeVocabularyWords */
  @IBOutlet weak var numMatchingTasksBeforeVocabularyWordsLabel: UILabel!
  @IBOutlet weak var numMatchingTasksBeforeVocabularyWordsStepper: UIStepper!
  @IBAction func numMatchingTasksBeforeVocabularyWordsChanged(sender: UIStepper) {
    let value = Int(sender.value)
    self.numMatchingTasksBeforeVocabularyWordsLabel.text = "\(value)"
    GlobalConfiguration.numMatchingTasksBeforeVocabularyWords = value
    GameController.resetTaskCount()
  }
  private func initNumMatchingTasksBeforeVocabularyWords(value: Int) {
    self.numMatchingTasksBeforeVocabularyWordsLabel.text = "\(value)"
    self.numMatchingTasksBeforeVocabularyWordsStepper.value = Double(value)
  }
  
  /* numFakeObjectsAfterMatchingTasks */
  @IBOutlet weak var numFakeObjectsAfterMatchingTasksLabel: UILabel!
  @IBOutlet weak var numFakeObjectsAfterMatchingTasksStepper: UIStepper!
  @IBAction func numFakeObjectsAfterMatchingTasksChanged(sender: UIStepper) {
    let value = Int(sender.value)
    self.numFakeObjectsAfterMatchingTasksLabel.text = "\(value)"
    GlobalConfiguration.numFakeObjectsAfterMatchingTasks = value
    GameController.resetTaskCount()
  }
  private func initNumFakeObjectsAfterMatchingTasks (value: Int) {
    self.numFakeObjectsAfterMatchingTasksLabel.text = "\(value)"
    self.numFakeObjectsAfterMatchingTasksStepper.value = Double(value)
  }
  
  /* numMatchingTasksBeforeFakeObjects */
  @IBOutlet weak var numMatchingTasksBeforeFakeObjectsLabel: UILabel!
  @IBOutlet weak var numMatchingTasksBeforeFakeObjectsStepper: UIStepper!
  @IBAction func numMatchingTasksBeforeFakeObjectsChanged(sender: UIStepper) {
    let value = Int(sender.value)
    self.numMatchingTasksBeforeFakeObjectsLabel.text = "\(value)"
    GlobalConfiguration.numMatchingTasksBeforeFakeObjects = value
    GameController.resetTaskCount()
  }
  private func initNumMatchingTasksBeforeFakeObjects (value: Int) {
    self.numMatchingTasksBeforeFakeObjectsLabel.text = "\(value)"
    self.numMatchingTasksBeforeFakeObjectsStepper.value = Double(value)
  }
  
  /* user info */
  @IBOutlet weak var nickNameLabel: UILabel!
  @IBOutlet weak var dateOfBirthLabel: UILabel!
  
  private func initUserInfo () {
    if let userInfo = UserInfoHelper.getUserInfo() {
      self.nickNameLabel.text = userInfo.name
      var formatter = NSDateFormatter()
      formatter.dateFormat = "MMM dd, yyyy"
      self.dateOfBirthLabel.text = formatter.stringFromDate(userInfo.dateOfBirth)
    }
    
  }
  
  
  /* panGestureRecognizer */
  var panGestureRecognizer: UIPanGestureRecognizer! = nil
  
  func handlePan(recognizer: UIPanGestureRecognizer) {
    switch recognizer.state {
    case .Ended:
      let velocityX = recognizer.velocityInView(self.view).x
      if velocityX > 500 {
        settingsScene.backgroundSwitchTo(GlobalConfiguration.backgroundImageName.prev())
      } else if velocityX < -500 {
        settingsScene.backgroundSwitchTo(GlobalConfiguration.backgroundImageName.succ())
      } else {
        var index = Int(round(-(settingsScene.backgroundSettingsContainer.position.x - CGRectGetMinX(view.bounds)) / (settingsScene.gapSize + settingsScene.displaySize.width)))
        if index < 0 { index = 0 }
        if index >= BackgroundImageNames.allValues.count { index = BackgroundImageNames.allValues.count-1 }
        
        settingsScene.backgroundSwitchTo(BackgroundImageNames.allValues[index])
      }
      
    case .Changed:
      var translationX = recognizer.translationInView(self.view).x
      settingsScene.backgroundSettingsContainer.position.x = settingsScene.destX[GlobalConfiguration.backgroundImageName]! + translationX
      
    default:
      return
    }
  }
  
  deinit {
    NSLog("Deinit SettingsViewController")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
//    SoundSourceHelper.stopBGM()
    
    
    
    /* set up view from global configuration */
    self.initStage(GlobalConfiguration.stage)
    
    self.initNewSessionInterval(GlobalConfiguration.newSessionInterval)
    
    self.initObjectPresentMode(GlobalConfiguration.objectPresentMode)
    
    self.initPlaytimeInterval(GlobalConfiguration.playtimeInterval)
    
    self.initRewardSound(GlobalConfiguration.rewardSoundName)
    
    self.initErrorSound(GlobalConfiguration.errorSoundName)
    
    self.initPlaytimeSong(GlobalConfiguration.playtimeSongName)
    
    self.initBackground(GlobalConfiguration.backgroundImageName, allowBackgroundAutoSwitch: GlobalConfiguration.allowBackgroundAutoSwitch)
    
    self.initBackgroundAutoChange(GlobalConfiguration.backgroundAutoSwitch)
    
    self.initShowNextButton(!GlobalConfiguration.nextButtonHidden)
    
    self.initShowBear(!GlobalConfiguration.bearHidden)
    
    self.initNumVocabularyWordsAfterMatchingTasks (GlobalConfiguration.numVocabularyWordsAfterMatchingTasks)
    
    self.initNumMatchingTasksBeforeVocabularyWords(GlobalConfiguration.numMatchingTasksBeforeVocabularyWords)
    
    self.initNumFakeObjectsAfterMatchingTasks(GlobalConfiguration.numFakeObjectsAfterMatchingTasks)
    
    self.initNumMatchingTasksBeforeFakeObjects(GlobalConfiguration.numMatchingTasksBeforeFakeObjects)
    
    self.initUserInfo()
    
    /* configure pan gesture recognizer */
//    panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
//    panGestureRecognizer.maximumNumberOfTouches = 2
//    self.view.addGestureRecognizer(panGestureRecognizer)
  }
  
  override func viewWillLayoutSubviews() {
    
    SoundSourceHelper.playInitialSong()
    
    let skView = self.view as SKView
    
    if settingsScene == nil {
      settingsScene = SettingsScene(size: skView.bounds.size)
      settingsScene.scaleMode = .ResizeFill
    }
    
    if skView.scene == nil {
      skView.presentScene(settingsScene)
    }
  }
  
  override func shouldAutorotate() -> Bool {
    return true
  }
  
  override func supportedInterfaceOrientations() -> Int {
    if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
      return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
    } else {
      return Int(UIInterfaceOrientationMask.All.rawValue)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Release any cached data, images, etc that aren't in use.
  }
  @IBAction func backToGameController(sender: UIButton) {
    GlobalConfiguration.releaseScene(self.settingsScene)
//    (self.gameViewController.view as SKView).paused = false
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func popoverAnalysis(sender: UIButton) {
    performSegueWithIdentifier("analysisPopover", sender: sender)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
    
    
    if segue.identifier == "infoPopover" {
      let popoverSegue = segue as UIStoryboardPopoverSegue
      
      
      let infoViewController = popoverSegue.destinationViewController as InfoViewController
      infoViewController.popoverController = popoverSegue.popoverController
      
      
    }
    else if segue.identifier == "analysisPopover" {
      let popoverSegue = segue as UIStoryboardPopoverSegue
      
      
      let analysisViewController = popoverSegue.destinationViewController as AnalysisViewController
      analysisViewController.popoverController = popoverSegue.popoverController
    }
    //    else if segue.identifier == "settingsPopover" {
    //      let popoverSegue = segue as UIStoryboardPopoverSegue
    //
    //      let settingsViewController = popoverSegue.destinationViewController as SettingsViewController
    //      settingsViewController.popoverController = popoverSegue.popoverController
    //    }
    //    else if segue.identifier == "settingsSegue" {
    //
    //      let settingsViewController = segue.destinationViewController as SettingsViewController
    //      settingsViewController.gameViewController = self
    //    }
    
    
  }
  
}
