//
//  AttendenceRegularizationViewController.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 08/09/23.
//

import UIKit

class AttendenceRegularizationVC: UIViewController {

    @IBOutlet var submitBtn: UIButton!
    @IBOutlet var commentsTextView: UITextView!
    @IBOutlet var forgotCheckInBtn: UIButton!
    @IBOutlet var forgotCheckOutBtn: UIButton!
    @IBOutlet var forgotBothBtn: UIButton!
    @IBOutlet var selectDateField: UITextField!
    @IBOutlet var checkInField: UITextField!
    @IBOutlet var checkOutField: UITextField!
    @IBOutlet var noteLbl: UILabel!
    @IBOutlet var commentsLbl: UILabel!
    
    var isforgotCheckIn = false
    var isforgotCheckOut = false
    var isforgotBoth = false
    var forgot_type : String = ""

    
    var indicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    var viewModel: AttendenceRegularizationVM?
    var pickerToolbar: UIToolbar?
    var datePicker :UIDatePicker!
    var timePicker :UIDatePicker!

    
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        return formatter
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = AttendenceRegularizationVM()
        
        configureUI()
        createUIToolBar()
        
        
        datePicker = UIDatePicker.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 200))
        timePicker = UIDatePicker.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 200))
        
        
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.sizeToFit()
            self.datePicker.maximumDate = Date()
            
            timePicker.preferredDatePickerStyle = .wheels
            timePicker.sizeToFit()
        }
        
        datePicker.datePickerMode = .date
        
        selectDateField.inputView = datePicker
        selectDateField?.inputAccessoryView = pickerToolbar
        
        timePicker.datePickerMode = .time
        
        checkInField.inputView = timePicker
        checkInField?.inputAccessoryView = pickerToolbar
        
        checkOutField.inputView = timePicker
        checkOutField?.inputAccessoryView = pickerToolbar
        
        
        let viewTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(viewTap)
        
        
        let commentsAttriburedString = NSMutableAttributedString(string: "Comments")
        let asterix = NSAttributedString(string: " *", attributes: [.foregroundColor: UIColor.red])
        commentsAttriburedString.append(asterix)
        
        
        commentsLbl.attributedText = commentsAttriburedString
        
        self.fetchDaysCount()
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Attendance Regularization"
        
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 17)
        ]
        
        let image = UIImage(systemName: "chevron.backward")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style:  .plain, target: self, action:  #selector(self.backAction(_:)))
        self.navigationItem.leftBarButtonItem?.tintColor = .white
        
    }
    
    
    @objc func backAction(_ sender: UIBarButtonItem? = nil) {
        print("Button click...")
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func configureUI(){
        
        forgotCheckInBtn.setImage(UIImage(systemName: "squareshape"), for: .normal)
        forgotCheckInBtn.tintColor = .black
        
        forgotCheckOutBtn.setImage(UIImage(systemName: "squareshape"), for: .normal)
        forgotCheckOutBtn.tintColor = .black
        
        forgotBothBtn.setImage(UIImage(systemName: "squareshape"), for: .normal)
        forgotBothBtn.tintColor = .black
                
        submitBtn.layer.cornerRadius = 6
        submitBtn.backgroundColor = GenericColours.myCustomGreen
        submitBtn.setTitleColor(.white, for: .normal)
        submitBtn.setTitle("SUBMIT", for: .normal)
        submitBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        commentsTextView.delegate = self
        commentsTextView.text = "Comments"
        commentsTextView.textColor = .lightGray
        commentsTextView.layer.cornerRadius = 5
        commentsTextView.layer.borderWidth = 0.5
        commentsTextView.layer.borderColor  = UIColor.lightGray.cgColor
    
        checkInField.isHidden = true
        checkOutField.isHidden = true
        selectDateField.isHidden = true
        
        indicatorView = self.activityIndicator(style: .large,
                                               center: self.view.center)
        self.view.addSubview(indicatorView)
        
    }
    
    
    func fetchDaysCount(){
        
        viewModel?.fetchDayCount(completionHandler: { [weak self] (data , error) in
            
            if let data = data , data.status == true {
            
                if data.regulationCount == "0"{
                    DispatchQueue.main.async {
                        self?.noteLbl.text = "Note:- You can apply maximum 30 times in a month.You haven't used this option in this month."
                    }
                } else{
                    DispatchQueue.main.async {
                        self?.noteLbl.text = "Note:- You can apply maximum 30 times in a month.You already have applied "  + data.regulationCount + " times in this month."
                    }
                }
              
            }
            DispatchQueue.main.async {
                self?.indicatorView.stopAnimating()
            }
        })
                                 
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
    
    
    @IBAction func forgotCheckInBtnClick(_ sender: Any) {
       
        checkOutField.isHidden = true
        
        forgot_type = "Forgot In"
        
        forgotCheckOutBtn.setImage(UIImage(systemName: "squareshape"), for: .normal)
        forgotBothBtn.setImage(UIImage(systemName: "squareshape"), for: .normal)
        forgotCheckOutBtn.tintColor  = .black
        forgotBothBtn.tintColor  = .black
        
        if isforgotCheckIn{
            forgotCheckInBtn.setImage(UIImage(systemName: "squareshape"), for: .normal)
            forgotCheckInBtn.tintColor  = .black
            selectDateField.isHidden = true
            checkInField.isHidden = true
            
        } else{
            forgotCheckInBtn.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            forgotCheckInBtn.tintColor  = GenericColours.myCustomGreen
            selectDateField.isHidden = false
            checkInField.isHidden = false
            
        }
        isforgotCheckIn = !isforgotCheckIn
        isforgotCheckOut = false
        isforgotBoth = false
                
      
    }
    
    
    @IBAction func forgotCheckOutBtnClick(_ sender: Any) {
        
        checkInField.isHidden = true
        
        forgot_type = "Forgot Out"

        
        if isforgotCheckOut{
            forgotCheckOutBtn.setImage(UIImage(systemName: "squareshape"), for: .normal)
            forgotCheckOutBtn.tintColor  = .black
            selectDateField.isHidden = true
            checkOutField.isHidden = true
            
        } else{
            forgotCheckOutBtn.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            forgotCheckOutBtn.tintColor  = GenericColours.myCustomGreen
            selectDateField.isHidden = false
            checkOutField.isHidden = false
            
        }
        isforgotCheckOut = !isforgotCheckOut
        
        forgotCheckInBtn.setImage(UIImage(systemName: "squareshape"), for: .normal)
        forgotBothBtn.setImage(UIImage(systemName: "squareshape"), for: .normal)
        forgotCheckInBtn.tintColor  = .black
        forgotBothBtn.tintColor  = .black
        isforgotCheckIn = false
        isforgotBoth = false

     
    }
    
    
    @IBAction func forgotBothButton(_ sender: Any) {
        
        forgot_type = "Both"

        
        if isforgotBoth{
            forgotBothBtn.setImage(UIImage(systemName: "squareshape"), for: .normal)
            forgotBothBtn.tintColor  = .black
            selectDateField.isHidden = true
            checkInField.isHidden = true
            checkOutField.isHidden = true
            
            
        } else{
            forgotBothBtn.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            forgotBothBtn.tintColor  = GenericColours.myCustomGreen
            selectDateField.isHidden = false
            checkInField.isHidden = false
            checkOutField.isHidden = false
        }
        isforgotBoth = !isforgotBoth
        
        forgotCheckInBtn.setImage(UIImage(systemName: "squareshape"), for: .normal)
        forgotCheckOutBtn.setImage(UIImage(systemName: "squareshape"), for: .normal)
        forgotCheckInBtn.tintColor  = .black
        forgotCheckOutBtn.tintColor  = .black
        
        isforgotCheckIn = false
        isforgotCheckOut = false
                
    }
    
    
    
    @IBAction func submitButtonClick(_ sender: Any) {
        
        if forgot_type.isEmpty {
            self.view.makeToast("Select Data Entry")
            return
        }
        
        guard let text = selectDateField.text, !text.isEmpty else {
            self.view.makeToast("Select Date")
            return
        }
        
        
        if forgot_type == "Forgot In" {
            guard let text = checkInField.text, !text.isEmpty else {
                self.view.makeToast("Select Check in Time")
                return
            }
        } else if forgot_type == "Forgot Out"{
            guard let text = checkOutField.text, !text.isEmpty else {
                self.view.makeToast("Select Check Out Time")
                return
            }
        } else if forgot_type == "Both"{
            
            guard let text = checkInField.text, !text.isEmpty else {
                self.view.makeToast("Select Check in Time")
                return
            }
            
            guard let text = checkOutField.text, !text.isEmpty else {
                self.view.makeToast("Select Check Out Time")
                return
            }
        }
       
        if commentsTextView.text.count <=  10 {
            self.view.makeToast("Enter Comments")
            return
        }
        
        
        let token  = GenericMethods.getToken()
        let forgot_type = forgot_type
        print("FORGOT TYPE*****",forgot_type)
        let forgot_comments = commentsTextView.text
        let forgot_in_date = selectDateField.text
        let forgot_out_date = selectDateField.text
      
        
        
//        Forgot In
//        Forgot Out
//        Both
//        
        
        var forgot_check_in_time = ""
        var forgot_check_out_time = ""
        var forgot_both = ""
        
      
        
        if forgot_type == "Forgot In"{
            forgot_check_in_time = timeConversion24(time12: checkInField.text ?? "")
        }
        else if forgot_type == "Forgot Out"{
            forgot_check_out_time = timeConversion24(time12: checkOutField.text ?? "")
        }
        else if forgot_type == "Both"{
            forgot_check_in_time = timeConversion24(time12: checkInField.text ?? "")
            forgot_check_out_time = timeConversion24(time12: checkOutField.text ?? "")
            
        } else{
            
        }
        
     
        
        let body = ["token": token,"forgot_type": forgot_type,"forgot_comments":forgot_comments,"forgot_out_date":forgot_out_date,"forgot_in_date":forgot_in_date, "forgot_check_in_time":forgot_check_in_time,"forgot_check_out_time":forgot_check_out_time]
        
        
        
        //  let body = ["token": "1583cce1f7928a3ebedd1e0c98e515cb","forgot_type": "Both","forgot_comments":"Kapil Marriage","forgot_out_date":"2023-06-11","forgot_in_date":"2023-06-11", "forgot_check_in_time":"9:44","forgot_check_out_time":"19:30"]
        
        
        indicatorView.startAnimating()
        
        viewModel?.fetchAttendenceRegularizationData(body: body as [String : Any] ,completionHandler: { [weak self] (data , error) in
            if let data = data, data.status == true {
                DispatchQueue.main.async {
                    self?.view.makeToast(data.message)
                    self?.navigationController?.popViewController(animated: true)
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
    
    
    func timeConversion24(time12: String) -> String {
        let dateAsString = time12
        let df = DateFormatter()
        df.dateFormat = "hh:mm:ssa"
        
        let date = df.date(from: dateAsString)
        df.dateFormat = "HH:mm:ss"
        
        let time24 = df.string(from: date ?? Date())
        print(time24)
        return time24
    }
    
    
    func validateCommentsFields() -> Bool{
        
        if(commentsTextView.text.count ==  0) {
            self.view.makeToast("Enter Comments")
            return false
        }
        return true
        
    }
    
    func createUIToolBar() {
        
        pickerToolbar = UIToolbar()
        pickerToolbar?.autoresizingMask = .flexibleHeight
        
        //customize the toolbar
        pickerToolbar?.barStyle = .default
        pickerToolbar?.barTintColor = UIColor.black
        pickerToolbar?.backgroundColor = UIColor.white
        pickerToolbar?.isTranslucent = false
        
        //add buttons
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action:
                                            #selector(cancelBtnClicked(_:)))
        cancelButton.tintColor = UIColor.white
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action:
                                            #selector(doneBtnClicked(_:)))
        doneButton.tintColor = UIColor.white
        
        //add the items to the toolbar
        pickerToolbar?.items = [cancelButton, flexSpace, doneButton]
        
    }
    
    @objc func cancelBtnClicked(_ button: UIBarButtonItem?) {
        selectDateField?.resignFirstResponder()
        checkInField?.resignFirstResponder()
        checkOutField?.resignFirstResponder()
    }
    
    @objc func doneBtnClicked(_ button: UIBarButtonItem?) {
        
        if selectDateField.isFirstResponder {
            selectDateField.text = dateFormatter.string(from: datePicker.date)
        }
        
        else if checkInField.isFirstResponder{
            
            let dateFormatter = DateFormatter()
           
            if let checkInTime = checkInField.text {
                
                if let dateFromStr = dateFormatter.date(from: checkInTime) {
                    
                    dateFormatter.dateFormat = "hh:mm  a"
                    dateFormatter.amSymbol = "AM"
                    dateFormatter.pmSymbol = "PM"
                                        
                    var timeFromDate = dateFormatter.string(from: timePicker.date)
                    print(timeFromDate)
                    
                    checkInField.text = timeFromDate
                    
                }
                
            }
          
        }
        
        else if checkOutField.isFirstResponder{
            
            let dateFormatter = DateFormatter()
            
            if let checkOutTime = checkOutField.text {
                
                if let dateFromStr = dateFormatter.date(from: checkOutTime) {
                    
                    dateFormatter.dateFormat = "hh:mm  a"
                    dateFormatter.amSymbol = "AM"
                    dateFormatter.pmSymbol = "PM"
                    
                    var timeFromDate = dateFormatter.string(from: timePicker.date)
                    print(timeFromDate)
                    
                    checkOutField.text = timeFromDate
                    
                }
                
            }
            
        }
        
        
        self.view.endEditing(true)
    }
        
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
    }
    

}


extension AttendenceRegularizationVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
}

extension AttendenceRegularizationVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Comments" {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == "" {
            textView.text = "Comments"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var newText = textView.text!
        newText.removeAll { (character) -> Bool in
            return character == " " || character == "\n"
        }
        return (newText.count + text.count) <= 40
    }
    
}
    
    

