//
//  UserViewController.swift
//  Cognitive ToyBox
//
//  Created by Heng Lyu on 8/22/14.
//  Copyright (c) 2014 Cognitive ToyBox. All rights reserved.
//

import UIKit
import SpriteKit

class UserViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
  
  deinit {
    NSLog("Deinit UserViewController")
  }
  
  /* source view controller */
  var sourceViewController: UIViewController? = nil
  
  private var userList: [UserInfo] = []
  
  private var _taskCount = 0
  var taskCount:Int {
    get {
      return _taskCount
    }
    set {
      _taskCount = newValue
      if newValue > 2 {
        _taskCount = 1
//        displayTutorialOptions()
      }
    }
  }
//  func displayTutorialOptions () {
//    tutorialPlayButton.hidden = false
//    tutorialAnotherButton.hidden = false
//    tutorialView.paused = true
//  }
//  func hideTutorialOptions() {
//    tutorialPlayButton.hidden = true
//    tutorialAnotherButton.hidden = true
//    tutorialView.paused = false
//  }
  
//  @IBAction func doMoreTutorial(sender: UIButton) {
//    hideTutorialOptions()
//  }
  

  @IBOutlet weak var userCollectionView: UICollectionView!
  let reuseIdentifier = "userCell"
  
  private var loginPanelHidden:Bool = true
  
  @IBOutlet weak var birthdayTextField: UITextField!
  
  @IBOutlet weak var loginPanel: UIView!
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var dateOfBirthTextField: UITextField!
  @IBOutlet weak var addUserButton: UIButton!
  @IBOutlet weak var howToPlayButton: UIButton!
  @IBOutlet weak var freeButton: UIButton!
  @IBOutlet weak var timedButton: UIButton!
  @IBOutlet weak var cameraButton: UIButton!
//  @IBOutlet weak var tutorialOverlay: UIView!
//  @IBOutlet weak var tutorialView: SKView!
//  @IBOutlet weak var tutorialPlayButton: UIButton!
//  @IBOutlet weak var tutorialAnotherButton: UIButton!
  
  var userIcon:UIImage! = nil
  
//  @IBOutlet weak var datePicker: UIDatePicker!
  
  @IBAction func switchSoundMode(sender: UIButton) {
    GlobalConfiguration.muted = !GlobalConfiguration.muted
    if GlobalConfiguration.muted {
      sender.setImage(UIImage(named: "muteButton"), forState: UIControlState.Normal)
    } else {
      sender.setImage(UIImage(named: "soundButton"), forState: UIControlState.Normal)
    }
  }
  
//  @IBAction func nameChanged(sender: UITextField) {
//    for user in userList {
//      if sender.text == user.name {
//        displayDate(user.dateOfBirth)
//        datePicker.setDate(user.dateOfBirth, animated: true)
//        return
//      }
//    }
//    dateOfBirthTextField.text = ""
//  }
  
//  @IBAction func backToGame(sender: UIButton) {
//    
//    if signUp () {
//      self.dismissViewControllerAnimated(true, completion: nil)
//      
//      if let gameViewController = sourceViewController as? GameViewController {
//        if let startScene = gameViewController.skView.scene as? StartScene {
//          startScene.transitionToGameScene()
//        }
//      }
//    }
//  }
//  @IBAction func backToGameWithoutSignUp(sender: UIButton) {
//    self.dismissViewControllerAnimated(true, completion: nil)
//    UserInfoHelper.clearUser()
//    
//    if let gameViewController = sourceViewController as? GameViewController {
//      if let startScene = gameViewController.skView.scene as? StartScene {
//        startScene.transitionToGameScene()
//      }
//    }
//  }
  @IBAction func startTutorial(sender: UIButton) {
//    tutorialOverlay.hidden = false
//    tutorialView.presentScene(TutorialScene(size: tutorialView.frame.size))
//    presentTutorialScene()
  }
  @IBAction func freeGame(sender: UIButton) {
//    UserInfoHelper.clearUser()
    self.performSegueWithIdentifier("tutorialSegue", sender: sender)
//    self.performSegueWithIdentifier("gameViewSegueFree", sender: sender)
  }
  @IBAction func timedGame(sender: UIButton) {
//    UserInfoHelper.clearUser()
    self.performSegueWithIdentifier("gameViewSegueTimed", sender: sender)
  }
  @IBAction func settings(sender: UIButton) {
    self.performSegueWithIdentifier("settingsSegue", sender: sender)
  }
//  @IBAction func datePicked(sender: UIDatePicker) {
//    displayDate(sender.date)
//  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.userList.count + 1
  }
  
  // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    var cell: UserCollectionViewCell = userCollectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! UserCollectionViewCell
    
    /* configure cell */
    var imageView = UIImageView(frame: cell.frame)
    imageView.layer.cornerRadius = imageView.frame.size.width/2
    
    cell.backgroundView = imageView
    cell.backgroundColor = UIColor.clearColor()
    
    if isNewUserIcon(indexPath: indexPath) {
      imageView.image = UIImage(named: "newUserIcon")!
    } else {
      imageView.image = UIImage(data: userList[getUserIndexFromCollectionViewIndex(indexPath.row)].icon)!
    }
    
    return cell
  }
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    var cell: UserCollectionViewCell = userCollectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! UserCollectionViewCell
    
    if isNewUserIcon(indexPath: indexPath) {
      self.initLoginPanel()
      self.showLoginPanel()
      collectionView.deselectItemAtIndexPath(indexPath, animated: false)
    } else {
      UserInfoHelper.switchUser(userList[getUserIndexFromCollectionViewIndex(indexPath.row)])
    }
  }
  
  func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
    var cell: UserCollectionViewCell = userCollectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! UserCollectionViewCell
    
    
  }
  
  private func initLoginPanel() {
    self.cameraButton.imageView?.image = UIImage(named: "camera")
    self.nameTextField.text = ""
    self.nameTextField.backgroundColor = UIColor.whiteColor()
    self.dateOfBirthTextField.text = ""
    self.dateOfBirthTextField.backgroundColor = UIColor.whiteColor()
    self.userIcon = nil
  }
  
  private func showLoginPanel () {
    let duration:NSTimeInterval = 0.2
    UIView.animateWithDuration(duration, animations: { () -> Void in
//      self.howToPlayButton.alpha = 0
      self.userCollectionView.alpha = 0
      self.freeButton.alpha = 0
      self.timedButton.alpha = 0
      }) { (isComplete:Bool) -> Void in
        if isComplete {
//          self.howToPlayButton.hidden = true
          self.userCollectionView.hidden = true
          self.freeButton.hidden = true
          self.timedButton.hidden = true
          
          self.loginPanel.hidden = false
          self.addUserButton.hidden = false
          
          UIView.animateWithDuration(duration, animations: { () -> Void in
            self.loginPanel.alpha = 1
            self.addUserButton.alpha = 1
          })
          
          self.loginPanelHidden = false
        } else {
//          self.howToPlayButton.alpha = 1
          self.userCollectionView.alpha = 1
          self.freeButton.alpha = 1
          self.timedButton.alpha = 1
        }
    }
    
    
  }
  
  private func hideLoginPanel () {
    
    let duration:NSTimeInterval = 0.2
    UIView.animateWithDuration(duration, animations: { () -> Void in
      self.loginPanel.alpha = 0
      self.addUserButton.alpha = 0
      }) { (isComplete:Bool) -> Void in
        if isComplete {
//          self.howToPlayButton.hidden = false
          self.userCollectionView.hidden = false
          self.freeButton.hidden = false
          self.timedButton.hidden = false
          
          self.loginPanel.hidden = true
          self.addUserButton.hidden = true
          
          UIView.animateWithDuration(duration, animations: { () -> Void in
//            self.howToPlayButton.alpha = 1
            self.userCollectionView.alpha = 1
            self.freeButton.alpha = 1
            self.timedButton.alpha = 1
          })
          
          self.loginPanelHidden = true
        } else {
          self.loginPanel.alpha = 1
          self.addUserButton.alpha = 1
        }
    }
    
  }
  @IBAction func takePhoto(sender: UIButton) {
    self.performSegueWithIdentifier("cameraSegue", sender: sender)
  }
  
  @IBAction func touchBlank(sender: UIView) {
    if self.nameTextField.isFirstResponder() {
      self.nameTextField.resignFirstResponder()
      return
    }
    if !self.loginPanelHidden {
      hideLoginPanel()
    }
  }
  
  /* find the new user button */
  private func isNewUserIcon(indexPath indexPath: NSIndexPath) -> Bool {
    return indexPath.row == findNewUserIcon()
  }
  
  private func findNewUserIcon() -> Int {
    if self.userList.count < 5 {
      return self.userList.count / 2
    } else {
      return 2
    }
  }
  
  private func getUserIndexFromCollectionViewIndex(index:Int) -> Int {
    return index < findNewUserIcon() ? index : index - 1
  }
  
  /* display date in text field */
//  func displayDate (date: NSDate) {
//    dateOfBirthTextField.text = UserInfoHelper.birthDateToString(date)
//    dateOfBirth = date
//  }
  
  func displayDate (date: NSDate) {
    birthdayTextField.text = UserInfoHelper.birthDateToString(date)
    dateOfBirth = date
  }
  
  var dateOfBirth: NSDate! = nil
  
  @IBAction func addUser(sender: UIButton) {
    if signUp() {
      self.hideLoginPanel()
    }
  }
  func signUp () -> Bool {
    var success = true
    
    /* name must not be empty */
    if nameTextField.text!.isEmpty {
      nameTextField.backgroundColor = UIColor.redColor()
      success = false
    } else {
      nameTextField.backgroundColor = UIColor.whiteColor()
    }
    
    /* birthday must not be empty */
    if let date = dateOfBirth {
      dateOfBirthTextField.backgroundColor = UIColor.whiteColor()
    } else {
      dateOfBirthTextField.backgroundColor = UIColor.redColor()
      success = false
    }
    
    /* icon must not be empty */
    if userIcon == nil {
      success = false
    }
    
    if success {
      UserInfoHelper.signUp(name: nameTextField.text!, dateOfBirth: dateOfBirth, icon: userIcon)
      userList = UserInfoHelper.getUserList()
      self.userCollectionView.reloadData()
    }
    
    return success
    
  }
  
   
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = UIColor(patternImage: UIImage(named: "StartBackground")!)
    
    self.loginPanel.layer.cornerRadius = 10
    self.loginPanel.layer.masksToBounds = true
    self.loginPanel.hidden = true
    self.addUserButton.hidden = true
    self.loginPanel.alpha = 0
    self.addUserButton.alpha = 0
    
    self.userCollectionView.allowsSelection = true
    self.userCollectionView.allowsMultipleSelection = false
    
//    self.tutorialOverlay.hidden = true
//    self.tutorialPlayButton.hidden = true
//    self.tutorialAnotherButton.hidden = true
    
    userList = UserInfoHelper.getUserList()

    self.birthdayTextField.text = ""
    self.birthdayTextField.backgroundColor = UIColor.whiteColor()
    
//    dateOfBirthTextField.inputView = datePicker
//    // Do any additional setup after loading the view.
//    
//    /* load */
//    
//    if let userInfo = UserInfoHelper.getUserInfo() {
//      nameTextField.text = userInfo.name
//      dateOfBirth = userInfo.dateOfBirth
//      datePicker.date = dateOfBirth
//      displayDate(dateOfBirth)
//    }
    
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    SoundSourceHelper.playInitialSong()
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
//    tutorialOverlay.hidden = true
//    tutorialView.presentScene(nil)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
//  override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
//    super.touchesBegan(touches, withEvent: event)
//    self.view.endEditing(true)
//  }
  

  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
//  func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
//    if textField == self.dateOfBirthTextField {
//      self.view.endEditing(true)
//      self.performSegueWithIdentifier("datePickerSegue", sender: textField)
//      return false
//    }
//    return true
//  }
  
  func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
    if textField == self.birthdayTextField {
      self.view.endEditing(true)
      self.performSegueWithIdentifier("datePickerSegue", sender: textField)
      return false
    }
    return true
  }

  
  override func disablesAutomaticKeyboardDismissal() -> Bool {
    return false
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "infoSegue" {
      let popoverSegue = segue as! UIStoryboardPopoverSegue
      let infoViewController = popoverSegue.destinationViewController as! InfoViewController
      infoViewController.popoverController = popoverSegue.popoverController
      infoViewController.sourceViewController = self
      
    } else if segue.identifier == "gameViewSegueTimed" {
      (segue.destinationViewController as! GameViewController).timed = true
      
    } else if segue.identifier == "gameViewSegueFree" {
      (segue.destinationViewController as! GameViewController).counted = true
    } else if segue.identifier == "datePickerSegue" {
      let popoverSegue = segue as! UIStoryboardPopoverSegue
      let datePickerViewController = popoverSegue.destinationViewController as! DatePickerViewController
      datePickerViewController.userViewController = self
    } else if segue.identifier == "cameraSegue" {
      (segue.destinationViewController as! CameraViewController).userViewController = self
    }
  }
  
  
//  func textFieldShouldBeginEditing(textField: UITextField!) -> Bool {
//    if textField == dateOfBirthTextField {
//      return false
//    }
//    return true
//  }
//  
}
