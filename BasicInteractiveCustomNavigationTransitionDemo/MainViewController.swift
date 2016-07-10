//
//  MainViewController.swift
//  BasicInteractiveCustomNavigationTransitionDemo
//
//  Created by 张威 on 16/7/2.
//  Copyright © 2016年 zhangwei. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UINavigationControllerDelegate {
  
  lazy var transitioner: ZWNavigationTransitionInteractivePush = ZWNavigationTransitionInteractivePush()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.delegate = self
    
    let bounds = view.bounds
    let label = UILabel(frame: CGRectMake(10, 80, bounds.width-20, 20))
    label.text = "a b c d e f g h i j k l m n o p q r s t u v w x y z"
    label.font = UIFont.systemFontOfSize(14)
    label.textColor = UIColor.blackColor()
    label.backgroundColor = UIColor.lightGrayColor()
    view.addSubview(label)
    
    title = "Main"
    view.backgroundColor = UIColor.whiteColor()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: #selector(showDetailVC(_:)))
  }
  
  @objc func showDetailVC(id: AnyObject) {
    let detailVC = DetailViewController()
    transitioner.attachPanGestureRecognizerToViewController(detailVC)
    navigationController?.pushViewController(detailVC, animated: true)
  }
  
  
  // MARK: UINavigationControllerDelegate
  func navigationController(navigationController: UINavigationController,
                            animationControllerForOperation operation: UINavigationControllerOperation,
                                                            fromViewController fromVC: UIViewController,
                                                                               toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transitioner.operation = operation
    return transitioner
  }
  
  func navigationController(navigationController: UINavigationController,
                            interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    if let animator = animationController as? ZWNavigationTransitionInteractivePush {
      if animator.operation == .Pop {
        return transitioner.isInteracting ? transitioner : nil
      }
    }
    return nil
  }
}

