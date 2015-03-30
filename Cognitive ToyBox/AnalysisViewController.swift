//
//  AnalysisViewController.swift
//  Cognitive ToyBox
//
//  Created by Heng Lyu on 6/20/14.
//  Copyright (c) 2014 Cognitive ToyBox. All rights reserved.
//

import UIKit

class AnalysisViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TKChartDelegate, TKChartDataSource {
  
  @IBOutlet var chartView: UIView!
  @IBOutlet var tableView: UITableView!
  
  var popoverController : UIPopoverController? = nil
  
  var names = [String]()
  var accuracy = [Float]()
  
  var performance : [String: PerformanceData]!
  
  var series = [TKChartSeries]()
  
  var chart : TKChart!
//  var dateAxis = TKChartDateTimeAxis()
  var catAxis = TKChartCategoryAxis()
  var countAxis = TKChartNumericAxis(minimum: 0, andMaximum: 5, position: TKChartAxisPositionLeft)
  var performanceAxis = TKChartNumericAxis(minimum:0, andMaximum:1, position: TKChartAxisPositionRight)
  
  
  @IBAction func clearButton(sender: AnyObject) {
    UserPerformanceHelper.clear()
    self.names = []
    self.accuracy = []
    self.performance = [:]
    self.tableView.reloadData()
    loadData()
    self.chart.reloadData()
  }
  
  deinit {
    NSLog("Deinit AnalysisViewController")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
//    countAxis.title = "Number of Questions Reviewed"
    
//    dateAxis.position = TKChartAxisPositionBottom
    catAxis.position = TKChartAxisPositionBottom
    
//    dateAxis.plotMode = TKChartAxisPlotModeBetweenTicks
    
//    performanceAxis.labelDisplayMode = TKChartNumericAxisLabelDisplayModePercentage
    let formatter = NSNumberFormatter()
    formatter.numberStyle = .PercentStyle
    performanceAxis.labelFormatter = formatter
    
    loadData()
    
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    
    self.popoverController!.setPopoverContentSize(CGSize(width: 1024, height: 768), animated: false)
    
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    // init chart
    chart = TKChart(frame: self.chartView.frame)
    
    // add axis
//    chart.xAxis = dateAxis
    chart.xAxis = catAxis
    chart.addAxis(countAxis)
    chart.addAxis(performanceAxis)
    
    // init delegate
    chart.delegate = self
    
    // init dataSourch
    chart.dataSource = self
    
    // auto resizing
    chart.autoresizingMask = .FlexibleWidth | .FlexibleHeight
    
    // title
    let categories = catAxis.categories() as [NSDate]
    var formatter = NSDateFormatter()
    formatter.calendar = NSCalendar.currentCalendar()
    formatter.dateFormat = "MMM dd"
    
    chart.title().text = "Vocabulary Reviewed: \(formatter.stringFromDate(categories[0])) - \(formatter.stringFromDate(categories[categories.endIndex-1]))"
    chart.title().hidden = false
    
    chart.allowAnimations = true
    chart.legend().hidden = false
    
    
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
  
  // UITableViewDataSource
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if names.count != accuracy.count {
      var name = "DataNotMatch"
      var message = "Data not match"
      var e = NSException(name: name, reason: message, userInfo: nil)
      Flurry.logError(name, message: message, exception: e)
      e.raise()
    }
    return names.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell : UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Default")
    
    cell.textLabel!.text = self.names[indexPath.row]
    
    var accuracy = NSString(format: "%.0f", self.accuracy[indexPath.row]*100)
    cell.detailTextLabel?.text = "\(accuracy)%"
    
    return cell
  }
  
  func numberOfSeriesForChart(chart: TKChart!) -> UInt {
    return UInt(self.series.count)
  }
  
  func seriesForChart(chart: TKChart!, atIndex index: UInt) -> TKChartSeries! {
    return self.series[Int(index)]
  }
  
  func loadData () {
    
    self.names = []
    self.accuracy = []
    
    self.series = []
    
    
    
    // today
    performance = UserPerformanceHelper.getPerformance(date: NSDate(timeIntervalSinceNow: 0))
    for (key, value) in performance {
      self.names.append(key)
      self.accuracy.append(value.accuracy)
    }
    
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
    
    var firstViewedSeries = TKChartColumnSeries(items: firstViewedItems)
    var totalViewedSeries = TKChartColumnSeries(items: totalViewedItems)
    
    
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
    
    
    
    
    
    var performanceSeries = TKChartLineSeries(items: performanceItems)
//    performanceSeries.style.pointShape = TKPredefinedShape(type: TKShapeTypeCircle, andSize: CGSizeMake(8, 8))
    
    performanceSeries.yAxis = performanceAxis
    
    // set title
    firstViewedSeries.title = "Unique Words"
    totalViewedSeries.title = "Number of Questions"
    performanceSeries.title = "Accuracy"
    
    self.series.append(firstViewedSeries)
    self.series.append(totalViewedSeries)
    self.series.append(performanceSeries)
    
  }
  
}
