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
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var sendOTPButtonBottomConstraint: NSLayoutConstraint!
    var indicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    var viewModel: OTPVerificationVM?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = .white

        
        viewModel = OTPVerificationVM()
        configureUI()
        
        indicatorView = self.activityIndicator(style: .large,
                                               center: self.view.center)
        self.view.addSubview(indicatorView)
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
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
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style:  .plain, target: self, action:  #selector(self.backAction(_:)))
        self.navigationItem.leftBarButtonItem?.tintColor = .black
        
    }
    
    @objc func backAction(_ sender: UIBarButtonItem? = nil) {
        print("Button click...")
        self.navigationController?.popViewController(animated: true)
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
    
    
    
//    @objc func keyboardWillShow(notification:NSNotification){
//        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
//        var userInfo = notification.userInfo!
//        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
//        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
//
//        var contentInset:UIEdgeInsets = self.scrollView.contentInset
//        contentInset.bottom = keyboardFrame.size.height
//        scrollView.contentInset = contentInset
//    }
//
//    @objc func keyboardWillHide(notification:NSNotification){
//        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
//        scrollView.contentInset = contentInset
//    }
    
    
    
   // @objc func keyboardWillShow(_ notification: NSNotification) {
//        // Move the view only when the usernameTextField or the passwordTextField are being edited
//        if emailAddress.isEditing  {
//            moveViewWithKeyboard(notification: notification, viewBottomConstraint: self.sendOTPButtonBottomConstraint, keyboardWillShow: true)
//        }
//    }
//
//    @objc func keyboardWillHide(_ notification: NSNotification) {
//        moveViewWithKeyboard(notification: notification, viewBottomConstraint: self.sendOTPButtonBottomConstraint, keyboardWillShow: false)
//    }
//
//    func moveViewWithKeyboard(notification: NSNotification, viewBottomConstraint: NSLayoutConstraint, keyboardWillShow: Bool) {
//        // Keyboard's size
//        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
//        let keyboardHeight = keyboardSize.height
//
//        // Keyboard's animation duration
//        let keyboardDuration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
//
//        // Keyboard's animation curve
//        let keyboardCurve = UIView.AnimationCurve(rawValue: notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! Int)!
//
//        // Change the constant
//        if keyboardWillShow {
//            let safeAreaExists = (self.view?.window?.safeAreaInsets.bottom != 0) // Check if safe area exists
//            let bottomConstant: CGFloat = 20
//            viewBottomConstraint.constant = keyboardHeight + (safeAreaExists ? 0 : bottomConstant)
//        }else {
//            viewBottomConstraint.constant = 20
//        }
//
//        // Animate the view the same way the keyboard animates
//        let animator = UIViewPropertyAnimator(duration: keyboardDuration, curve: keyboardCurve) { [weak self] in
//            // Update Constraints
//            self?.view.layoutIfNeeded()
//        }
//
//        // Perform the animation
//        animator.startAnimation()
//    }
//
    
    
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
        sendOTPButton.layer.cornerRadius = 6
        sendOTPButton.backgroundColor = GenericColours.myCustomGreen
        sendOTPButton.setTitleColor(.white, for: .normal)
        sendOTPButton.setTitle("SEND OTP", for: .normal)
        sendOTPButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        emailAddress.autocorrectionType = .no
        
    }
    
    
    func validateEmail()-> Bool{
        
        if let emailStr = emailAddress.text, emailStr.isEmpty  {
            self.view.makeToast("Please enter email address")
            return false
        }
        return true
    }
    
    @IBAction func sendOTPBtnClick(_ sender: Any) {
        
        
        guard let emailStr = emailAddress.text, !emailStr.isEmpty else {
            self.view.makeToast("Please enter email address")
            return
        }
        
        indicatorView.startAnimating()
        
        let bodyParams = ["email": emailAddress.text]
        
        viewModel?.sendOTPToEmail(body: bodyParams as [String : Any], completionHandler: { [weak self] (data , error) in
            
            if let data = data, data.status == true {
                //redirect to OTP Verify Screen
                
                DispatchQueue.main.async {
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "OTPVerificationVC") as? OTPVerificationVC
                    vc?.emailAddress = emailStr
                    self?.navigationController?.pushViewController(vc!, animated: true)
                }
                
            } else{
                DispatchQueue.main.async {
                    self?.view.makeToast(error?.localizedDescription)
                }
                
            }
            
            
            DispatchQueue.main.async {
                self?.indicatorView.stopAnimating()
            }
            
        })
        
        
        
    }
    
    
}
