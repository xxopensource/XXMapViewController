//
//  AddressDetailTransitioning.swift
//  XXMapViewController
//
//  Created by Wangyun on 16/10/13.
//  Copyright © 2016年 Wangyun. All rights reserved.
//

import UIKit


class AddressDetailTransitioning: NSObject,UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning {
    enum Status: Int {
        case Presented,Dismissed
    }
    var fromView = UIView();
    var toView = UIView();
    private var currentStatus:Status!;
    
     class func shareTransitioning() ->AddressDetailTransitioning{
        struct Singleton{
            static let instance = AddressDetailTransitioning();
        }
        return Singleton.instance;
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.currentStatus = .Presented;
        return self;
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.currentStatus = .Dismissed;
        return self;
    }
    
    
    // MARK: UIViewControllerAnimatedTransitioning
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.6;
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // 从跳转上下文中取出跳转开始和目的视图控制器
        let fromVC: UIViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!;
        let toVC: UIViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!;
        let containerView = transitionContext.containerView();
        
        var menuVC = AddressDetailViewController();
        
        if self.currentStatus == Status.Presented {
            menuVC = toVC as! AddressDetailViewController
            if menuVC.isKindOfClass(AddressDetailViewController) {
                containerView?.addSubview(menuVC.view)
                menuVC.contentView.layoutIfNeeded()
                
                let menuVCContentView = menuVC.contentView.snapshotViewAfterScreenUpdates(true)
                containerView?.addSubview(menuVCContentView)
                menuVCContentView.frame = CGRect(x: (containerView?.center.x)!, y: (containerView?.center.y)!, width: 0, height: 0)
                menuVC.view.backgroundColor = UIColor(white: 0, alpha: 0)
                menuVC.contentView.hidden = true
                
                UIView.animateWithDuration(self.transitionDuration(transitionContext), delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: { 
                    menuVC.view.backgroundColor = UIColor(white: 0, alpha: 0.4)
                    menuVCContentView.frame = menuVC.contentView.frame
                    }, completion: { (Bool) in
                        menuVCContentView.removeFromSuperview()
                        menuVC.contentView.hidden = false
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                })
            }else{
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            }
        }else{
            menuVC = fromVC as! AddressDetailViewController
            if menuVC.isKindOfClass(AddressDetailViewController) {
                menuVC.contentView.hidden = true
                UIView.animateWithDuration(self.transitionDuration(transitionContext), animations: {
                    menuVC.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
                    }, completion: { (Bool) in
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                })
            }else{
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            }
        }
        
    }
}
