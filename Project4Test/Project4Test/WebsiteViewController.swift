//
//  WebsiteViewController.swift
//  Project4Test
//
//  Created by 박다미 on 2023/01/29.
//

import UIKit
import WebKit

class WebsiteViewController: UIViewController, WKNavigationDelegate {

    //테이블뷰의 [index.row] = 배열 row
    
    var webView: WKWebView!
    var progressView: UIProgressView!
    
    var websites: [String]! //    var websites = ["apple.com", "hackingwithswift.com"] 앞에서 didSelect func에서 보냄
    var currentWebsite: Int!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://" + websites[currentWebsite])!
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
        
    }
    


}
