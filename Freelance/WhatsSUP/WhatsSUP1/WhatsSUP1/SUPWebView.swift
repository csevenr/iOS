//
//  SUPWebView.swift
//  WhatsSUP1
//
//  Created by Tim Teece on 05/09/2014.
//  Copyright (c) 2014 Tim Teece. All rights reserved.
//

import Foundation
import UIKit

class SUPWebView: SUPRootController,UIWebViewDelegate{
    @IBOutlet var navItem  :UINavigationItem!
    @IBOutlet var webView  :UIWebView!

    var urlToShowString=""
    
    override func viewDidLoad() {
        webView!.delegate = self
        var  url=NSURL.URLWithString(urlToShowString)
        var request=NSURLRequest(URL: url)
        webView!.loadRequest(request)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        //self.title = "A title"

      self.title = webView.stringByEvaluatingJavaScriptFromString("document.title")
    }
}