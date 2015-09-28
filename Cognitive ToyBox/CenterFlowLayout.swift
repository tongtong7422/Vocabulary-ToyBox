//
//  CenterFlowLayout.swift
//  Cognitive ToyBox
//
//  Created by Heng Lyu on 2/18/15.
//  Reference: https://github.com/keighl/KTCenterFlowLayout/blob/master/KTCenterFlowLayout.m
//  Copyright (c) 2015 Cognitive ToyBox. All rights reserved.
//

import UIKit

class CenterFlowLayout: UICollectionViewFlowLayout {
  
  override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    var superAttributes = super.layoutAttributesForElementsInRect(rect)
    
    var rowCollections:NSMutableDictionary = [:]
    
    // Collect attributes by their midY coordinate.. i.e. rows!
    for itemAttributes in superAttributes!
    {
      var yCenter = CGRectGetMidY(itemAttributes.frame)
      
      if (rowCollections[yCenter] == nil) {
        rowCollections[yCenter] = NSMutableArray()
      }
      
      rowCollections[yCenter]?.addObject(itemAttributes)
    }
    
    // Adjust the items in each row
    rowCollections.enumerateKeysAndObjectsUsingBlock { (key, obj, stop) -> Void in
      let itemAttributesCollection = obj as! [UICollectionViewLayoutAttributes]
      let itemsInRow = itemAttributesCollection.count
      
      // x-x-x-x ... sum up the interim space
      let aggregateInteritemSpacing:CGFloat = CGFloat(itemsInRow-1)*self.minimumInteritemSpacing
      
      // Sum the width of all elements in the row
      var aggregateItemWidths:CGFloat = 0.0
      for itemAttributes:UICollectionViewLayoutAttributes in itemAttributesCollection {
        aggregateItemWidths += CGRectGetWidth(itemAttributes.frame)
      }
      
      // Build an alignment rect
      // |==|--------|==|
      let alignmentWidth = aggregateItemWidths + aggregateInteritemSpacing;
      let alignmentXOffset = (CGRectGetWidth(self.collectionView!.frame) - alignmentWidth) / 2
      
      // Adjust each item's position to be centered
      var previousFrame = CGRectZero
      for itemAttributes in itemAttributesCollection
      {
        var itemFrame = itemAttributes.frame
        
        if CGRectEqualToRect(previousFrame, CGRectZero) {
          itemFrame.origin.x = alignmentXOffset
        }
        else {
          itemFrame.origin.x = CGRectGetMaxX(previousFrame) + self.minimumInteritemSpacing
        }
        
        itemAttributes.frame = itemFrame
        previousFrame = itemFrame
      }
    }
    
    return superAttributes;
  }
   
}
