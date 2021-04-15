//
//  WikiViewController.swift
//  CapitalCities
//
//  Created by Egor Chernakov on 01.04.2021.
//

import UIKit
import WebKit

class WikiViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var name: String!
    var progressView: UIProgressView!
    
    let pages = [
        "London": "https://en.wikipedia.org/wiki/London",
        "Oslo": "https://en.wikipedia.org/wiki/Oslo",
        "Paris": "https://en.wikipedia.org/wiki/Paris",
        "Rome": "https://en.wikipedia.org/wiki/Rome",
        "Washington DC": "https://en.wikipedia.org/wiki/Washington,_D.C."
    ]
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        openWiki(for: name)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressItem = UIBarButtonItem(customView: progressView)
        
        toolbarItems = [progressItem]
        navigationController?.isToolbarHidden = false
        //navigationController?.toolbar.transform = CGAffineTransform(translationX: 0, y: 50)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    
    
    func openWiki(for city: String) {
        guard let cityURL = pages[city] else { return }
        guard let url = URL(string: cityURL) else { return }
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        if let host = url?.host {
            if host.contains("wiki") {
                decisionHandler(.allow)
                return
            }
        }
        decisionHandler(.cancel)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: []) {
            self.navigationController?.toolbar.transform = .identity
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: []) {
            self.navigationController?.toolbar.transform = CGAffineTransform(translationX: 0, y: 50)
        }
    }
    
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
}
