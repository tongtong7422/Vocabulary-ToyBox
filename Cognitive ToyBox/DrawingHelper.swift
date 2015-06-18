//
//  DrawingHelper.swift
//  Cognitive ToyBox
//
//  Created by Heng Lyu on 7/24/14.
//  Copyright (c) 2014 Cognitive ToyBox. All rights reserved.
//

import UIKit

class DrawingHelper {
  class func trialPath () -> UIBezierPath {
    
    var path = UIBezierPath()
    //// Rectangle Drawing
    let rectanglePath = UIBezierPath(rect: CGRectMake(92, 71, 154, 95))
    UIColor.grayColor().setFill()
    rectanglePath.fill()
    return rectanglePath
  }
}