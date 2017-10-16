//
//  CircularTransaction.swift
//  iMonocle
//
//  Created by Alisher Abdukarimov on 9/28/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

enum CircularTransitionMode: Int {
    case present, dismiss, pop
}


class CircularTransaction: NSObject {
    
    var circle = UIView()
    
    var startingPoint = CGPoint.zero {
        didSet {
            circle.center = startingPoint
        }
    }
    
    var circleColor = UIColor.clear
    
    var duration = 0.5
    
    var transitionMode: CircularTransitionMode = .present
    
}

extension CircularTransaction: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        if transitionMode == .present {
            if let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to) {
                let viewCenter = presentedView.center
                let viewSize = presentedView.frame.size
                
                circle = UIView()
                
                circle.frame = frameForCirle(withViewCenter: viewCenter, size: viewSize, startpoint: startingPoint)
                
                circle.layer.cornerRadius = circle.frame.size.height / 2
                circle.center = startingPoint
                circle.backgroundColor = UIColor.clear
                circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                circle.alpha = 0.0
                containerView.addSubview(circle)
                
                presentedView.center = startingPoint
                presentedView.alpha = 0
                presentedView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                containerView.addSubview(presentedView)
                
                UIView.animate(withDuration: duration, animations: {
                    self.circle.transform = CGAffineTransform.identity
                    presentedView.transform = CGAffineTransform.identity
                    presentedView.alpha = 1
                    self.circle.backgroundColor = UIColor.lightGray
                    self.circle.alpha = 0.2
                    presentedView.center = viewCenter
                }, completion: { (success) in
                    transitionContext.completeTransition(success)
                })
                
                
            }
        } else {
            let transitionModeKey = (transitionMode == .pop) ? UITransitionContextViewKey.to : UITransitionContextViewKey.from
            
            if let returningView = transitionContext.view(forKey: transitionModeKey) {
                let viewCenter = returningView.center
                let viewSize = returningView.frame.size
                
                circle.frame = frameForCirle(withViewCenter: viewCenter, size: viewSize, startpoint: startingPoint)
                circle.layer.cornerRadius = circle.frame.size.height / 2
                circle.center = startingPoint
                
                UIView.animate(withDuration: duration, animations: {
                    self.circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    returningView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    returningView.center = self.startingPoint
                    returningView.alpha = 0
                    
                    if self.transitionMode == .pop {
                        containerView.insertSubview(returningView, belowSubview: returningView)
                        containerView.insertSubview(self.circle, belowSubview: returningView)
                    }
                }, completion: { (success) in
                    returningView.center = viewCenter
                    returningView.removeFromSuperview()
                    
                    self.circle.removeFromSuperview()
                    
                    transitionContext.completeTransition(success)
                })
            }
        }
    }
    
    func frameForCirle (withViewCenter center: CGPoint, size viewSize: CGSize, startpoint: CGPoint) -> CGRect {
        let xLength = fmax(startingPoint.x, viewSize.width - startingPoint.x)
        let yLength = fmax(startingPoint.y, viewSize.height - startingPoint.y)
        
        let offsetVector = sqrt(xLength * xLength + yLength * yLength) * 2
        let size = CGSize(width: offsetVector, height: offsetVector)
        
        return CGRect(origin: CGPoint.zero, size: size)
    }
}
