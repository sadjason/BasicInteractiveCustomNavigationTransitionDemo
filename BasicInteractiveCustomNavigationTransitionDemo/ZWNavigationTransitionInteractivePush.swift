//
//  ZWNavigationTransitionInteractivePush.swift
//  NavigationTransitionDemos
//
//  Created by 张威 on 16/7/2.
//  Copyright © 2016年 zhangwei. All rights reserved.
//

import UIKit

class ZWNavigationTransitionInteractivePush: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {
  
  var isInteracting = false   // indicates whether the transition is currently interactive.
  var operation: UINavigationControllerOperation = .None
  
  private var shouldComplete = false  // indicates whether the transition should complete/cancel
  private let privarteDuration: NSTimeInterval = 0.25
  
  private var toViewCacheAlphaForPopping: CGFloat = 1.0
  private let maskAlphaForInteraction: CGFloat = 0.95
  
  override var duration: CGFloat {
    return CGFloat(privarteDuration)
  }
  
  private var panGesture: UIPanGestureRecognizer!
  private var topViewController: UIViewController!
  
  func attachPanGestureRecognizerToViewController(viewController: UIViewController) {
    panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGestureRecognizer(_:)))
    viewController.view.addGestureRecognizer(panGesture)
    topViewController = viewController
  }
  
  @objc private func handlePanGestureRecognizer(pan: UIPanGestureRecognizer) {
  
    if topViewController == nil {
      return
    }
    
    switch pan.state {
    case .Began:
      isInteracting = true
      pan.setTranslation(CGPointZero, inView: topViewController.view)
      
      topViewController.navigationController?.popViewControllerAnimated(true)
      
    case .Changed:
      let translation = pan.translationInView(topViewController.view)
      var fraction = translation.x / topViewController.view.bounds.width
      fraction = min(1.0, max(fraction, 0.0))
      shouldComplete = (fraction >= 0.5)
      updateInteractiveTransition(fraction)
      
    case .Cancelled, .Ended:
      isInteracting = false
      
      if pan.state == .Cancelled || !shouldComplete {
        cancelInteractiveTransition()
      } else {
        finishInteractiveTransition()
        
        topViewController.view.removeGestureRecognizer(pan)
      }
    default:
      break
    }
  }
  
  // MARK: UIViewControllerAnimatedTransitioning
  
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return privarteDuration
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    let containerView: UIView! = transitionContext.containerView()
    let fromVC: UIViewController! = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
    let toVC: UIViewController! = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
    
    if operation == .Push {
      toVC.view.frame = containerView.bounds
      containerView.addSubview(toVC.view)
      
      toVC.view.transform = CGAffineTransformMakeTranslation(containerView.bounds.width, 0.0)
      UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
        toVC.view.transform = CGAffineTransformIdentity
        fromVC.view.transform = CGAffineTransformMakeTranslation(-containerView.bounds.width, 0.0)
      }) { (finished) in
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
      }
    } else if operation == .Pop {
      containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
      
      toViewCacheAlphaForPopping = toVC.view.alpha
      toVC.view.alpha = maskAlphaForInteraction
      toVC.view.transform = CGAffineTransformMakeTranslation(-containerView.bounds.width, 0.0)
      
      UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
        toVC.view.transform = CGAffineTransformIdentity
        fromVC.view.transform = CGAffineTransformMakeTranslation(containerView.bounds.width, 0.0)
        
        }, completion: { (finished) in
          transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
          toVC.view.alpha = self.toViewCacheAlphaForPopping
      })
    }
  }
}
