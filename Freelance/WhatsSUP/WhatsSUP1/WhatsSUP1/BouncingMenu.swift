//
//  BouncingMenu.swift
//  BouncingMenu
//
//  Created by Oli Rodden on 17/09/2014.
//  Copyright (c) 2014 OliRodd. All rights reserved.
//

import UIKit

protocol BouncingMenuDelegate{
    func alphaValueChanged(alphaValue:CGFloat);
}

class BouncingMenu: UIImageView{
    let swipeIcon = UIImageView(frame: CGRectMake(144.0, 20.0, 54.0, 52.0))
    let swipeDownIcon = UIImageView(frame: CGRectMake(144.0, 20.0, 59.0, 52.0))
    let bounceTimer:NSTimer?
    var inUse = false //true when the label is held or "open", used to know wether to 'bounce or not'
    var touchOffset:CGFloat = 0.0
    var initialY:CGFloat? //stores the initial y of the views franme, done like this for multi device
    let minY:CGFloat = 60.0 //change this if you want the menu to sit higher or lower when swiped up
    var lastFrameY:CGFloat = 0.0 //stores value of the prevoius' touch y value, used to determine wether going up or down
    var goingUp = true
    var bounceCount = 0//count to three and never bounce again!
    var delegate:BouncingMenuDelegate?
    
    override init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        if initialY==nil{ initialY=self.frame.origin.y}
        
        swipeIcon.image=UIImage(named: "swipeIcon")
        self.addSubview(swipeIcon)

        swipeDownIcon.image=UIImage(named: "swipeDownIcon")
        swipeDownIcon.alpha=0.0
        self.addSubview(swipeDownIcon)

        if NSUserDefaults.standardUserDefaults().objectForKey("bounces") != nil{
            bounceCount=NSUserDefaults.standardUserDefaults().objectForKey("bounces") as Int
        }
        
        bounceTimer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector:"bounce" , userInfo: nil, repeats: true)
        bounce()//call this once to avoid initial timer delay
    }
    
    func bounce(){
        if !inUse&&self.frame.origin.y==initialY&&bounceCount<3{
            UIView.animateWithDuration(0.15, delay: 1.0, options: .CurveEaseOut, animations: {
                self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y-10, self.frame.size.width, self.frame.size.height)
                }, completion: { finished in
                    
                    UIView.animateWithDuration(0.15, delay: 0.0, options: .CurveEaseIn, animations: {
                        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y+10, self.frame.size.width, self.frame.size.height)
                        }, completion: { finished in
                            
                            UIView.animateWithDuration(0.15, delay: 0.0, options: .CurveEaseOut, animations: {
                                self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y-10, self.frame.size.width, self.frame.size.height)
                                }, completion: { finished in
                                    
                                    UIView.animateWithDuration(0.15, delay: 0.0, options: .CurveEaseIn, animations: {
                                        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y+10, self.frame.size.width, self.frame.size.height)
                                        }, completion: { finished in
                                            self.bounceCount++
                                            if self.bounceCount == 3{
                                                NSUserDefaults.standardUserDefaults().setObject(self.bounceCount, forKey: "bounces")
                                                NSUserDefaults.standardUserDefaults().synchronize()
                                            }
                                    })
                                    
                            })
                            
                    })
                    
            })
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if initialY==nil{ initialY=self.frame.origin.y}
        inUse = true
        if var touch:UITouch = touches.anyObject() as? UITouch{
            touchOffset = touch.locationInView(self).y
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        if lastFrameY>self.frame.origin.y{
            goingUp=true
        }else{
            goingUp=false
        }
        
        lastFrameY = self.frame.origin.y
        
        if var touch:UITouch = touches.anyObject() as? UITouch{
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y+(touch.locationInView(self).y-touchOffset), self.frame.size.width, self.frame.size.height)
        }
        
        if self.frame.origin.y <= self.minY{//check the 'bounds' so that the menu cant go too high or low
            self.frame = CGRectMake(self.frame.origin.x, self.minY, self.frame.size.width, self.frame.size.height)
        }else if self.frame.origin.y >= self.initialY{
            self.frame = CGRectMake(self.frame.origin.x, initialY!, self.frame.size.width, self.frame.size.height)
        }
        swipeIcon.alpha=(self.frame.origin.y-self.minY*3.0)/(initialY!-self.minY*3.0)// no reason for 3.0, other then it just works well and makes it multi screen size
        swipeDownIcon.alpha=1.0-swipeIcon.alpha
        
        alphaChanged()
        
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        inUse = false
        touchOffset = 0.0
        
        //depending wether you were on your way up or down, check to see where you left it to see wether it needs to keep going or back to where you got it from, gives it moe of a swipe feel
        if (goingUp&&self.frame.origin.y>=initialY!-100)||(!goingUp&&self.frame.origin.y>=self.minY+100){
            UIView.animateWithDuration(0.15, delay: 0.0, options: .CurveEaseIn, animations: {
                self.frame=CGRectMake(self.frame.origin.x, self.initialY!, self.frame.size.width, self.frame.size.height)
                }, completion: { finished in
                    self.swipeIcon.alpha=1.0
                    self.swipeDownIcon.alpha=0.0
                    self.alphaChanged()
            })
        }else if (goingUp&&self.frame.origin.y<initialY!-100)||(!goingUp&&self.frame.origin.y<self.minY+100){
            UIView.animateWithDuration(0.15, delay: 0.0, options: .CurveEaseIn, animations: {
                self.frame=CGRectMake(self.frame.origin.x, self.minY, self.frame.size.width, self.frame.size.height)
                }, completion: { finished in
                    self.swipeIcon.alpha=0.0
                    self.swipeDownIcon.alpha=1.0
                    self.alphaChanged()
            })
        }
    }
    
    func alphaChanged(){
        if let currentDel = delegate?{
            currentDel.alphaValueChanged(self.swipeIcon.alpha)
        }
    }
}