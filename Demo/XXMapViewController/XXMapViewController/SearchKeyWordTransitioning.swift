//
//  SearchKeyWordTransitioning.swift
//  XXMapViewController
//
//  Created by Wangyun on 16/10/8.
//  Copyright © 2016年 Wangyun. All rights reserved.
//

import UIKit

let kWidth = UIScreen.mainScreen().bounds.size.width;
let kHeight = UIScreen.mainScreen().bounds.size.height;

class SearchKeyWordTransitioning: NSObject,UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning {
    enum Status: Int {
        case Presented,Dismissed
    }
    var fromView = UIView();
    var toView = UIView();
    private var currentStatus:Status!;
    
    class func sharedInstance () ->SearchKeyWordTransitioning{
        struct Singleton{
            static let instance = SearchKeyWordTransitioning();
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
        
        var menuVC = SearchKeyWordViewController();
        
        if self.currentStatus == Status.Presented {
            menuVC = toVC as! SearchKeyWordViewController
            if menuVC.isKindOfClass(SearchKeyWordViewController) {
                containerView?.addSubview(menuVC.view)
                menuVC.topView.backgroundColor = UIColor.clearColor()
                menuVC.topView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 64)
                
                UIView.animateWithDuration(self.transitionDuration(transitionContext), animations: { 
                    menuVC.contentView.backgroundColor = UIColor(colorLiteralRed: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
                    menuVC.topView.layoutIfNeeded()
                    }, completion: { (Bool) in
                    menuVC.topView.backgroundColor = UIColor(colorLiteralRed: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0)
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                })
            }else{
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            }
        }else{
            menuVC = fromVC as! SearchKeyWordViewController
            if menuVC.isKindOfClass(SearchKeyWordViewController) {
                menuVC.topView.backgroundColor = UIColor.clearColor()
                menuVC.backButton.hidden = true
                menuVC.textFieldBagView.frame = CGRect(x: 50, y: 24, width: menuVC.topView.frame.width-70, height: 35)
                UIView.animateWithDuration(self.transitionDuration(transitionContext), animations: {
                    menuVC.contentView.alpha = 0
                    menuVC.topView.layoutIfNeeded()
                    }, completion: { (Bool) in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                })
            }else{
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            }
        }
        
    }

}

