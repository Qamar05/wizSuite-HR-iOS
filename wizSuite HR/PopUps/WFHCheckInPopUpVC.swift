//
//  WFHCheckInPopUpVC.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 05/10/23.
//

import UIKit

class WFHCheckInPopUpVC: UIViewController {
    
    private var indicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    private var viewModel: AttendanceViewModel?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.showAnimate()
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
    
    
    
    @IBAction func cancelBtnClick(_ sender: Any) {
        
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func continueBtnClick(_ sender: Any) {
        
        indicatorView.startAnimating()
        
        let token = GenericMethods.getToken()
        let attendenceDate = GenericMethods.getCurrentAttendanceDate()
        let checkOutNote = ""
        let checkOut_lat  = GenericMethods.getCheckOutLat()
        let checkOut_long = GenericMethods.getCheckInLong()
        let approvedBy = ""
        
        
        let body = ["token": token,"attendence_date": attendenceDate,"checkout_note": checkOutNote, "checkout_let": checkOut_lat,"checkout_long": checkOut_long, "approved_by":approvedBy] as [String : Any]
        
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
    
    
}
