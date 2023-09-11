//
//  LoginViewController.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 11/09/23.
//

import UIKit

class LoginViewVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    @IBOutlet weak var signInBtn: UIButton!
    var indicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    
   // var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        indicatorView = self.activityIndicator(style: .large,
                                                   center: self.view.center)
        self.view.addSubview(indicatorView)
        
        
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
    
    func configureUI(){
        
        forgotPasswordBtn.setTitleColor(.black, for: .normal)
        
        signInBtn.layer.cornerRadius = 6
        signInBtn.backgroundColor = GenericColours.myCustomGreen
        signInBtn.setTitleColor(.white, for: .normal)
        signInBtn.setTitle("SIGN IN", for: .normal)
        signInBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
    }
    
    
    @IBAction func forgotBtnClick(_ sender: Any) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ForgotPasswordVC") as? ForgotPasswordVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func signINBtnClick(_ sender: Any) {
        //calling API
        
        indicatorView.startAnimating()

        LoginViewModel.fetchLoginData()
        
        indicatorView.stopAnimating()

        
    }
    
    func showActivityIndicator(){
        
    }
    

}
