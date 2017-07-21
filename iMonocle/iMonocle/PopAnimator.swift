/*
 * Copyright (c) 2014-2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit


class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
  let duration = 0.7
  var originFrame = CGRect.zero
  var presenting = true
  var bView: UIView?
    
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    //1) Set up transition
    let containerView = transitionContext.containerView
    let toView = transitionContext.view(forKey: .to)!
    
    let detailView = presenting ? toView : transitionContext.view(forKey: .from)!
    
    let initialFrame = presenting ? originFrame : detailView.frame
    let finalFrame = presenting ? detailView.frame : originFrame
    
    let yScaleFactor = presenting ? initialFrame.height / finalFrame.height : finalFrame.height  / initialFrame.height
    let xScaleFactor = presenting ? initialFrame.width / finalFrame.width : finalFrame.width / initialFrame.width
    let scaleFactor = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
    
    if presenting {
    detailView.transform = scaleFactor
    detailView.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
    }
    containerView.addSubview(toView)
    containerView.bringSubview(toFront: detailView)
    
    let detailVController = transitionContext.viewController(forKey: presenting ? .to : .from) as! DetailViewController
    
    if !presenting {
        
        
    }
    //2) Animate!
    UIView.animate(
      withDuration: duration,
      delay: 0.0,
      usingSpringWithDamping: 1.0,
      initialSpringVelocity: 1.0,
      animations: {
        detailView.transform = self.presenting ? .identity : scaleFactor
        detailView.center = CGPoint(
          x: finalFrame.midX,
          y: finalFrame.midY
        )
      },
      completion: {_ in
    //3) Complete transition
        if self.presenting == false {
            
        }
        transitionContext.completeTransition(true)
      }
    )
    
    let round = CABasicAnimation(keyPath: "cornerRadius")
    round.fromValue = !presenting ? 0.0 : 20/xScaleFactor
    round.toValue = presenting ? 0.0 : 20/xScaleFactor
    round.duration = duration / 2
    detailView.layer.add(round, forKey: nil)
    detailView.layer.cornerRadius = presenting ? 0.0 : 20.0/xScaleFactor
    detailView.clipsToBounds = true
  }
    
    func passView(_ viewFrom: UIView) -> UIView {
        return viewFrom
    }
}
