//
//  InfoViewController.swift
//  Cognitive ToyBox
//
//  Created by Heng Lyu on 7/7/14.
//  Copyright (c) 2014 Cognitive ToyBox. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
  
  @IBOutlet var textView: UITextView!
  
  var popoverController : UIPopoverController? = nil
  
  var initSize = CGSizeMake(320, 150)
  var ultiSize = CGSizeMake(640, 300)
  
  deinit {
    NSLog("Deinit InfoViewController")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.popoverController!.setPopoverContentSize(self.initSize, animated: false)
    self.textView.hidden = true

  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    self.popoverController!.setPopoverContentSize(self.ultiSize, animated: animated)
    
    let timer = NSTimer(timeInterval: 0, target: self, selector: "showText", userInfo: nil, repeats: false)
    NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
  }
  
  override func viewDidDisappear(animated: Bool) {
    self.popoverController = nil
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func showText () {
    self.textView.hidden = false
  }
  
}
