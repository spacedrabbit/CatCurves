//
//  ViewController.swift
//  SRControlPoints
//
//  Created by Louis Tur on 6/21/16.
//  Copyright © 2016 catthoughts. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
  
  
  // MARK: - Variables
  let Oatmeal: UIColor = UIColor(red: 255.0/255.0, green: 240.0/255.0, blue: 165.0/255.0, alpha: 1.0)
  let Knoll: UIColor = UIColor(red: 70.0/255.0, green: 137.0/255.0, blue: 102.0/255.0, alpha: 1.0)

  
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
    self.drawLineIn(self.drawingView)
  }
  
  
  // MARK: - Drawing
  internal func drawLineIn(view: UIView) {
//    view.layer.anchorPoint = CGPointMake(0.0, 0.0)
    
    let bezPath: UIBezierPath = UIBezierPath()
    bezPath.moveToPoint(CGPointMake(0.0, 0.0))
    bezPath.addLineToPoint(CGPointMake(CGRectGetMaxX(view.bounds), 0.0))
    bezPath.addLineToPoint(CGPointMake(CGRectGetMaxX(view.bounds), CGRectGetMidY(view.bounds)))
    bezPath.addLineToPoint(CGPointMake(0.0, CGRectGetMidY(view.bounds)))
    bezPath.closePath()
    
    let drawingLayer = CAShapeLayer()
    drawingLayer.path = bezPath.CGPath
    drawingLayer.strokeColor = Knoll.CGColor
    drawingLayer.fillColor = UIColor.clearColor().CGColor
    drawingLayer.lineWidth = 4.0
    
    view.layer.addSublayer(drawingLayer)
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

