//
//  ChangePasswordVC.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 11/09/23.
//

import UIKit


class ChangePasswordVC: UIViewController {
    
    @IBOutlet var sideMenuBtn: UIBarButtonItem!
    @IBOutlet var changePwTextView: UITextField!
    @IBOutlet var confirmPwTextView: UITextField!
    @IBOutlet var visibilityIconChangePw: UIButton!
    @IBOutlet var visibilityIconConfirmPw: UIButton!
    @IBOutlet var changePwBtn: UIButton!
    @IBOutlet var notificationBtn: UIBarButtonItem!
    @IBOutlet var scrollView: UIScrollView!
    
    var viewModel: ChangePasswordVM?
    var indicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    var visibilityIconChangePwClick = false
    var visibilityIconConfirmPwClick = false
    
    var isFromOnboarding: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        
        viewModel = ChangePasswordVM()
        configureUI()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
        
        
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(self.keyboardWillShow),
//            name: UIResponder.keyboardWillShowNotification,
//            object: nil)
//        
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(self.keyboardWillHide),
//            name: UIResponder.keyboardWillHideNotification,
//            object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        if isFromOnboarding{
            self.title = ""
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style:  .plain, target: self, action:  #selector(self.backAction(_:)))
            self.navigationItem.leftBarButtonItem?.tintColor = .black
            sideMenuBtn.isHidden = true
            notificationBtn.isHidden  = true
        } else{
            sideMenuBtn.isHidden = false
            notificationBtn.isHidden  = false
        }
      
        
    }
    
    @objc func backAction(_ sender: UIBarButtonItem? = nil) {
        print("Button click...")
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func configureUI(){
        
        self.view.backgroundColor = .white
        
        changePwTextView.delegate = self
        confirmPwTextView.delegate = self
        
        changePwBtn.layer.cornerRadius = 6
        changePwBtn.backgroundColor = GenericColours.myCustomGreen
        changePwBtn.setTitleColor(.white, for: .normal)
        changePwBtn.setTitle("CHANGE PASSWORD", for: .normal)
        changePwBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        visibilityIconChangePw.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        visibilityIconConfirmPw.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        
        changePwTextView.isSecureTextEntry = true
        confirmPwTextView.isSecureTextEntry = true
        
        
        indicatorView = self.activityIndicator(style: .large,
                                               center: self.view.center)
        self.view.addSubview(indicatorView)
        
        
        sideMenuBtn.target = self.revealViewController()
        sideMenuBtn.action = #selector(self.revealViewController()?.revealSideMenu)
        
        
        
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
    
//    @objc func keyboardWillShow(notification:NSNotification) {
//        guard let keyboardFrameValue = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else {
//            return
//        }
//        let keyboardFrame = view.convert(keyboardFrameValue.cgRectValue, from: nil)
//        scrollView.contentOffset = CGPoint(x:0, y:keyboardFrame.size.height)
//    }
//
//    @objc func keyboardWillHide(notification:NSNotification) {
//        scrollView.contentOffset = .zero
//    }
    
    
    @IBAction func notificationTapped(_ sender: Any) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NotificationVC") as? NotificationVC
        self.navigationController?.pushViewController(vc!, animated: true)
        
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
    
    
    func validateUser() -> Bool{
        
        if let changePwStr = changePwTextView.text, changePwStr.isEmpty{
            self.view.makeToast("Please enter new Password of at least 6 characters")
            return false
        }
        
        else if let pwCount = changePwTextView.text?.count , pwCount <  6 {
            self.view.makeToast("Please enter new Password of at least 6 characters")
            return false
        }
        
        else if let confirmPwStr =  confirmPwTextView.text, confirmPwStr.isEmpty {
            self.view.makeToast("Please enter new Password of at least 6 characters")
            return false
        }
        
        else if let confirmPwCount = confirmPwTextView.text?.count , confirmPwCount <  6 {
            self.view.makeToast("Please enter new Password of at least 6 characters")
            return false
        }
        
        else if changePwTextView.text != confirmPwTextView.text{
            self.view.makeToast("Password and Confirm Password doesnot match")
            return false
        }
        
        return true
        
    }
    
    
    
    @IBAction func changePwClick(_ sender: Any) {
        
            
        if !validateUser() {
            return
        }
        
        guard let password = confirmPwTextView.text,  !password.isEmpty else{
            return
        }

        
        self.indicatorView.startAnimating()
        
        let token = GenericMethods.getToken()
        let bodyParams = ["token": token,"new_password": password] as [String : Any]
        
        viewModel?.fetchChangePwData(body: bodyParams, completionHandler: { [weak self] (data , error) in
            
            if let data = data, data.status == true {
                
                DispatchQueue.main.async {
                    
                    //moving to login screen
                    
                    self?.navigationController?.popToRootViewController(animated: true)
                    
                    self?.view.makeToast(data.message)
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
    
    
    @IBAction func toggleVisibilityChangePwClick(_ sender: Any) {
        
        if visibilityIconChangePwClick {
            
            changePwTextView.isSecureTextEntry = false
            visibilityIconChangePw.setImage(UIImage(systemName: "eye"), for: .normal)
            
        } else {
            changePwTextView.isSecureTextEntry = true
            visibilityIconChangePw.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        }
        visibilityIconChangePwClick = !visibilityIconChangePwClick
        
    }
    
    @IBAction func toggleVisibilityConfirmPwClick(_ sender: Any) {
        
        if visibilityIconConfirmPwClick {
            
            confirmPwTextView.isSecureTextEntry = false
            visibilityIconConfirmPw.setImage(UIImage(systemName: "eye"), for: .normal)
            
        } else {
            confirmPwTextView.isSecureTextEntry = true
            visibilityIconConfirmPw.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        }
        visibilityIconConfirmPwClick = !visibilityIconConfirmPwClick
        
    }
    
}


extension ChangePasswordVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // get the current text, or use an empty string if that failed
        
        let currentText = textField.text ?? ""
        
        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        //return updatedText.count
        
        return true

        // make sure the result is under 16 characters
       // return updatedText.count <= 6
        
    }
    
}
