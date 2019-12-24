//
//  DropSegue.swift
//  DropSegue
//
//  Created by Usama Sadiq on 12/20/19.
//  Copyright © 2019 Usama Sadiq. All rights reserved.

import UIKit

// MARK:- Custom Segue

class DropSegue: UIStoryboardSegue {

  override func perform() {
    destination.transitioningDelegate = self
    super.perform()
  }
}

extension DropSegue: UIViewControllerTransitioningDelegate {
  func animationController(forPresented presented: UIViewController,
     presenting: UIViewController,
     source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return DropPresentAnimator()
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return DropDismissAnimator()
  }
}

// MARK:- Animator

class DropPresentAnimator:NSObject, UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 4
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
    // 1. Get the transition context to- view controller and view
    let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
    let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)

    // 2. Add the to-view to the transition context
    if let toView = toView {
      transitionContext.containerView.addSubview(toView)
    }

    // 3. Set up the initial state for the animation
    let finalFrame = transitionContext.finalFrame(for: toViewController)
    var startFrame = finalFrame
    startFrame.origin.y = -finalFrame.height
    
    toView?.frame = startFrame
    toView?.layoutIfNeeded()

    // 4. Perform the animation
    let duration = transitionDuration(using: transitionContext)
    
    UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.5,
      initialSpringVelocity: 6, options: UIView.AnimationOptions(), animations: {
      if let toView = toView {
        toView.frame = finalFrame
      }
      }, completion: {
        finished in
        // 5. Clean up the transition context
        transitionContext.completeTransition(true)
        
    })
  }
}

class DropDismissAnimator:NSObject, UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.5
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
    // 1. Get the transition context from- view controller and view
    let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
    let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
    let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
    
    // 2. Add the to-view to the transition context
    if let fromView = fromView {
      if let toView = toView {
        transitionContext.containerView.insertSubview(toView, belowSubview: fromView)
      }
    }
    
    // 3. Set up the initial state for the animation
    var finalFrame = transitionContext.finalFrame(for: fromViewController)
    finalFrame.origin.y = -finalFrame.height
    
    // 4. Perform the animation
    let duration = transitionDuration(using: transitionContext)
    UIView.animate(withDuration: duration, animations: {
      if let fromView = fromView {
        fromView.frame = finalFrame
        fromView.layoutIfNeeded()
      }
      }, completion: {
        finished in
        // 5. Clean up the transition context
        transitionContext.completeTransition(true)
    })
  }
}

