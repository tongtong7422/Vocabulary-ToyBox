//
//  DatePickerViewController.swift
//  Cognitive ToyBox
//
//  Created by Heng Lyu on 2/24/15.
//  Copyright (c) 2015 Cognitive ToyBox. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {
  
//  var popoverController : UIPopoverController! = nil
  var userViewController: UserViewController! = nil
  @IBOutlet weak var datePicker: UIDatePicker!
  
  deinit {
    NSLog("Deinit DatePickerViewController")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func viewWillDisappear(animated: Bool) {
//    popoverController
//    popoverController = nil
    userViewController.displayDate(datePicker.date)
    userViewController = nil
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    
    
  }
  
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  
}
