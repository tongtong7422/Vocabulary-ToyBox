//
//  AnalysisViewController.swift
//  Cognitive ToyBox
//
//  Created by Heng Lyu on 6/20/14.
//  Copyright (c) 2014 Cognitive ToyBox. All rights reserved.
//

import UIKit

class AnalysisViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TKChartDelegate, TKChartDataSource {
  
  class Word: NSObject {
    let name: String
    let accuracy: Float
    
    
    init(name: String,accuracy: Float) {
      self.name = name
      self.accuracy = accuracy
    }
  }
  
  /* custom type to represent table sections*/
//  class Section {
//    var words: [Word] = []
//
//    func addWord(word: Word) {
//      self.words.append(word)
//    }
//    
//  }
  
  @IBOutlet var chartView: UIView!
  @IBOutlet var tableView: UITableView!
  
  var popoverController : UIPopoverController? = nil
  var sourceViewController: UIViewController? = nil
  
  var names = [String]()
  var accuracy = [Float]()
  var levelOfWord = [String]()
  
  
  var performance : [String: PerformanceData]!
  
//  var _sections: [Section]?

  var levelNames = [String]()
  var levelMasterPercentage = [Float]()

  var isMaster :[String: Bool] = [:]
  
  var series = [TKChartSeries]()
  
  var chart : TKChart!
  
  
  @IBAction func clearButton(sender: AnyObject) {
    UserPerformanceHelper.clear()
    self.names = []
    self.accuracy = []
    self.performance = [:]
//    self._sections  = [Section]()
    self.levelNames = []
    self.levelMasterPercentage = []
    self.isMaster = [:]
    self.tableView.reloadData()
    loadData()
    self.chart.reloadData()
  }
  
  deinit {
    NSLog("Deinit AnalysisViewController")
  }
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()

    loadData()
    
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    self.popoverController?.setPopoverContentSize(CGSize(width: 1024, height: 768), animated: false)
    
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    // init chart
    chart = TKChart(frame: self.chartView.frame)
    
    // init delegate
    chart.delegate = self
    
    // init dataSource
    chart.dataSource = self
    
    // auto resizing
    chart.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
    
    chart.title().text = "Performance"

    chart.title().hidden = false
    
    chart.allowAnimations = true
    chart.legend().hidden = true
    let formatter = NSNumberFormatter()
    formatter.numberStyle = .PercentStyle
    chart.yAxis.labelFormatter = formatter
    
    // add chart
    self.view.addSubview(chart)
    
    
  }
  
  override func viewDidDisappear(animated: Bool) {
    self.popoverController = nil
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
//  func getSectionItems(section: Int) -> [Word] {
//    var sectionItems = [Word]()
//    
//    // loop through to get the items for this sections
//    for item in self._sections![section].words{
//      sectionItems.append(item)
//
//    }
//    return sectionItems
//  }
 
/* UITableView DataSource, with three sections*/
/*****************************************************************************/
//  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//    return self._sections!.count
//  }
  
//  func tableView(tableView: UITableView,
//    numberOfRowsInSection section: Int)
//    -> Int {
//      return self._sections![section].words.count
//  }
  
//  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    if names.count != accuracy.count {
//      var name = "DataNotMatch"
//      var message = "Data not match"
//      var e = NSException(name: name, reason: message, userInfo: nil)
//      Flurry.logError(name, message: message, exception: e)
//      e.raise()
//    }
//    return names.count
//  }
  
//  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//    var sectionName : String
//    if section == 0 {
//      sectionName = "EASY"
//    }else if section == 1 {
//      sectionName = "MIDDLE"
//    }else {
//      sectionName = "HARD"
//    }
//    return sectionName
//  }
  
//  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//    let cell : UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Default")
//    var label : UILabel
//    // get the items in this section
//    let sectionItems = self.getSectionItems(indexPath.section)
//    
//    // get the item for the row in this section
//    let wordItem = sectionItems[indexPath.row]
//    
//    cell.textLabel!.text = wordItem.name
//    var accuracy = NSString(format: "%.0f", wordItem.accuracy*100)
//    cell.detailTextLabel?.text = "\(accuracy)%"
//
//
////    cell.textLabel!.text = self.names[indexPath.row]
////    var accuracy = NSString(format: "%.0f", self.accuracy[indexPath.row]*100)
////    cell.detailTextLabel?.text = "\(accuracy)%"
//
//    return cell
//  }
/**************************************************************************************************/
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 0
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    return UITableViewCell()
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
  }
  
  
  /********************* chart ***********************************/
  func numberOfSeriesForChart(chart: TKChart!) -> UInt {
    return UInt(self.series.count)
  }
  
  func seriesForChart(chart: TKChart!, atIndex index: UInt) -> TKChartSeries! {
    return self.series[Int(index)]
  }
  
  /***************************************************************/
  @IBAction func backToMain(sender: UIButton) {
//    self.dismissViewControllerAnimated(false) {}
    
    let controller = self.sourceViewController as? GameViewController
    if controller?.isFinished==true{
      
      self.dismissViewControllerAnimated(false) {
        [unowned self] in
        if let controller = self.sourceViewController as? GameViewController {
          controller.dismissViewControllerAnimated(false) {}
        }
      }
    }else {
      self.dismissViewControllerAnimated(false) {}
    }
    
//  back to home
//    self.dismissViewControllerAnimated(false) {
//      [unowned self] in
//      if let controller = self.sourceViewController as? GameViewController {
//        controller.dismissViewControllerAnimated(false) {}
//      }
//    }
  }
  
  func loadData () {
    
    self.names = []
    self.accuracy = []
    self.levelOfWord = []
    self.levelNames = []
    self.series = []
    self.levelMasterPercentage = []
//    self._sections = [Section]()
//    var easyCorrectNum : Int = 0
//    var middleCorrectNum : Int = 0
//    var hardCorrectNum : Int = 0
//    var easyNum : Int = 0
//    var middleNum : Int = 0
//    var hardNum : Int = 0
    
// today
//    performance = UserPerformanceHelper.getPerformance(date: NSDate(timeIntervalSinceNow: 0))
    /** with three section **/
//    var easySection = Section()
//    var middleSection = Section()
//    var hardSection = Section()

    performance = UserPerformanceHelper.getPerformance()
    for (key, value) in performance {
      self.names.append(key)
      self.accuracy.append(value.accuracy)
      
      if value.accuracy < 0.8 {
        self.isMaster[key] = false
      }else {
        self.isMaster[key] = true
      }


/* vocabulary with hardness level */

//      if CognitiveToyBoxObject.stage1Objects.contains(key)  {
//        var newWord = Word(name:key,accuracy:value.accuracy)
//        easySection.addWord(newWord)
//        
//        if self.isMaster[key] == true{
//          easyCorrectNum++
//        }
//        self.levelOfWord.append("easy")
//        easyNum++
//      }else if CognitiveToyBoxObject.stage2Objects.contains(key) {
//        var newWord = Word(name:key,accuracy:value.accuracy)
//        middleSection.addWord(newWord)
//        
//        if self.isMaster[key] == true {
//          middleCorrectNum++
//        }
//        self.levelOfWord.append("middle")
//        middleNum++
//      }else {
//        var newWord = Word(name:key,accuracy:value.accuracy)
//        hardSection.addWord(newWord)
//        
//        if self.isMaster[key] == true {
//          hardCorrectNum++
//        }
//        self.levelOfWord.append("hard")
//        hardNum++
//      }
      
    }
    
/* vocabulary with hardness level */
//    if easyNum != 0 {
//      self.levelMasterPercentage.append(Float(easyCorrectNum)/Float(easyNum))
//      self.levelNames.append("easy")
//    }
//    if middleNum != 0 {
//      self.levelMasterPercentage.append(Float(middleCorrectNum)/Float(middleNum))
//      self.levelNames.append("middle")
//    }
//    if hardNum != 0 {
//      self.levelMasterPercentage.append(Float(hardCorrectNum)/Float(hardNum))
//      self.levelNames.append("hard")
//    }
//    
//    self._sections?.append(easySection)
//    self._sections?.append(middleSection)
//    self._sections?.append(hardSection)
//
//    var dataPoints = [TKChartDataPoint]()
//    for var i = 0; i < self.levelNames.count; ++i {
//      dataPoints.append(TKChartDataPoint(x: self.levelNames[i], y: self.levelMasterPercentage[i]))
//    }
//
//    self.series.append(TKChartColumnSeries(items: dataPoints))
    
    
/*** Heng's Code ***/
/**************************************************************************************************
    var datePair = DateHelper.getDayBoundary(NSDate(timeIntervalSinceNow: 0))
    let firstViewedNames = UserPerformanceHelper.getFirstViewedNames(dateFrom: datePair.0, dateTo: datePair.1)
    
//    if !firstViewedNames.isEmpty {
//      self.names.append(firstViewedNames.description)
//      self.accuracy.append(0)
//    }
    
    // Series
    var firstViewedItems: NSMutableArray = []
    var totalViewedItems: NSMutableArray = []
    var performanceItems: NSMutableArray = []
    
    let daysInWeek = DateHelper.getDaysInWeek(NSDate(timeIntervalSinceNow: 0))
    catAxis.addCategoriesFromArray(daysInWeek)
//    dateAxis.range = TKRange(minimum: daysInWeek[0], andMaximum: daysInWeek[daysInWeek.endIndex-1])
    
    var formatter = NSDateFormatter()
    formatter.dateFormat = "EEE"
    
    var numFirstViewed: Int
    var total: Int
    var correct: Int
    var boundary: (NSDate, NSDate)
    var maxTotal: Int = 0
//    var weekdayString: String
    for day in daysInWeek {
      boundary = DateHelper.getDayBoundary(day)
      numFirstViewed = UserPerformanceHelper.getFirstViewedNames(dateFrom: boundary.0, dateTo: boundary.1).count
      
//      weekdayString = formatter.stringFromDate(day)
      
      // first viewed items
      firstViewedItems.addObject(TKChartDataPoint(
//        x: weekdayString,
        x: day,
        y: numFirstViewed))
      
      
      performance = UserPerformanceHelper.getPerformanceBetween(dateFrom: boundary.0, dateTo: boundary.1)
      
      total = 0
      correct = 0
      for (key, value) in performance {
        total += value.total
        correct += value.correct
      }
      
      // record the maximum value of total
      maxTotal = maxTotal < total ? total : maxTotal
      
      // total
      totalViewedItems.addObject(TKChartDataPoint(
//        x: weekdayString,
        x: day,
        y: total-numFirstViewed)) // stacked
      
//       performance
//      if total == 0 {
//        continue
//      }
      performanceItems.addObject(TKChartDataPoint(
//        x: formatter.stringFromDate(day),
        x: day,
        y: PerformanceData(total: total, correct: correct).accuracy))
    }
    
    var firstViewedSeries = TKChartColumnSeries(items: firstViewedItems as [AnyObject])
    var totalViewedSeries = TKChartColumnSeries(items: totalViewedItems as [AnyObject])
    
    
    var stackInfo = TKChartStackInfo(ID: 1, withStackMode: TKChartStackModeStack)
    firstViewedSeries.stackInfo = stackInfo
    totalViewedSeries.stackInfo = stackInfo
    
    // xAxis
//    dateAxis.majorTickIntervalUnit = TKChartDateTimeAxisIntervalUnitDays
//    dateAxis.labelFormatter = formatter
    catAxis.labelFormatter = formatter
    
    
//    firstViewedSeries.xAxis = dateAxis
//    totalViewedSeries.xAxis = dateAxis
    
    // yAxis for count of total and first viewed names. rounded up to multiple of 5.\
    maxTotal = maxTotal == 0 ? 5 : maxTotal
    countAxis.range = TKRange(minimum: 0, andMaximum: maxTotal + ((5 - (maxTotal % 5)) % 5))
    firstViewedSeries.yAxis = countAxis
    totalViewedSeries.yAxis = countAxis
    
    
    
    
    
    var performanceSeries = TKChartLineSeries(items: performanceItems as [AnyObject])
//    performanceSeries.style.pointShape = TKPredefinedShape(type: TKShapeTypeCircle, andSize: CGSizeMake(8, 8))
    
    performanceSeries.yAxis = performanceAxis
    
    // set title
    firstViewedSeries.title = "Unique Words"
    totalViewedSeries.title = "Number of Questions"
    performanceSeries.title = "Accuracy"
    
    self.series.append(firstViewedSeries)
    self.series.append(totalViewedSeries)
    self.series.append(performanceSeries)
**********************************************************************************************/
  }

}
