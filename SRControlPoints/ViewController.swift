//
//  ViewController.swift
//  SRControlPoints
//
//  Created by Louis Tur on 6/21/16.
//  Copyright © 2016 catthoughts. All rights reserved.
//

import UIKit
import SnapKit

internal struct RectFramer {
  var viewRef: UIView
  
  let maxY, maxX, midX, midY, minX, minY: CGFloat
  let origin, bottomRight, topLeft, topRight, bottomLeft: CGPoint
  
  internal init(withView view: UIView) {
    viewRef = view
    
    maxY = CGRectGetMaxY(view.bounds)
    maxX = CGRectGetMaxX(view.bounds)
    minX = CGRectGetMinX(view.bounds)
    minY = CGRectGetMinY(view.bounds)
    midX = CGRectGetMidX(view.bounds)
    midY = CGRectGetMidY(view.bounds)
    origin = CGPointMake(minX, maxY)
    bottomRight = CGPointMake(maxX, maxY)
    topRight = CGPointMake(maxX, midY)
    topLeft = CGPointMake(minX, midY)
    bottomLeft = origin
  }
  
}

class ViewController: UIViewController {
  var frameRef: RectFramer?
  
  // MARK: - Variables
  let Oatmeal: UIColor = UIColor(red: 255.0/255.0, green: 240.0/255.0, blue: 165.0/255.0, alpha: 1.0)
  let Knoll: UIColor = UIColor(red: 70.0/255.0, green: 137.0/255.0, blue: 102.0/255.0, alpha: 1.0)
  var sizingToken: dispatch_once_t = 0
  
  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setupViewHierarchy()
    self.configureConstraints()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func viewDidLayoutSubviews() {
    dispatch_once(&sizingToken) { 
      self.frameRef = RectFramer(withView: self.drawingView)
    }
    
    if self.frameRef != nil {
      self.drawLineIn(withRectRef: self.frameRef!)
    }
  }
  
  
  // MARK: - Drawing
  internal func drawLineIn(withRectRef rectRef: RectFramer) {
    let refView = rectRef.viewRef
    
    let bezPath: UIBezierPath = UIBezierPath()
    bezPath.moveToPoint(rectRef.bottomLeft)
    bezPath.addLineToPoint(rectRef.bottomRight)
    bezPath.addLineToPoint(rectRef.topRight)
    
    //  bezPath.addLineToPoint(topLeft) // straight line
    //  bezPath.addQuadCurveToPoint(topLeft, controlPoint: CGPointMake(midX, minY)) // gentle convex curve at top line of rect
    bezPath.addQuadCurveToPoint(rectRef.topLeft, controlPoint: CGPointMake(rectRef.midX, rectRef.maxY)) // gentle concave curve of top line of rect
    bezPath.closePath()
    
    let drawingLayer = CAShapeLayer()
    drawingLayer.path = bezPath.CGPath
    drawingLayer.strokeColor = Knoll.CGColor
    drawingLayer.fillColor = UIColor.clearColor().CGColor
    drawingLayer.lineWidth = 4.0
    
    refView.layer.addSublayer(drawingLayer)
  }
  
  
  // MARK: - Layout
  internal func configureConstraints() {
    self.drawingView.snp_makeConstraints { (make) in
      make.left.right.centerY.equalTo(self.view)
      make.height.equalTo(200.0)
    }
  }
  
  internal func setupViewHierarchy() {
    self.view.addSubview(drawingView)
  }
  
  internal lazy var drawingView: UIView = {
  let view: UIView = UIView()
  view.backgroundColor = self.Oatmeal
  return view
  }()

}

