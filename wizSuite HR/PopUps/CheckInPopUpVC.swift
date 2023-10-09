//
//  CheckInPopUpVC.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 29/09/23.
//

import UIKit

class CheckInPopUpVC: UIViewController {
    
    @IBOutlet var currentTimeLbl: UILabel!
    @IBOutlet var currentDateLbl: UILabel!
    @IBOutlet var commentsTextView: UITextView!
    @IBOutlet var checkInBtn: UIButton!
    var viewModel: AttendanceViewModel?
    var indicatorView: UIActivityIndicatorView = UIActivityIndicatorView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        configureUI()
        
        self.showAnimate()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
        
        viewModel = AttendanceViewModel()
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
    
    
    @objc func dismissMyKeyboard() {
       // view.endEditing(true)
      //  self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func configureUI(){
        
        self.view.layer.cornerRadius = 10
        
        
        commentsTextView.delegate = self
        commentsTextView.text = "Type your note here(Optional)"
        commentsTextView.textColor = .lightGray
        commentsTextView.selectedTextRange = commentsTextView.textRange(from: commentsTextView.beginningOfDocument, to: commentsTextView.beginningOfDocument)
        commentsTextView.layer.cornerRadius = 5
        commentsTextView.layer.borderWidth = 0.5
        commentsTextView.layer.borderColor  = UIColor.lightGray.cgColor
        
        
        checkInBtn.layer.cornerRadius = 6
        checkInBtn.backgroundColor = GenericColours.myCustomGreen
        checkInBtn.setTitleColor(.white, for: .normal)
        checkInBtn.setTitleColor(.white, for: .highlighted)
        checkInBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        
        currentTimeLbl.text = GenericMethods.getCurrentTime()
        currentDateLbl.text = GenericMethods.getCheckInCheckOutCurrentDate()
        currentDateLbl.textColor = GenericColours.lightGrayColor
        
        indicatorView = self.activityIndicator(style: .large,
                                               center: self.view.center)
        self.view.addSubview(indicatorView)
//        indicatorView.startAnimating()
        
        
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
    
    //A ->  B
    
    
    
    @IBAction func checkInButtonClick(_ sender: Any) {
        
        //(28.6254542, 77.3771865)
        indicatorView.startAnimating()
        
        let token = GenericMethods.getToken()
        let attendenceDate = GenericMethods.getCurrentAttendanceDate()
        let checkinNote = commentsTextView.text ?? ""
        let checkInLat  = GenericMethods.getCheckInLat()
        let checkInLong = GenericMethods.getCheckInLong()
        
        let body = ["token": token,"attendence_date": attendenceDate,"checkin_note": checkinNote,"checkin_let": checkInLat,"checkin_long": checkInLong] as [String : Any]
        
        self.viewModel?.fetchCheckInData(body: body as [String : Any], completionHandler: { [weak self] (data , error) in
            if let dateModel = data, dateModel.status == true {
                //                DispatchQueue.main.async {
                //                //change Text of Button
                NotificationCenter.default.post(name: Notification.Name("NotificationCheckIn"), object: nil)
                //
                //                }
            }
            else{
                
                DispatchQueue.main.async {
                    // self?.indicatorView.stopAnimating()
                    self?.view.makeToast(data?.message)
                }
                
            }
            
            DispatchQueue.main.async {
                self?.indicatorView.stopAnimating()
                
                //change Text of Button, Fire Notification
                //  NotificationCenter.default.post(name: Notification.Name("NotificationCheckIn"), object: nil)
                
            }
            
        })
        
        
        
        
    }
    
//    @IBAction func submitButtonClick(_ sender: Any) {
//        
//        
//        let token = "8d63cb14f784407aed43e49b04ebcd16"
//        //GenericMethods.getToken()
//        let attendenceDate = GenericMethods.getCurrentAttendanceDate()
//        let checkinNote = commentsTextView.text
//        let checkinLat  = "28.6254503"
//        let checkinLong = "77.377166"
//        
//        let body = ["token": token,"attendence_date": attendenceDate,"checkin_note": checkinNote,"checkin_let": checkinLat,"checkin_long": checkinLong]
//        
//        self.viewModel?.fetchCheckInData(body: body as [String : Any], completionHandler: { [weak self] (data , error) in
//            if let dateModel = data, dateModel.status == true {
//                DispatchQueue.main.async {
//                    
//                    
//                }
//            }
//            else{
//                
//            }
//            
//            
//            DispatchQueue.main.async {
//                self?.view.endEditing(true)
//                self?.dismiss(animated: true, completion: nil)
//            }
//            
//        })
//        
//        
//        
//        
//        
//    }
    
    
    
    
    
    
    
    
    
}


extension CheckInPopUpVC: UITextViewDelegate {
    
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
