//
//  ViewController.swift
//  Project4
//
//  Created by 박다미 on 2023/01/27.
//

import UIKit
import WebKit


class ViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(opendTapped))
        
        
        let url = URL(string: "https://www.hackingwithswift.com")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        // Do any additional setup after loading the view.
    }
    @objc func opendTapped(){
        let ac = UIAlertController(title: "Opend page...", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "apple.com", style: .default,handler: openPage))
        ac.addAction(UIAlertAction(title: "hackingwithswift.com", style: .default, handler: openPage))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
        }
    func openPage(action:UIAlertAction){
        guard let actionTitle = action.title else{return}
        guard let url = URL(string: "https://" + actionTitle)else { return }
        webView.load(URLRequest(url:url))
    }

       func webViewwebView (_ webView: WKWebView, didFinish navigation: WKNavigation!){
        title = webView.title
    }
}

