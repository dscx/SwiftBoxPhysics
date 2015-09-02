//
//  ViewController.swift
//  dynamicsDemo
//
//  Created by Dan Chamberlain on 9/2/15.
//  Copyright (c) 2015 dscx. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var greenBox: UIView?
    
    var animator: UIDynamicAnimator?
    var gravity: UIGravityBehavior?
    var collision: UICollisionBehavior?
    
    var gesture: UIPanGestureRecognizer!
    var attach: UIAttachmentBehavior?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        greenBox = UIView()
        greenBox!.backgroundColor = UIColor.greenColor()
        greenBox!.frame = CGRectMake(CGRectGetMidX(self.view.frame) - 50, CGRectGetMidY(self.view.frame) - 50, 100, 100)
        
        self.view.addSubview(greenBox!)
        
        animator = UIDynamicAnimator(referenceView: self.view)
        gravity = UIGravityBehavior(items: [greenBox!])
        
        collision = UICollisionBehavior(items: [greenBox!])
        collision!.translatesReferenceBoundsIntoBoundary = true
        
        gesture = UIPanGestureRecognizer(target: self, action: "panning:")
        

        animator!.addBehavior(gravity)
        animator!.addBehavior(collision)
        
        greenBox!.addGestureRecognizer(gesture)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }


    func panning(pan: UIPanGestureRecognizer){
        var location = pan.locationInView(self.view)
        var touchLocation = pan.locationInView(self.greenBox)
        var behavior = UIDynamicItemBehavior(items: [self.greenBox!])
        
        switch(pan.state) {
            case .Began:
                self.animator!.removeAllBehaviors()
                var offset = UIOffsetMake(touchLocation.x - CGRectGetMidX(self.greenBox!.bounds), touchLocation.y - CGRectGetMidY(self.greenBox!.bounds))
                attach = UIAttachmentBehavior(item: self.greenBox!, offsetFromCenter: offset, attachedToAnchor: location)
                self.animator!.addBehavior(self.attach)
            case .Changed:
                self.attach!.anchorPoint = location
            case .Ended:
                self.animator!.removeBehavior(self.attach)
                
                behavior.addLinearVelocity(pan.velocityInView(self.view), forItem: self.greenBox!)
                behavior.angularResistance = 70
                behavior.elasticity = 0.75
                
                self.animator!.addBehavior(behavior)
                self.animator!.addBehavior(self.gravity)
                self.animator!.addBehavior(self.collision)
            default:
                break
            
        }
    }


}

