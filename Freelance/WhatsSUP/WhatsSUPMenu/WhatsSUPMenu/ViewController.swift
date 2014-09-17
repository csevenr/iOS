//
//  ViewController.swift
//  WhatsSUPMenu
//
//  Created by Oli Rodden on 12/09/2014.
//  Copyright (c) 2014 OliRodd. All rights reserved.
//

import UIKit

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor(red: 124.0/255.0, green: 217.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        
        let menuView = MenuView (frame: CGRectMake(self.view.frame.origin.x, self.view.frame.size.height-50.0, self.view.frame.size.width, self.view.frame.size.height))
        menuView.backgroundColor = UIColor(red: 124.0/255.0, green: 217.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        menuView.layer.shadowColor=UIColor.blackColor().CGColor
        menuView.layer.shadowOffset=CGSizeMake(0.0, -2.0)
        menuView.layer.shadowOpacity=0.5
        self.view.addSubview(menuView)
        
        let customFont = UIFont(name: "PoetsenOne-Regular", size: 40.0)
        
        let titleLbl = UILabel (frame: CGRectMake(0.0, 30.0, 320.0, 40.0))
        titleLbl.text="What's SUP"
        titleLbl.textAlignment=NSTextAlignment.Center
        titleLbl.textColor=UIColor(red: 189.0/255.0, green: 236.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        titleLbl.font=customFont
        self.view.addSubview(titleLbl)
        
        let customFont2 = UIFont(name: "PoetsenOne-Regular", size: 24.0)
        
        let supRunsLbl = UILabel (frame: CGRectMake(20.0, 120.0, 280.0, 24.0))
        supRunsLbl.text="SUP runs: 32"
        supRunsLbl.textColor=UIColor(red: 189.0/255.0, green: 236.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        supRunsLbl.font=customFont2
        self.view.addSubview(supRunsLbl)

        let totDistLbl = UILabel (frame: CGRectMake(20.0, 154.0, 280.0, 24.0))
        totDistLbl.text="Total Distance: 245.67km"
        totDistLbl.textColor=UIColor(red: 189.0/255.0, green: 236.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        totDistLbl.font=customFont2
        self.view.addSubview(totDistLbl)

        let lastSupLbl = UILabel (frame: CGRectMake(20.0, 188.0, 280.0, 24.0))
        lastSupLbl.text="Last SUP: 12/09/14"
        lastSupLbl.textColor=UIColor(red: 189.0/255.0, green: 236.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        lastSupLbl.font=customFont2
        self.view.addSubview(lastSupLbl)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

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
        
        let menuImg = UIImageView(frame: CGRectMake(0.0, -55.0, 320.0, 55.0))
        menuImg.image=UIImage(named: "menuWaves")
        self.addSubview(menuImg)
        
        let custom = UIFont(name: "PoetsenOne-Regular", size: 18.0)
        
        swipeUpLbl.text="Swipe up for more!"
        swipeUpLbl.textAlignment=NSTextAlignment.Center
        swipeUpLbl.textColor=UIColor(red: 24.0/255.0, green: 116.0/255.0, blue: 155.0/255.0, alpha: 1.0)
        swipeUpLbl.font=custom
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
                                            if self.bounceCount++ == 3{
                                                println("3 times")
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


