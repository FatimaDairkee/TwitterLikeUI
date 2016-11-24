//
//  HeaderViewClass.swift
//  Twitter Like UI
//
//  Created by Fatima mhowwala on 20/11/16.
//  Copyright © 2016 ThoughtBeans. All rights reserved.
//

import UIKit

class HeaderViewClass: UIView {
  
  var headerBlurImageView:UIImageView!
  var headerImageView:UIImageView!
  @IBOutlet var headerLabel : UILabel!
  
  override func awakeFromNib() {
     self.configureView()
  }

  override public init(frame: CGRect) {
    super.init(frame: frame)
    self.configureView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  func configureView() {
    headerImageView = UIImageView(frame: self.bounds)
    headerImageView?.image = UIImage(named: "header_bg")
    headerImageView?.contentMode = UIViewContentMode.scaleAspectFill
    self.insertSubview(headerImageView, belowSubview: headerLabel)
    
    // Header - Blurred Image
    headerBlurImageView = UIImageView(frame: self.bounds)
    headerBlurImageView?.image = UIImage(named: "header_bg")?.blurredImage(withRadius: 10, iterations: 20, tintColor: UIColor.clear)
    headerBlurImageView?.contentMode = UIViewContentMode.scaleAspectFill
    headerBlurImageView?.alpha = 0.0
    self.insertSubview(headerBlurImageView, belowSubview: headerLabel)
    self.clipsToBounds = true
  }
  
  public func scaleHeaderViewOnPullDown(forOffset: CGFloat) -> CATransform3D {
    var headerTransform = CATransform3DIdentity

  let headerScaleFactor:CGFloat = -(forOffset) / self.frame.size.height
  let headerSizevariation = ((self.frame.size.height * (1.0 + headerScaleFactor)) - self.frame.size.height)/2
  headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
  headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
  // Hide views if scrolled super fast
  self.layer.zPosition = 0
  self.headerLabel.isHidden = true
  return headerTransform
  }
  
  func processHeaderAnimationOnScrollUP(forOffset: CGFloat, alignmentOffsetForNameLabel: CGFloat) -> CATransform3D {
    var headerTransform = CATransform3DIdentity

  headerTransform = CATransform3DTranslate(headerTransform, 0, max(-offset_HeaderStop, -forOffset), 0)
  
  self.headerLabel.isHidden = false
  self.headerLabel.frame.origin = CGPoint(x: self.headerLabel.frame.origin.x, y: max(alignmentOffsetForNameLabel, topDistanceWithSubHeader + offset_HeaderStop))
  
  self.headerBlurImageView?.alpha = min (1.0, (forOffset - alignmentOffsetForNameLabel)/topDistanceWithSubHeader)
    return headerTransform
  }
  
}
