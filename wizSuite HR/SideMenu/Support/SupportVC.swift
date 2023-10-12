//
//  SupportVC.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 21/09/23.
//

import UIKit
import UniformTypeIdentifiers

struct SupportMedia {
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

class SupportVC: UIViewController {
    
    @IBOutlet var sideMenuBtn: UIBarButtonItem!
    @IBOutlet var headingTextView: UITextView!
    @IBOutlet var descTextView: UITextView!
    @IBOutlet var uploadTextView: UITextView!
    @IBOutlet var reportIssueBtn: UIButton!
    var indicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    private var viewModel: SupportVM?
    private var supportImage = UIImage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = SupportVM()
        
        indicatorView = self.activityIndicator(style: .large,
                                               center: self.view.center)
        sideMenuBtn.target = revealViewController()
        sideMenuBtn.action = #selector(revealViewController()?.revealSideMenu)
        
        configureUI()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedTextView))
        uploadTextView.addGestureRecognizer(tapRecognizer)
        uploadTextView.isSelectable = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        //Add this tap gesture recognizer to the parent view
        view.addGestureRecognizer(tap)
        
        
    }
    
    func configureUI(){
        
        reportIssueBtn.layer.cornerRadius = 6
        reportIssueBtn.backgroundColor = GenericColours.myCustomGreen
        reportIssueBtn.setTitleColor(.white, for: .normal)
        reportIssueBtn.setTitle("REPORT YOUR ISSUE", for: .normal)
        reportIssueBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        headingTextView.delegate = self
        headingTextView.text = "Heading"
        headingTextView.textColor = UIColor.lightGray
        headingTextView.selectedTextRange = headingTextView.textRange(from: headingTextView.beginningOfDocument, to: headingTextView.beginningOfDocument)
        headingTextView.layer.borderColor  = UIColor.lightGray.cgColor
        headingTextView.layer.cornerRadius = 5
        headingTextView.layer.borderWidth = 0.5

        descTextView.delegate = self
        descTextView.text = "Description"
        descTextView.textColor = .lightGray
        headingTextView.selectedTextRange = headingTextView.textRange(from: headingTextView.beginningOfDocument, to: headingTextView.beginningOfDocument)
        descTextView.layer.cornerRadius = 5
        descTextView.layer.borderWidth = 0.5
        descTextView.layer.borderColor  = UIColor.lightGray.cgColor
        
        
        uploadTextView.text = "Upload Screeshot"
        uploadTextView.textColor = .lightGray
        uploadTextView.selectedTextRange = uploadTextView.textRange(from: uploadTextView.beginningOfDocument, to: uploadTextView.beginningOfDocument)
        uploadTextView.layer.cornerRadius = 5
        uploadTextView.layer.borderWidth = 0.5
        uploadTextView.layer.borderColor  = UIColor.lightGray.cgColor
        
    }
    
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
    
    
    @IBAction func notificationButtonTapped(_ sender: Any) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NotificationVC") as? NotificationVC
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    
    @objc func tappedTextView(tapGesture: UIGestureRecognizer) {
        
        guard let textView = tapGesture.view as? UITextView else { return }
            
        var documentPicker: UIDocumentPickerViewController!
        if #available(iOS 14, *) {
            let supportedTypes: [UTType] = [UTType.image, UTType.pdf, UTType.text, UTType.png, UTType.jpeg]
            documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes)
            
        } else {
            // iOS 13 or older code
            //            let supportedTypes: [String] = [kUTTypeImage as String]
            //            documentPicker = UIDocumentPickerViewController(documentTypes: supportedTypes, in: .import)
        }
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = true
        documentPicker.modalPresentationStyle = .formSheet
        self.present(documentPicker, animated: true)
        
        
        
        //        if let url = textView.textStyling(at: position, in: .forward)?[NSAttributedString.Key.link] as? URL {
        //            print("URL****",url)
        //            UIApplication.shared.open(url)
        //        }
    }
    
    
    @IBAction func notificationTapped(_ sender: Any) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NotificationVC") as? NotificationVC
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    
    @IBAction func reportIssueBtnClick(_ sender: Any) {
        
        if headingTextView.text.isEmpty{
            self.view.makeToast("Please add Heading")
            return
        }
        
        else if descTextView.text.isEmpty{
            self.view.makeToast("Please add Heading")
            return
            
        }
        else if uploadTextView.text.isEmpty{
            self.view.makeToast("Please add Heading")
            return
        }
        
        uploadImageToServer()
        
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
        
    
    func uploadImageToServer() {
        
        indicatorView.startAnimating()
        
       // let parameters = ["userid": userID]
        
        let token = GenericMethods.getToken()
        let heading = headingTextView.text
        let description = descTextView.text
        
        let parameters = ["token": token,"heading": heading,description: description] as? [String:Any]
        
        guard let mediaImage = SupportMedia(withImage: supportImage, forKey: "photo") else { return }
        
        guard let url = URL(string:  NetworkConstant.getSupportUrl) else { return }
        
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
            
    
    
    func createDataBody(withParameters params: [String:Any]?, media: [SupportMedia]?, boundary: String) -> Data {
       
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



extension SupportVC: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        for url in urls {
            
            // Start accessing a security-scoped resource.
            guard url.startAccessingSecurityScopedResource() else {
                // Handle the failure here.
                return
            }
            
            do {
                
                let fileurl: URL = url as URL
                
                let filename = url.lastPathComponent
                
                let fileextension = url.pathExtension
                
                let filedata = url.dataRepresentation
                
                print("DATA: \(filedata)","URL: \(fileurl)", "NAME: \(filename)", "EXTENSION: \(fileextension)")
                
                
                // let attributedString = NSMutableAttributedString(string: "Support Centers")
                
                let textAttachment = NSTextAttachment()
                
//                if let image =  UIImage(data: filedata){
//                    
//                    supportImage = UIImage(data: filedata) ?? UIImage()
//
//                }

                
                supportImage = UIImage(data: filedata) ?? UIImage()
                
                textAttachment.image =  UIImage(data: filedata)
                
                let attrStringWithImage = NSAttributedString(attachment: textAttachment)
                
                // attributedString.replaceCharacters(in: NSMakeRange(2, 1), with: attrStringWithImage)
                
                self.uploadTextView.attributedText = attrStringWithImage
                
                
                
                //                let data = try Data.init(contentsOf: url)
                //
                //                print("DATA***",data)
                
                
                
                
                //                if let uiImage: UIImage = UIImage(data: data){
                //
                //                    let attributedString = NSMutableAttributedString(string: "iOSdevCenters")
                //                    let textAttachment = NSTextAttachment()
                //                    textAttachment.image = uiImage
                //                    let attrStringWithImage = NSAttributedString(attachment: textAttachment)
                //                   // attributedString.replaceCharacters(in: NSMakeRange(2, 1), with: attrStringWithImage)
                //
                //                    self.uploadTextView.attributedText = attributedString
                //                }
                
                
                // self.uploadTextView.text = try String(contentsOfFile: url.path)
                
                
                
                
                
                // You will have data of the selected file
            }
            catch {
                print(error.localizedDescription)
            }
            
            // Make sure you release the security-scoped resource when you finish.
            defer { url.stopAccessingSecurityScopedResource() }
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension SupportVC: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        //let currentText: NSString = textView.text as NSString
       // let updatedText = currentText.replacingCharacters(in: range, with:text)
        if headingTextView.text.isEmpty{
            headingTextView.text = "Heading"
            headingTextView.textColor = UIColor.lightGray
            headingTextView.selectedTextRange = descTextView.textRange(from: descTextView.beginningOfDocument, to: descTextView.beginningOfDocument)
            return false
            
        }
        else if descTextView.text.isEmpty{
            descTextView.text = "Description"
            descTextView.textColor = UIColor.lightGray
            descTextView.selectedTextRange = descTextView.textRange(from: descTextView.beginningOfDocument, to: descTextView.beginningOfDocument)
            return false
            
        }
        else if uploadTextView.text.isEmpty{
            uploadTextView.text = "Upload Screeshot"
            uploadTextView.textColor = UIColor.lightGray
            uploadTextView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            return false
            
        }
        
        //        if updatedText.isEmpty {
        //
        //            headingTextView.text = "Heading"
        //            descTextView.text = "Description"
        //            uploadTextView.text = "Upload Screeshot"
        //
        //            textView.textColor = UIColor.lightGray
        //            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        //            return false
        //        }
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
