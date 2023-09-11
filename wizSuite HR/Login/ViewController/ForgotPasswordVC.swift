//
//  ForgotPasswordVC.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 11/09/23.
//

import UIKit

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var sendOTPButton: UIButton!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureUI()

        // Do any additional setup after loading the view.
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    func configureUI(){
        
        sendOTPButton.layer.cornerRadius = 6
        sendOTPButton.backgroundColor = GenericColours.myCustomGreen
        sendOTPButton.titleLabel?.text = "SEND OTP"
        sendOTPButton.setTitleColor(.white, for: .normal)
        sendOTPButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)

        
    }
}
