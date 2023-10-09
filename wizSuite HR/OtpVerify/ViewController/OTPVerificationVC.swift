//
//  OTPVerificationVC.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 25/09/23.
//

import UIKit
import SVPinView


class OTPVerificationVC: UIViewController {

    @IBOutlet var pinView: SVPinView!
    @IBOutlet var verifyOTPBtn: UIButton!
    @IBOutlet var resendCodeTimerLabel: UILabel!
    @IBOutlet var resendCodeButton: UIButton!
    var resendCodeCounter = 30
    var resendCodeTimer = Timer()
    var indicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    var viewModel: OTPVerificationVM?
    var emailAddress: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = OTPVerificationVM()
        //        self.title = "SVPinView"
        configurePinView()
        configureUI()
        
       // resendCodeTimerLabel.text = ""
        sendOTPCode()
        
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
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // Setup background gradient
        let valenciaColor = UIColor(red: 218/255, green: 68/255, blue: 83/255, alpha: 1)
        let discoColor = UIColor(red: 137/255, green: 33/255, blue: 107/255, alpha: 1)
//        setGradientBackground(view: self.view, colorTop: valenciaColor, colorBottom: discoColor)
    }
    
    func configureUI(){
        
        resendCodeButton.isHidden = true
       // resendCodeTimerLabel.isHidden = false
        
//        resendCodeTimerLabel.text = "Didn't get code? We can resend it in"
//        resendCodeButton.setTitle("Resend", for: .no)

        verifyOTPBtn.layer.cornerRadius = 6
        verifyOTPBtn.backgroundColor = GenericColours.myCustomGreen
        verifyOTPBtn.setTitleColor(.white, for: .normal)
        verifyOTPBtn.setTitle("VERIFY", for: .normal)
        verifyOTPBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
    }
    
    func configurePinView() {
        
        pinView.pinLength = 5
        pinView.secureCharacter = "\u{25CF}"
        pinView.interSpace = 10
        pinView.textColor = UIColor.white
        pinView.borderLineColor = UIColor.black
        pinView.activeBorderLineColor = UIColor.white
        pinView.borderLineThickness = 1
        pinView.shouldSecureText = false
        pinView.allowsWhitespaces = false
        pinView.style = .none
        pinView.fieldBackgroundColor = UIColor.gray.withAlphaComponent(0.3) //UIColor.white.withAlphaComponent(0.3)
        pinView.activeFieldBackgroundColor = UIColor.gray.withAlphaComponent(0.5)
        pinView.fieldCornerRadius = 15
        pinView.activeFieldCornerRadius = 15
        pinView.placeholder = "******"
        pinView.deleteButtonAction = .deleteCurrentAndMoveToPrevious
        pinView.keyboardAppearance = .default
        pinView.tintColor = .white
        pinView.becomeFirstResponderAtIndex = 0
        pinView.shouldDismissKeyboardOnEmptyFirstField = false
        
        pinView.font = UIFont.boldSystemFont(ofSize: 17)
        pinView.keyboardType = .phonePad
        pinView.pinInputAccessoryView = { () -> UIView in
            let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
            doneToolbar.barStyle = UIBarStyle.default
            let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard))
            
            var items = [UIBarButtonItem]()
            items.append(flexSpace)
            items.append(done)
            
            doneToolbar.items = items
            doneToolbar.sizeToFit()
            return doneToolbar
        }()
        
        pinView.didFinishCallback = didFinishEnteringPin(pin:)
        pinView.didChangeCallback = { pin in
            print("The entered pin is \(pin)")
        }
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
    
    
    func didFinishEnteringPin(pin:String) {
        //showAlert(title: "Success", message: "The Pin entered is \(pin)")
    }
    
    
    @objc func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
    
    func setGradientBackground(view:UIView, colorTop:UIColor, colorBottom:UIColor) {
        for layer in view.layer.sublayers! {
            if layer.name == "gradientLayer" {
                layer.removeFromSuperlayer()
            }
        }
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop.cgColor, colorBottom.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.bounds
        gradientLayer.name = "gradientLayer"
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // in case user closed the controller
      deinit {
        resendCodeTimer.invalidate()
      }
    
    
    @objc func updateTimerLabel() {
        resendCodeCounter -= 1
        resendCodeTimerLabel.text = "Resend code in \(resendCodeCounter) seconds."
        if resendCodeCounter == 0 {
            
            resendCodeTimerLabel.isHidden = true
            resendCodeButton.isHidden = false
            resendCodeButton.isEnabled = true
            resendCodeTimer.invalidate()
        } else{
            resendCodeTimerLabel.isHidden = false
            
        }
    }
    
    
    @IBAction func resendAgainButtonClicked(_ sender: Any) {
        
        //OTPTextField.text = ""
        resendCodeCounter = 31
        resendCodeButton.isHidden = true
        resendCodeButton.isEnabled = false

        sendOTPCode()
        
        let bodyParams = ["email": emailAddress]
        viewModel?.sendOTPToEmail(body: bodyParams as [String : Any], completionHandler: { [weak self] (data , error) in
            if let data = data, data.status == true {
                
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
    
    func sendOTPCode() {
        //Whatever your api logic
      //  if otpSent {
            self.resendCodeTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimerLabel), userInfo: nil, repeats: true)
        //}
    }
    
    
    
    @IBAction func verifyOTPBtnClick(_ sender: Any) {
    
        if (validateOTP() == false) {
            return
        }
        
        indicatorView.startAnimating()
                
        let bodyParams = ["email": emailAddress, "otp": pinView.getPin()]
        
        viewModel?.verifyOTPData(body: bodyParams as [String : Any], completionHandler: { [weak self] (data , error) in
            
            if let data = data, data.status == true {
                
                DispatchQueue.main.async {
                    //ChangePasswordVC
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChangePasswordVC") as? ChangePasswordVC
                    vc?.isFromOnboarding = true
                    self?.navigationController?.pushViewController(vc!, animated: true)
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
    
    func validateOTP() -> Bool {
        
        if pinView.getPin().isEmpty {
            self.view.makeToast("Please enter 5 digit OTP")
            return false
        }
        
        return true
        
    }
    
}
