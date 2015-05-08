//
//  InfoViewController.swift
//  Cognitive ToyBox
//
//  Created by Heng Lyu on 7/7/14.
//  Copyright (c) 2014 Cognitive ToyBox. All rights reserved.
//

import UIKit
import MediaPlayer

class InfoViewController: UIViewController {
  
//  @IBOutlet var textView: UITextView!
  @IBOutlet weak var paperView: UIView!
  var viewsForSwitch:[UIView] = []
  var textsForSwitch:[String] = []
  private var viewIndex = 0
  private weak var currentView: UIView! = nil
  private var originalIndex = 0
  
  var popoverController : UIPopoverController? = nil
  var sourceViewController: UserViewController? = nil
  
  var initSize = CGSizeMake(320, 150)
  var ultiSize = CGSizeMake(640, 300)
  
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var pageControl: UIPageControl!
  @IBOutlet weak var interView: UIView!
  @IBOutlet weak var infoCard: UIImageView!
  @IBOutlet weak var closeButton: UIButton!
  
  private var player: MPMoviePlayerController! = nil
  @IBOutlet var playButton: UIButton!
  
  deinit {
    NSLog("Deinit InfoViewController")
  }
  
  func initViews () {
    textsForSwitch.append("Leaning new words is hard")
    viewsForSwitch.append(NSBundle.mainBundle().loadNibNamed("InfoView1", owner: self, options: nil).first as! UIView)
    
    textsForSwitch.append("When your child sees a new word...")
    viewsForSwitch.append(NSBundle.mainBundle().loadNibNamed("InfoView1", owner: self, options: nil).first as! UIView)
    
    textsForSwitch.append("He or she doesn't know if \"cup\" refers to objects of the same")
    viewsForSwitch.append(NSBundle.mainBundle().loadNibNamed("InfoView2", owner: self, options: nil).first as! UIView)
    
    textsForSwitch.append("color, ")
    viewsForSwitch.append(NSBundle.mainBundle().loadNibNamed("InfoView3", owner: self, options: nil).first as! UIView)
    
    textsForSwitch.append("color, or the same shape")
    viewsForSwitch.append(NSBundle.mainBundle().loadNibNamed("InfoView4", owner: self, options: nil).first as! UIView)
    
    textsForSwitch.append("It could be a number of things!")
    viewsForSwitch.append(NSBundle.mainBundle().loadNibNamed("InfoView5", owner: self, options: nil).first as! UIView)
    
    textsForSwitch.append("This app teaches children to cue in on shape,")
    viewsForSwitch.append(NSBundle.mainBundle().loadNibNamed("InfoView6", owner: self, options: nil).first as! UIView)
    
    textsForSwitch.append("This app teaches children to cue in on shape,\n in the context of learning new object words.")
    viewsForSwitch.append(NSBundle.mainBundle().loadNibNamed("InfoView7", owner: self, options: nil).first as! UIView)
    
    textsForSwitch.append("In the lab, 17 month olds children guided to shape")
    viewsForSwitch.append(NSBundle.mainBundle().loadNibNamed("InfoView8", owner: self, options: nil).first as! UIView)
    
    textsForSwitch.append("In the lab, 17 month olds children guided to shape\nhad 3X faster growth in object vocabulary")
    viewsForSwitch.append(NSBundle.mainBundle().loadNibNamed("InfoView8", owner: self, options: nil).first as! UIView)
    
    textsForSwitch.append("In the lab, 17 month olds children guided to shape\nhad 3X faster growth in object vocabulary\ncompared to other children over a two month window.")
    viewsForSwitch.append(NSBundle.mainBundle().loadNibNamed("InfoView8", owner: self, options: nil).first as! UIView)
    
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = UIColor.clearColor()
    self.view.backgroundColor = UIColor(patternImage: UIImage(named: "classroom_blur")!)
    
//    self.initViews()
//    
//    viewIndex = originalIndex
//    currentView = viewsForSwitch[originalIndex]
//    currentView.frame.size = paperView.frame.size
//    self.paperView.addSubview(currentView)
//    
//    self.label.text = textsForSwitch[originalIndex]
//    
//    self.pageControl.numberOfPages = viewsForSwitch.count
//    self.pageControl.currentPage = originalIndex
//    
//    var panRecognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
//    self.view.addGestureRecognizer(panRecognizer)
    
    
    
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    self.pageControl.hidden = true
    self.infoCard.hidden = true
    self.paperView.hidden = true
    self.label.hidden = true
    self.closeButton.hidden = true
    
    if player != nil {
      return
    }
    if let url = NSBundle.mainBundle().URLForResource("InfoViewAnimation", withExtension: "mov") {
      player = MPMoviePlayerController(contentURL: url)
      player.controlStyle = MPMovieControlStyle.Embedded
      player.scalingMode = MPMovieScalingMode.Fill
      player.view.frame = self.interView.bounds
      self.interView.addSubview(player.view)
      
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "movieFinishedCallback", name: MPMoviePlayerPlaybackDidFinishNotification, object: player)
      
      player.prepareToPlay()
      player.play()
    }
  }
  
  func movieFinishedCallback () {
    self.player.view.removeFromSuperview()
  }
  
  @IBAction func exit(sender: UIButton) {
    self.dismissViewControllerAnimated(true) {}
  }
  @IBAction func playButtonTouched(sender: UIButton) {
    self.exit(sender)
    self.sourceViewController?.freeGame(sender)
  }
  
  func handlePan (sender: UIPanGestureRecognizer) {
    
    switch sender.state {
    case .Changed:
      var x = sender.translationInView(self.view).x
      switchView(self.originalIndex - Int(x/200))
    case .Ended:
      self.originalIndex = self.viewIndex
    default:
      return
    }
    
//    if sender.state == UIGestureRecognizerState.Changed {
//      var x = sender.translationInView(self.view).x
//      switchView(self.originalIndex + Int(x/50))
////      if x < -50 {
////        switchView(self.viewIndex + 1)
////      } else if x > 50 {
////        switchView(self.viewIndex - 1)
////      }
//    }
  }
  
  func switchView (viewIndex:Int) {
    if self.viewIndex == viewIndex {
      return
    }
    
    var options:UIViewAnimationOptions
    if self.viewIndex < viewIndex {
      options = .TransitionFlipFromRight
    } else {
      options = .TransitionFlipFromLeft
    }
    
    if viewIndex >= viewsForSwitch.count {
      if self.viewIndex == viewsForSwitch.count - 1 {
        return
      }
      self.viewIndex = viewsForSwitch.count - 1
    } else if viewIndex < 0 {
      if self.viewIndex == 0 {
        return
      }
      self.viewIndex = 0
    } else {
      self.viewIndex = viewIndex
    }
    
    var view = viewsForSwitch[self.viewIndex]
    view.frame.size = paperView.frame.size
    
    UIView.transitionWithView(self.interView, duration: 0.2, options: options, animations: {
      [unowned self] in
      if let view = self.currentView {
        view.removeFromSuperview()
      }
      self.currentView = view
      self.paperView.addSubview(view)
      self.label.text = self.textsForSwitch[self.viewIndex]
      }, completion: nil)
    
    self.pageControl.currentPage = self.viewIndex
    
  }
  @IBAction func pageChanged(sender: UIPageControl) {
    self.switchView(sender.currentPage)
    self.originalIndex = sender.currentPage
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.popoverController?.backgroundColor = UIColor.clearColor()
//    self.popoverController!.setPopoverContentSize(self.initSize, animated: false)
//    self.textView.hidden = true

  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
//    self.popoverController!.setPopoverContentSize(self.ultiSize, animated: animated)
//    
//    let timer = NSTimer(timeInterval: 0, target: self, selector: "showText", userInfo: nil, repeats: false)
//    NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
  }
  
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
//    self.popoverController = nil
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
//  func showText () {
//    self.textView.hidden = false
//  }
  
}
