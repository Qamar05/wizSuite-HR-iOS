//
//  TermsAndConditionVC.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 21/09/23.
//

import UIKit
import WebKit

class TermsAndConditionVC: UIViewController, WKNavigationDelegate {

    @IBOutlet var webView: WKWebView!
    @IBOutlet var sideMenuBtn: UIBarButtonItem!
   
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .white
        
        sideMenuBtn.target = revealViewController()
        sideMenuBtn.action = #selector(revealViewController()?.revealSideMenu)
        
        
        let url = URL(string: "https://fmcg.xaapps.com/term/term_and_condition.html")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
        
    }
    

    @IBAction func notificationTapped(_ sender: Any) {
       
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NotificationVC") as? NotificationVC
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
}
