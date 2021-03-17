//
//  ViewController.swift
//  EasyBrower
//
//  Created by Egor Chernakov on 04.03.2021.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var progress: UIProgressView!
    let allowedSites = ["apple.com", "microsoft.com", "sony.com"]
    var initialSite: String!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        
        title = webView.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        progress = UIProgressView(progressViewStyle: .default)
        progress.sizeToFit()
        let progressView = UIBarButtonItem(customView: progress)
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let back  = UIBarButtonItem(barButtonSystemItem: .redo, target: self, action: #selector(goBack))
        let forward  = UIBarButtonItem(barButtonSystemItem: .fastForward, target: self, action: #selector(goForward))
        
        
        toolbarItems = [progressView, spacer, back, forward, spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        let url = URL(string: "https://" + allowedSites[0])!
        webView.allowsBackForwardNavigationGestures = true
        webView.load(URLRequest(url: url))
    }

    @objc func openTapped() {
        let ac = UIAlertController(title: "Open...", message: nil, preferredStyle: .actionSheet)
        
        for site in allowedSites {
            ac.addAction(UIAlertAction(title: site, style: .default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    func openPage(sender action: UIAlertAction) {
        let url = URL(string: "https://www." + action.title!)!
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        if let host = url?.host {
            for site in allowedSites {
                if host.contains(site) {
                    decisionHandler(.allow)
                    return
                }
            }
        }
        decisionHandler(.cancel)
    }
    
    @objc func goBack() {
        webView.goBack()
    }
    
    @objc func goForward() {
        webView.goForward()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progress.progress = Float(webView.estimatedProgress)
        }
    }
}

