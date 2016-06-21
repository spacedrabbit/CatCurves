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
  let KnollFill: UIColor = UIColor(red: 190.0/255.0, green: 235.0/255.0, blue: 159.0/255.0, alpha: 1.0)
  
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
    
    // wave crest anims
    let bezPathStage0: UIBezierPath = UIBezierPath()
    bezPathStage0.moveToPoint(rectRef.bottomLeft)
    bezPathStage0.addLineToPoint(rectRef.bottomRight)
    bezPathStage0.addLineToPoint(rectRef.topRight)
    bezPathStage0.addLineToPoint(rectRef.topLeft) // straight line
    bezPathStage0.closePath()
    
    let bezPathStage1: UIBezierPath = UIBezierPath()
    bezPathStage1.moveToPoint(rectRef.bottomLeft)
    bezPathStage1.addLineToPoint(rectRef.bottomRight)
    bezPathStage1.addLineToPoint(rectRef.topRight)
    bezPathStage1.addQuadCurveToPoint(rectRef.topLeft, controlPoint: CGPointMake(rectRef.minX, rectRef.minY)) // top left control point
    bezPathStage1.closePath()
    
    let bezPathStage2: UIBezierPath = UIBezierPath()
    bezPathStage2.moveToPoint(rectRef.bottomLeft)
    bezPathStage2.addLineToPoint(rectRef.bottomRight)
    bezPathStage2.addLineToPoint(rectRef.topRight)
    bezPathStage2.addQuadCurveToPoint(rectRef.topLeft, controlPoint: CGPointMake(rectRef.midX, rectRef.minY - (rectRef.viewRef.frame.size.height / 2.0))) // top middle control point
    bezPathStage2.closePath()
    
    let bezPathStage3: UIBezierPath = UIBezierPath()
    bezPathStage3.moveToPoint(rectRef.bottomLeft)
    bezPathStage3.addLineToPoint(rectRef.bottomRight)
    bezPathStage3.addLineToPoint(rectRef.topRight)
    bezPathStage3.addQuadCurveToPoint(rectRef.topLeft, controlPoint: CGPointMake(rectRef.maxX, rectRef.minY)) // top right control point
    bezPathStage3.closePath()
    
    let bezPathStage4: UIBezierPath = bezPathStage0
    
    // wave trough anims
    let bezPathStage5: UIBezierPath = UIBezierPath()
    bezPathStage5.moveToPoint(rectRef.bottomLeft)
    bezPathStage5.addLineToPoint(rectRef.bottomRight)
    bezPathStage5.addLineToPoint(rectRef.topRight)
    bezPathStage5.addQuadCurveToPoint(rectRef.topLeft, controlPoint: CGPointMake(rectRef.maxX, rectRef.maxY)) // bottom right control point
    bezPathStage5.closePath()
    
    let bezPathStage6: UIBezierPath = UIBezierPath()
    bezPathStage6.moveToPoint(rectRef.bottomLeft)
    bezPathStage6.addLineToPoint(rectRef.bottomRight)
    bezPathStage6.addLineToPoint(rectRef.topRight)
    bezPathStage6.addQuadCurveToPoint(rectRef.topLeft, controlPoint: CGPointMake(rectRef.midX, rectRef.maxY + (rectRef.viewRef.frame.size.height / 2.0))) // bottom right control point
    bezPathStage6.closePath()
    
    let bezPathStage7: UIBezierPath = UIBezierPath()
    bezPathStage7.moveToPoint(rectRef.bottomLeft)
    bezPathStage7.addLineToPoint(rectRef.bottomRight)
    bezPathStage7.addLineToPoint(rectRef.topRight)
    bezPathStage7.addQuadCurveToPoint(rectRef.topLeft, controlPoint: CGPointMake(rectRef.minX, rectRef.maxY)) // bottom right control point
    bezPathStage7.closePath()
    
    let bezPathStage8: UIBezierPath = bezPathStage0
    
    let animStage0: CABasicAnimation = CABasicAnimation(keyPath: "path")
    animStage0.fromValue = bezPathStage0.CGPath
    animStage0.toValue = bezPathStage1.CGPath
    animStage0.beginTime = 0.0
    animStage0.duration = 1.0
    
    let animStage1: CABasicAnimation = CABasicAnimation(keyPath: "path")
    animStage1.fromValue = bezPathStage1.CGPath
    animStage1.toValue = bezPathStage2.CGPath
    animStage1.beginTime = animStage0.beginTime + animStage0.duration
    animStage1.duration =  animStage0.duration

    let animStage2: CABasicAnimation = CABasicAnimation(keyPath: "path")
    animStage2.fromValue = bezPathStage2.CGPath
    animStage2.toValue = bezPathStage3.CGPath
    animStage2.beginTime = animStage1.beginTime + animStage1.duration
    animStage2.duration = animStage0.duration
    
    let animStage3: CABasicAnimation = CABasicAnimation(keyPath: "path")
    animStage3.fromValue = bezPathStage3.CGPath
    animStage3.toValue = bezPathStage4.CGPath
    animStage3.beginTime = animStage2.beginTime + animStage2.duration
    animStage3.duration = animStage0.duration
    
    let animStage4: CABasicAnimation = CABasicAnimation(keyPath: "path")
    animStage4.fromValue = bezPathStage4.CGPath
    animStage4.toValue = bezPathStage5.CGPath
    animStage4.beginTime = animStage3.beginTime + animStage3.duration
    animStage4.duration = animStage0.duration
    
    let animStage5: CABasicAnimation = CABasicAnimation(keyPath: "path")
    animStage5.fromValue = bezPathStage5.CGPath
    animStage5.toValue = bezPathStage6.CGPath
    animStage5.beginTime = animStage4.beginTime + animStage4.duration
    animStage5.duration = animStage0.duration
    
    let animStage6: CABasicAnimation = CABasicAnimation(keyPath: "path")
    animStage6.fromValue = bezPathStage6.CGPath
    animStage6.toValue = bezPathStage7.CGPath
    animStage6.beginTime = animStage5.beginTime + animStage5.duration
    animStage6.duration = animStage0.duration
    
    let animStage7: CABasicAnimation = CABasicAnimation(keyPath: "path")
    animStage7.fromValue = bezPathStage7.CGPath
    animStage7.toValue = bezPathStage8.CGPath
    animStage7.beginTime = animStage6.beginTime + animStage6.duration
    animStage7.duration = animStage0.duration
    
    let drawingLayer = CAShapeLayer()
    drawingLayer.path = bezPathStage0.CGPath
    drawingLayer.strokeColor = Knoll.CGColor
    drawingLayer.fillColor = KnollFill.CGColor
    drawingLayer.lineWidth = 4.0

    let waveAnimGroup: CAAnimationGroup = CAAnimationGroup()
    waveAnimGroup.animations = [animStage0, animStage1, animStage2, animStage3, animStage4, animStage5, animStage6, animStage7]
    waveAnimGroup.duration = animStage7.beginTime + animStage7.duration
    waveAnimGroup.fillMode = kCAFillModeForwards
    waveAnimGroup.removedOnCompletion = false
    waveAnimGroup.repeatCount = Float.infinity
    
    drawingLayer.addAnimation(waveAnimGroup, forKey: "waveCrest")
    refView.layer.addSublayer(drawingLayer)
  }
  
  // MARK - Bezier Points
  
  
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

