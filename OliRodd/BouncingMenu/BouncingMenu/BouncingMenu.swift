//
//  BouncingMenu.swift
//  BouncingMenu
//
//  Created by Oli Rodden on 17/09/2014.
//  Copyright (c) 2014 OliRodd. All rights reserved.
//

import UIKit

class MenuView: UIView {
    let swipeUpLbl = UILabel(frame: CGRectMake(0.0, 10.0, 320.0, 30.0))
    let bounceTimer:NSTimer?
    var inUse = false //true when the label is held or "open", used to know wether to 'bounce or not'
    var touchOffset:CGFloat = 0.0
    var initialY:CGFloat? //stores the initial y of the views franme, done like this for multi device
    let minY:CGFloat = 60.0 //change this if you want the menu to sit higher or lower when swiped up
    var lastFrameY:CGFloat = 0.0 //stores value of the prevoius' touch y value, used to determine wether going up or down
    var goingUp = true
    var bounceCount = 0//count to three and never bounce again!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if initialY==nil{ initialY=self.frame.origin.y}
        
        swipeUpLbl.text="Swipe up for more!"
        swipeUpLbl.textAlignment=NSTextAlignment.Center
        swipeUpLbl.textColor=UIColor(red: 24.0/255.0, green: 116.0/255.0, blue: 155.0/255.0, alpha: 1.0)
        self.addSubview(swipeUpLbl)
        
        if NSUserDefaults.standardUserDefaults().objectForKey("bounces") != nil{
            bounceCount=NSUserDefaults.standardUserDefaults().objectForKey("bounces") as Int
        }
        
        bounceTimer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector:"bounce" , userInfo: nil, repeats: true)
        bounce()//call this once to avoid initial timer delay
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        swipeUpLbl.alpha=(self.frame.origin.y-self.minY*3.0)/(initialY!-self.minY*3.0)// no reason for 3.0, other then it just works well and makes it multi screen size
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        inUse = false
        touchOffset = 0.0
        
        //depending wether you were on your way up or down, check to see where you left it to see wether it needs to keep going or back to where you got it from, gives it moe of a swipe feel
        if (goingUp&&self.frame.origin.y>=initialY!-100)||(!goingUp&&self.frame.origin.y>=self.minY+100){
            UIView.animateWithDuration(0.15, delay: 0.0, options: .CurveEaseIn, animations: {
                self.frame=CGRectMake(self.frame.origin.x, self.initialY!, self.frame.size.width, self.frame.size.height)
                }, completion: { finished in
                    self.swipeUpLbl.alpha=1.0
            })
        }else if (goingUp&&self.frame.origin.y<initialY!-100)||(!goingUp&&self.frame.origin.y<self.minY+100){
            UIView.animateWithDuration(0.15, delay: 0.0, options: .CurveEaseIn, animations: {
                self.frame=CGRectMake(self.frame.origin.x, self.minY, self.frame.size.width, self.frame.size.height)
                }, completion: { finished in
                    self.swipeUpLbl.alpha=0.0
            })
        }
    }
}
