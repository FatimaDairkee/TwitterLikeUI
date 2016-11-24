//
//  ViewController.swift
//  Twitter Like UI
//
//  Created by Fatima mhowwala on 20/11/2016.
//  Copyright (c) 2016 ThoughtBeans. All rights reserved.
//

import UIKit

let offset_HeaderStop:CGFloat = 40.0 // At this offset the Header stops its transformations
let topDistanceWithSubHeader:CGFloat = 30.0 // The distance between the top of the screen and the top of the White Label


enum contentTypes {
  case tweets, media, likes
}

class ViewController: UIViewController, UITableViewDelegate, UIScrollViewDelegate {
  
  @IBOutlet var tableView : UITableView!
  @IBOutlet var headerView : HeaderViewClass!
  @IBOutlet var profileView : UIView!
  @IBOutlet var segmentedView : UIView!
  @IBOutlet var avatarImage:AvatarImageView!
  @IBOutlet var handleLabel : UILabel!
  
  // MARK: class properties

  var contentToDisplay : contentTypes = .tweets
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.contentInset = UIEdgeInsetsMake(headerView.frame.height, 0, 0, 0)
  }
 
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: Scroll view delegate
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offset = scrollView.contentOffset.y + headerView.bounds.height
    var avatarTransform = CATransform3DIdentity
    var headerTransform = CATransform3DIdentity
    
     // PULL DOWN
    if offset < 0 {
      headerTransform = headerView.scaleHeaderViewOnPullDown(forOffset: offset)
    }
      
    // SCROLL UP/DOWN
    else {
     let allignmentOffsetNameLabel = -offset + handleLabel.frame.origin.y + headerView.frame.height + offset_HeaderStop
     headerTransform = headerView.processHeaderAnimationOnScrollUP(forOffset: offset, alignmentOffsetForNameLabel: allignmentOffsetNameLabel)
      
     avatarTransform = avatarImage.scaleAnimationWhileScrolling(forOffset: offset)
      
      if offset <= offset_HeaderStop {
        NSLog("%d %d ", avatarImage.layer.zPosition, headerView.layer.zPosition)
        if avatarImage.layer.zPosition < headerView.layer.zPosition{
          headerView.layer.zPosition = 0
        }
      }else {
        if avatarImage.layer.zPosition >= headerView.layer.zPosition{
          headerView.layer.zPosition = 2
        }
      }
    }
    
    // Apply Transformations
    headerView.layer.transform = headerTransform
    avatarImage.layer.transform = avatarTransform
    
    // Segment control
    
    let segmentViewOffset = profileView.frame.height - segmentedView.frame.height - offset
    var segmentTransform = CATransform3DIdentity
    
    // Scroll the segment view until its offset reaches the same offset at which the header stopped shrinking
    segmentTransform = CATransform3DTranslate(segmentTransform, 0, max(segmentViewOffset, -offset_HeaderStop), 0)
    segmentedView.layer.transform = segmentTransform
  
    // Set scroll view insets just underneath the segment control
    tableView.scrollIndicatorInsets = UIEdgeInsetsMake(segmentedView.frame.maxY, 0, 0, 0)
  }
  
  // MARK: Interface buttons
  
  @IBAction func selectContentType(_ sender: UISegmentedControl) {
    switch sender.selectedSegmentIndex {
    case 0:
     contentToDisplay = .tweets
    case 1:
       contentToDisplay = .media
    case 2:
      contentToDisplay = .likes
    default:
      contentToDisplay = .tweets
    }
    tableView.reloadData()
  }
  
  @IBAction func followButtonClicked() {
    if !UIApplication.shared.openURL(URL(string:"twitter://user?screen_name=fatema_21")!){
      UIApplication.shared.openURL(URL(string:"https://twitter.com/fatema_21")!)
    }
  }
  
}

extension ViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch contentToDisplay {
    case .tweets:
      return 40
    case .media:
      return 1
    case .likes:
      return 1
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    switch contentToDisplay {
    case .tweets:
      cell.textLabel?.text = "Tweets!"
    case .media:
      cell.textLabel?.text = "Your media items appear here"
      cell.textLabel?.textColor = UIColor.gray
    case .likes:
      cell.textLabel?.text = "Your liked tweets appear here"
      cell.textLabel?.textColor = UIColor.gray
    }
    return cell
  }
}
