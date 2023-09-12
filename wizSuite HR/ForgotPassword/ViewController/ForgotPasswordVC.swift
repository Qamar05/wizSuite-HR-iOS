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
    var indicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    var viewModel: ForgotPasswordVM?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ForgotPasswordVM()
        configureUI()

        indicatorView = self.activityIndicator(style: .large,
                                                   center: self.view.center)
        self.view.addSubview(indicatorView)
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
         target: self,
         action: #selector(dismissMyKeyboard))
         //Add this tap gesture recognizer to the parent view
         view.addGestureRecognizer(tap)
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
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
    
    private func activityIndicator(style: UIActivityIndicatorView.Style = .medium,
                                       frame: CGRect? = nil,
                                   center: CGPoint? = nil) -> UIActivityIndicatorView {
        
        // 2
        let activityIndicatorView = UIActivityIndicatorView(style: style)
        
        // 3
        if let frame = frame {
            activityIndicatorView.frame = frame
        }
        
        // 4
        if let center = center {
            activityIndicatorView.center = center
        }
        
        // 5
        return activityIndicatorView
    }
    
    
    @IBAction func sendOTPBtnClick(_ sender: Any) {
        
        indicatorView.startAnimating()
        
        viewModel?.fetchForgotPwData( completionHandler: { [weak self] (data , error) in

            if let data = data, data.status == true {
                
                //redirect to OTP Verify Screen
                
            } else{
                self?.view.makeToast(error?.localizedDescription)
                
            }
            
            
            DispatchQueue.main.async {
                self?.indicatorView.stopAnimating()
            }
            
        })
        
        
        
        
        
        
    }
    
    
}
