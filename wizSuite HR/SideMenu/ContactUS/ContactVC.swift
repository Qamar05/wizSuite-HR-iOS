//
//  ContactVC.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 20/09/23.
//

import UIKit


class ContactVC: UIViewController{
    
    @IBOutlet var contactusView: UIView!
    @IBOutlet var sideMenuBtn: UIBarButtonItem!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .white

        
        contactusView.layer.borderColor = UIColor.black.cgColor
        contactusView.layer.borderWidth = 0.5
        contactusView.layer.cornerRadius = 5
        

        sideMenuBtn.target = self.revealViewController()
        sideMenuBtn.action = #selector(self.revealViewController()?.revealSideMenu)
        
    }
    
    
    @IBAction func notificationTapped(_ sender: Any) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NotificationVC") as? NotificationVC
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
}

