//
//  WebViewController.swift
//  walkerTracker
//
//  Created by user144566 on 11/18/18.
//  Copyright © 2018 user144566. All rights reserved.
//

import UIKit
import WebKit
import Material

class WebViewController: UIViewController {

    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.grey.lighten2
        self.webView = WKWebView()
        self.view = self.webView!
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let url = URL(string:"https://www.walgreens.com/")
        let req = URLRequest(url:url!)
        self.webView!.load(req)
        
    }

}
