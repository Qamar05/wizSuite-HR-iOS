//
//  LoginViewController.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 11/09/23.
//

import UIKit
import AuthenticationServices


class LoginViewVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var checkBoxIcon: UIButton!
    @IBOutlet weak var visibilityIcon: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    
    var indicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    var viewModel: LoginViewVM?
    var iconClick = false
    var rememberMeClick = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.view.backgroundColor = .white
                     
        viewModel = LoginViewVM()
        
        configureUI()
        
        indicatorView = self.activityIndicator(style: .large,
                                               center: self.view.center)
        self.view.addSubview(indicatorView)
        
        emailTextField.delegate = self                     //set delegate to textfile
        passwordTextField.delegate = self                  //set delegate to textfile
        emailTextField.autocorrectionType = .no
        passwordTextField.autocorrectionType = .no
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        //Add this tap gesture recognizer to the parent view
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
        
        //retrieveUserFromKeychain()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        //self.navigationController?.navigationBar.backgroundColor = .green
        
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        guard let keyboardFrameValue = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else {
            return
        }
        let keyboardFrame = view.convert(keyboardFrameValue.cgRectValue, from: nil)
        scrollView.contentOffset = CGPoint(x:0, y:keyboardFrame.size.height)
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        scrollView.contentOffset = .zero
    }
    
    private func activityIndicator(style: UIActivityIndicatorView.Style = .medium,
                                   frame: CGRect? = nil,
                                   center: CGPoint? = nil) -> UIActivityIndicatorView {
        
        let activityIndicatorView = UIActivityIndicatorView(style: style)
        if let frame = frame {
            activityIndicatorView.frame = frame
        }
        if let center = center {
            activityIndicatorView.center = center
        }
        return activityIndicatorView
    }
    
    func configureUI(){
        
        let image =  UIImage(systemName: "squareshape")
        checkBoxIcon.setImage(image, for: .normal)
        checkBoxIcon.tintColor = .black
        
        forgotPasswordBtn.setTitleColor(.black, for: .normal)
        
        visibilityIcon.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        passwordTextField.isSecureTextEntry = true
        
        signInBtn.layer.cornerRadius = 6
        signInBtn.backgroundColor = GenericColours.myCustomGreen
        signInBtn.setTitleColor(.white, for: .normal)
        signInBtn.setTitle("SIGN IN", for: .normal)
        signInBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
    }
    
    
    @IBAction func forgotBtnClick(_ sender: Any) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ForgotPasswordVC") as? ForgotPasswordVC
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        
    }
    
    
    @IBAction func rememberMeClick(_ sender: Any) {
        
        if rememberMeClick{
            checkBoxIcon.setImage(UIImage(systemName: "squareshape"), for: .normal)
            checkBoxIcon.tintColor  = .black
            
        } else{
            checkBoxIcon.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            checkBoxIcon.tintColor  = GenericColours.myCustomGreen
            
        }
        rememberMeClick = !rememberMeClick
        print("rememberMeClick***",rememberMeClick)
    }
    
    @IBAction func toggleVisibilityIcon(_ sender: Any) {
        
        if iconClick {
            
            passwordTextField.isSecureTextEntry = false
            visibilityIcon.setImage(UIImage(systemName: "eye"), for: .normal)
            
        } else {
            passwordTextField.isSecureTextEntry = true
            visibilityIcon.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        }
        iconClick = !iconClick
    }
    
    //Calling API on login and redirection to Main Page
    
    @IBAction func signINBtnClick(_ sender: Any) {
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let mainViewController = storyboard.instantiateViewController(identifier: "MainViewController")
//        self.navigationController?.pushViewController(mainViewController, animated: true)
//        return

//        
//        if (!validateUser()) {
//            return
//        }
//        
        indicatorView.startAnimating()
        
        let userName = emailTextField.text
        let password = passwordTextField.text
        let bodyParams = ["username": userName,"password": password]
        
        viewModel?.fetchLoginData(body: bodyParams as [String : Any], completionHandler: { [weak self] (data , error) in
            
            if let data = data, data.status == true {
                
                self?.viewModel?.saveData(loginData: data)
                
                
//                if self?.rememberMeClick == true{
//
//                    DispatchQueue.main.async {
//                        self?.savetoKeychain()
//                    }
//                }
                
                //Redirect to Main Page
                
                DispatchQueue.main.async {
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
                    self?.navigationController?.pushViewController(vc!, animated: true)
                    
                   // self?.view.window?.rootViewController = UINavigationController(rootViewController: vc!)
                    
                }
                
            } else{
                DispatchQueue.main.async {
                    self?.view.makeToast(data?.message)
                }
            }
            
            DispatchQueue.main.async {
                self?.indicatorView.stopAnimating()
            }
            
        })
        
    }
    
    
    
    func savetoKeychain(){
        
        
        guard let username = emailTextField.text,!username.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else { return print("Username field is empty") }
        guard let password = passwordTextField.text,!password.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else { return print("Password field is empty") }
        
        // Set attributes
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
            kSecValueData as String: password.data(using: .utf8)!,
        ]
        
        //
        //        guard let username = emailTextField.text else{
        //            return
        //        }
        //
        //        guard let password = passwordTextField.text?.data(using: .utf8)! else{
        //            return
        //        }
        
        // Set username and password
        
        // Set attributes
        //        let attributes: [String: Any] = [
        //            kSecClass as String: kSecClassGenericPassword,
        //            kSecAttrAccount as String: username,
        //            kSecValueData as String: password,
        //        ]
        
        // Add user
        if SecItemAdd(attributes as CFDictionary, nil) == noErr {
            print("User saved successfully in the keychain")
        } else {
            print("Something went wrong trying to save the user in the keychain")
        }
    }
    
    func retrieveUserFromKeychain(){
        
        guard let username = emailTextField.text,!username.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else { return print("Username field is empty") }
        
        
        // Set query
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true,
        ]
        var item: CFTypeRef?
        
        // Check if user exists in the keychain
        if SecItemCopyMatching(query as CFDictionary, &item) == noErr {
            //            resultsLabel.isHidden = true
            // Extract result
            if let existingItem = item as? [String: Any],
               let username = existingItem[kSecAttrAccount as String] as? String,
               let passwordData = existingItem[kSecValueData as String] as? Data,
               let password = String(data: passwordData, encoding: .utf8)
            {
                
                emailTextField.text = username
                passwordTextField.text = password
            }
        } else {
            //            resultsLabel.isHidden = false
            print("Something went wrong trying to find the user in the keychain")
        }
    }
    
    
    func validateUser() -> Bool {
        
        if let emailStr = emailTextField.text, emailStr.isEmpty, let passwordStr =  passwordTextField.text, emailStr.isEmpty, passwordStr.isEmpty {
            self.view.makeToast("Please enter email/mobile number")
            return false
        }
        
        else if let emailStr = emailTextField.text, emailStr.isEmpty  {
            self.view.makeToast("Please enter username")
            return false
            
        } else if let passwordStr =  passwordTextField.text, passwordStr.isEmpty {
            self.view.makeToast("Please enter password")
            return false
        }
        return true
        
    }
    
    func setRootViewController(_ vc: UIViewController, _ userId: Int? = nil) {
        
        guard let  window = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first else
        
        { return }
        
        
        
        window.rootViewController = vc
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        // adding animation
        //        UIView.transition(with: window,
        //                          duration: 0.8,
        //                          options: .tran,
        //                          animations: nil)
        // }
    }
    
    
    
    
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return .portrait
//    }
    
    
    
}



extension LoginViewVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //Check if there is any other text-field in the view whose tag is +1 greater than the current text-field on which the return key was pressed. If yes → then move the cursor to that next text-field. If No → Dismiss the keyboard
        
//        if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
//            nextField.becomeFirstResponder()
//        } else {
//            textField.resignFirstResponder()
//        }
        return false
    }
    
    
}

    


