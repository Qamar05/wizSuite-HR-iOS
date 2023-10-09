//
//  MyProfileVC.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 20/09/23.
//

import UIKit


struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpeg"
        self.filename = "imagefile.jpg"
        guard let data = image.jpegData(compressionQuality: 0.7) else { return nil }
        self.data = data
    }
}


class MyProfileVC: UIViewController {
    
    @IBOutlet var sideMenuBtn: UIBarButtonItem!
    @IBOutlet var profileImgView: UIImageView!
    @IBOutlet var designationLbl: UILabel!
    @IBOutlet var phoneLbl: UILabel!
    @IBOutlet var emailLbl: UILabel!
    @IBOutlet var locationLbl: UILabel!
    @IBOutlet var bloodGroupLbl: UILabel!
    @IBOutlet var dateofBirthLbl: UILabel!
    @IBOutlet var editIconBtn: UIButton!
    @IBOutlet var submitBtn: UIButton!
    
    
    var indicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    var viewModel: MyProfileVM?
    var imagePicker = UIImagePickerController()
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureUI()
        
        indicatorView = self.activityIndicator(style: .large,
                                               center: self.view.center)
        sideMenuBtn.target = self.revealViewController()
        sideMenuBtn.action = #selector(self.revealViewController()?.revealSideMenu)
        
        viewModel = MyProfileVM()
        self.fetchMyProfileList()
        

                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func configureUI(){
        
        self.designationLbl.text =  ""
        self.phoneLbl.text = ""
        self.emailLbl.text = ""
        self.locationLbl.text = ""
        self.bloodGroupLbl.text = ""
        self.dateofBirthLbl.text = ""
        profileImgView.contentMode = .scaleAspectFill
        submitBtn.backgroundColor = GenericColours.myCustomGreen
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
     
        self.profileImgView.layer.cornerRadius = profileImgView.bounds.width/2
        self.profileImgView.layer.borderWidth = 1
        self.profileImgView.layer.borderColor = GenericColours.myCustomGreen.cgColor
        
        editIconBtn.backgroundColor = GenericColours.myCustomGreen
        editIconBtn.layer.cornerRadius = editIconBtn.bounds.width/2
        
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
    
    
    func fetchMyProfileList() {
        
        indicatorView.startAnimating()
        
        viewModel?.fetchProfileDetails(completionHandler: { [weak self] (data , error) in
            
            if let model = data, model.status == true {
                
                DispatchQueue.main.async {
                    self?.bindData(model: model)
                }
                
            } else{
                DispatchQueue.main.async {
                    self?.view.makeToast("No Records Found")
                }
            }
            
            DispatchQueue.main.async {
                self?.indicatorView.stopAnimating()
            }
            
        })
        
    }
    
    
    func bindData(model: MyProfileModel) {
        
        if let designation = model.designation, !designation.isEmpty {
            self.designationLbl.text =  model.designation
        }
        
        if let phoneLbl = model.phone, !phoneLbl.isEmpty {
            self.phoneLbl.text = model.phone
        }
        
        if let emailLbl = model.phone, !emailLbl.isEmpty {
            self.phoneLbl.text = model.email
        }
        
        if let location = model.location , !location.isEmpty {
            self.locationLbl.text = model.location
        }
        
        if let bloodGroup = model.bloodGroup, !bloodGroup.isEmpty  {
            self.bloodGroupLbl.text = model.location
        }
        
        if let dateofBirth = model.dob, !dateofBirth.isEmpty  {
            self.dateofBirthLbl.text = model.location
        }
        
        if let photo = model.dob, !photo.isEmpty  {
            self.profileImgView.downloaded(from: model.photo ?? "")
            
        }
        
    }
    
    
    @IBAction func notificationTapped(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NotificationVC") as? NotificationVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    @IBAction func saveButtonClick(_ sender: Any) {
        
        uploadImageToServer()
    }
    
    
    @IBAction func editButtonClick(_ sender: Any) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        //If you want work actionsheet on ipad then you have to use popoverPresentationController to present the actionsheet, otherwise app will crash in iPad
//        switch UIDevice.current.userInterfaceIdiom {
//        case .pad:
//            alert.popoverPresentationController?.sourceView = sender
//            alert.popoverPresentationController?.sourceRect = sender.bounds
//            alert.popoverPresentationController?.permittedArrowDirections = .up
//        default:
//            break
//        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Open the camera
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            //If you dont want to edit the photo then you can set allowsEditing to false
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Choose image from camera roll
    
    func openGallary() {
        
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        //If you dont want to edit the photo then you can set allowsEditing to false
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    

    func uploadImageToServer() {
        
        indicatorView.startAnimating()
        
        let userID = GenericMethods.getUserID()
        
        let parameters = ["userid": userID]
        
        guard let mediaImage = Media(withImage: profileImgView.image!, forKey: "photo") else { return }
        
        guard let url = URL(string:  NetworkConstant.editProfileUrl) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        //create boundary
        let boundary = generateBoundary()
        //set content type
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        //call createDataBody method
        let dataBody = createDataBody(withParameters: parameters, media: [mediaImage], boundary: boundary)
        
        request.httpBody = dataBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    print(json as Any)
                    
                    if let data = json?["data"]  as? [String:Any] {
                        print(data)
                        DispatchQueue.main.async {
                            let message = data["message"] as? String
                            self.view.makeToast(message)
                        }
                        
                    }
                    
                    
                } catch {
                    print(error)
                    DispatchQueue.main.async {
                        print("Failed to load: \(error.localizedDescription)")
                        self.view.makeToast("Failed to load: \(error.localizedDescription)")
                    }
                }
            }
        }.resume()
    }
            
    
    
    func createDataBody(withParameters params: [String:Any]?, media: [Media]?, boundary: String) -> Data {
       
        let lineBreak = "\r\n"
        var body = Data()
        
        
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value as! String + lineBreak)")
            }
        }
        
       // let body = ["userid": userID, "photo": ""]


        
        if let media = media {
            for photo in media {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
            }
        }
        body.append("--\(boundary)--\(lineBreak)")
        return body
    }
       

    func generateBoundary() -> String {
       return "Boundary-\(NSUUID().uuidString)"
    }
    
    
    
    
}


extension MyProfileVC:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let chosenImage = info[.originalImage] as? UIImage {
            //use image
            self.profileImgView.image = chosenImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
    
    
}



extension Data {
   mutating func append(_ string: String) {
      if let data = string.data(using: .utf8) {
         append(data)
         print("data======>>>",data)
      }
   }
}
