//
//  WebViewController.swift
//  Project16-1
//
//  Created by 박다미 on 2023/04/19.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    var website: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        guard website != nil else {
            navigationController?.popViewController(animated: true)
            return
        }
        if let url = URL(string: website){
            webView.load(URLRequest(url: url))
        }
        
    }
}
