//
//  CheckOutPopUpVC.swift
//  UITextViewPlaceholder
//
//  Created by vibhuti gupta on 28/09/23.
//  Copyright © 2023 Maxim Bilan. All rights reserved.
//

import UIKit

class EarlyCheckOutPopUpVC: UIViewController {
    
    @IBOutlet var currentTimeLbl: UILabel!
    @IBOutlet var currentDateLbl: UILabel!
    @IBOutlet var commentsTextView: UITextView!
    @IBOutlet var hrManagerBtn: UIButton!
    @IBOutlet var projectManagerBtn: UIButton!
    @IBOutlet var NoneBtn: UIButton!
    @IBOutlet var submitBtn: UIButton!
    
    var indicatorView: UIActivityIndicatorView = UIActivityIndicatorView()

    
    var isHRManager = false
    var isProjectManager = false
    var isNone = false
    
    var viewModel: AttendanceViewModel?

    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.showAnimate()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
        
        viewModel = AttendanceViewModel()
        configureUI()
        
    }
        
    
    func showAnimate(){
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate(){
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
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
    
    @IBAction func submitBtnClick(_ sender: Any) {
        
        indicatorView.startAnimating()

        let token = GenericMethods.getToken()
        let attendenceDate = GenericMethods.getCurrentAttendanceDate()
        let checkOutNote = commentsTextView.text ?? ""
        let checkOutLat  = GenericMethods.getCheckOutLat()
        let checkOutLong = GenericMethods.getCheckOutLong()
        
        let approvedBy = ""

        
        let body = ["token": token,"attendence_date": attendenceDate,"checkout_note": checkOutNote, "checkout_let": checkOutLat,"checkout_long": checkOutLong, "approved_by":approvedBy] as [String : Any]
        
        self.viewModel?.fetchCheckOutData(body: body as [String : Any], completionHandler: { [weak self] (data , error) in
            if let dateModel = data, dateModel.status == true {
                DispatchQueue.main.async {
                    
                    NotificationCenter.default.post(name: Notification.Name("NotificationCheckOut"), object: nil)
                                        
                }
            }
            else{
                DispatchQueue.main.async {
                    self?.view.makeToast(data?.message)
                }
                
                
            }
            
            DispatchQueue.main.async {
               // NotificationCenter.default.post(name: Notification.Name("NotificationCheckOut"), object: nil)
                self?.indicatorView.stopAnimating()
               // self?.view.endEditing(true)
                //self?.dismiss(animated: true, completion: nil)
            }
            
        })
        
        
        
    }
        
    
    
    @objc func dismissMyKeyboard() {
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func configureUI() {
        
        hrManagerBtn.setImage(UIImage(systemName: "squareshape"), for: .normal)
        hrManagerBtn.tintColor = .black
        
        projectManagerBtn.setImage(UIImage(systemName: "squareshape"), for: .normal)
        projectManagerBtn.tintColor = .black
        
        NoneBtn.setImage(UIImage(systemName: "squareshape"), for: .normal)
        NoneBtn.tintColor = .black
        
        currentTimeLbl.text = GenericMethods.getCurrentTime()
        currentDateLbl.text = GenericMethods.getCheckInCheckOutCurrentDate()
        currentDateLbl.textColor = GenericColours.lightGrayColor
        
        
        commentsTextView.delegate = self
        commentsTextView.text = "Type your note here(Optional)"
        commentsTextView.textColor = UIColor.lightGray
        commentsTextView.selectedTextRange = commentsTextView.textRange(from: commentsTextView.beginningOfDocument, to: commentsTextView.beginningOfDocument)
        commentsTextView.layer.borderColor  = UIColor.lightGray.cgColor
        commentsTextView.layer.cornerRadius = 5
        commentsTextView.layer.borderWidth = 0.5
            
        
    }
    
    
    @IBAction func hrManagerBtnClick(_ sender: Any) {
       
        if isHRManager{
            hrManagerBtn.setImage(UIImage(systemName: "squareshape"), for: .normal)
            hrManagerBtn.tintColor  = .black
            
        } else{
            hrManagerBtn.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            hrManagerBtn.tintColor  = GenericColours.myCustomGreen
        }
        
        projectManagerBtn.setImage(UIImage(systemName: "squareshape"), for: .normal)
        projectManagerBtn.tintColor  = .black
        NoneBtn.setImage(UIImage(systemName: "squareshape"), for: .normal)
        NoneBtn.tintColor  = .black
        
        isHRManager = !isHRManager
        isProjectManager = false
        isNone = false
        
        
    }
    
    
    @IBAction func projectManagerBtnClick(_ sender: Any) {
       
        if isProjectManager{
            projectManagerBtn.setImage(UIImage(systemName: "squareshape"), for: .normal)
            projectManagerBtn.tintColor  = .black
            
        } else{
            projectManagerBtn.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            projectManagerBtn.tintColor  = GenericColours.myCustomGreen
        }
        
        hrManagerBtn.setImage(UIImage(systemName: "squareshape"), for: .normal)
        hrManagerBtn.tintColor  = .black
        NoneBtn.setImage(UIImage(systemName: "squareshape"), for: .normal)
        NoneBtn.tintColor  = .black
        
        isProjectManager = !isProjectManager
        
        
    }
    
    @IBAction func noneBtnClick(_ sender: Any) {
        
        if isNone{
            NoneBtn.setImage(UIImage(systemName: "squareshape"), for: .normal)
            NoneBtn.tintColor  = .black
            
        } else{
            NoneBtn.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            NoneBtn.tintColor  = GenericColours.myCustomGreen
        }
        
        hrManagerBtn.setImage(UIImage(systemName: "squareshape"), for: .normal)
        hrManagerBtn.tintColor  = .black
        projectManagerBtn.setImage(UIImage(systemName: "squareshape"), for: .normal)
        projectManagerBtn.tintColor  = .black
        
        isNone = !isNone
        
    }
    
    
   
    
        
    
}



extension EarlyCheckOutPopUpVC: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText: NSString = textView.text as NSString
        let updatedText = currentText.replacingCharacters(in: range, with:text)
        
        if textView.text.isEmpty{
            textView.text = "Type your note here(Optional)"
            textView.textColor = UIColor.lightGray
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            return false
        }
        
        else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        
        return true
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
    
    
    
    
    
}



