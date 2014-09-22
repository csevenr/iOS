//
//  ViewController.swift
//  BouncingMenu
//
//  Created by Oli Rodden on 11/09/2014.
//  Copyright (c) 2014 OliRodd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor(red: 124.0/255.0, green: 217.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        
        let menuView = MenuView (frame: CGRectMake(self.view.frame.origin.x, self.view.frame.size.height-100.0, self.view.frame.size.width, self.view.frame.size.height))
        menuView.backgroundColor = UIColor(red: 124.0/255.0, green: 217.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        menuView.layer.shadowColor=UIColor.blackColor().CGColor
        menuView.layer.shadowOffset=CGSizeMake(0.0, -5.0)
        menuView.layer.shadowOpacity=0.5
        self.view.addSubview(menuView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}