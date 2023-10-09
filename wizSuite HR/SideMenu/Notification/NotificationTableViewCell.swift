//
//  NotificationTableViewCell.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 20/09/23.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
  
    @IBOutlet var backView: UIView!
    @IBOutlet var imgCircularView: UIView!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var descLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var timeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    func configureUI() {
        
        backView.layer.cornerRadius = 10
        backView.layer.borderColor = UIColor.lightGray.cgColor
        backView.layer.borderWidth = 0.4
        
        imgCircularView.layer.cornerRadius = imgCircularView.frame.size.width / 2
        imgCircularView.backgroundColor = GenericColours.myCustomGreen
        
    }
    
    
    func bindData(withModel model: NotificationDataModel){

        let text = normalize(htmlText: model.message ?? "")
        descLbl.attributedText = text
        
        titleLbl.text = model.title
        imgView.layer.cornerRadius = imgView.frame.size.width / 2
        imgView.backgroundColor = GenericColours.myCustomGreen
        
        showDate(model: model)
        showTime(model: model)
    
    }
    
    
    func showDate(model: NotificationDataModel){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var dateFromStr = dateFormatter.date(from: model.createdAt ?? "")!
        dateFormatter.dateFormat = "EE MMM d, yyyy"
      
        var timeFromDate = dateFormatter.string(from: dateFromStr)
        print("COVERTED DATE", timeFromDate)
        
        dateLbl.text = timeFromDate
        
    }
    
    func showTime(model: NotificationDataModel){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var dateFromStr = dateFormatter.date(from: model.createdAt ?? "")!
        dateFormatter.dateFormat = "hh:mm a"

        //Output: Customisable AP/PM symbols
        dateFormatter.amSymbol = "am"
        dateFormatter.pmSymbol = "Pm"
       // dateFormatter.dateFormat = "a"
        //Output: Pm
      
        var timeFromDate = dateFormatter.string(from: dateFromStr)
        print("COVERTED TIME", timeFromDate)
        
        
        
        
    }
    
   
    
    func openUrl(urlString:String!) {
        let url = URL(string: urlString)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    
    private func normalize(htmlText: String) -> NSAttributedString {

        func basicNormalize(htmlString: String) -> String {
            return htmlText
                .replacingOccurrences(of: "<br>", with: "\n")
                .replacingOccurrences(of: "&quot;", with: "\"")
        }

        guard let data = htmlText.data(using: .utf8) else {
            return NSAttributedString(string: basicNormalize(htmlString: htmlText))
        }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        guard let attributedString = try? NSMutableAttributedString(
            data: data,
            options: options,
            documentAttributes: nil) else {
                return NSAttributedString(string: basicNormalize(htmlString: htmlText))
            }
        
        print("htmlText***",htmlText)
        
       // print("Before:\n\(attributedString)")
        attributedString.enumerateAttributes(in: NSRange(location: 0, length: attributedString.length),
                                             options: []) { attributes, subrange, stop in
            let attributesToRemove = attributes.filter { $0.key != .link }
            attributesToRemove.forEach {
                attributedString.removeAttribute($0.key, range: subrange)
            }
        }
       // print("Result:\n\(attributedString)")
        return attributedString
    }
    
    
    func BestFunforConversion() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        var dateFromStr = dateFormatter.date(from: "12:16:45")!
        
        dateFormatter.dateFormat = "hh:mm:ss a 'on' MMMM dd, yyyy"
        //Output: 12:16:45 PM on January 01, 2000
        
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        //Output: Sat, 1 Jan 2000 12:16:45 +0600
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        //Output: 2000-01-01T12:16:45+0600
        
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        //Output: Saturday, Jan 1, 2000
        
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        //Output: 01-01-2000 12:16
        
        dateFormatter.dateFormat = "MMM d, h:mm a"
        //Output: Jan 1, 12:16 PM
        
        dateFormatter.dateFormat = "HH:mm:ss.SSS"
        //Output: 12:16:45.000
        
        dateFormatter.dateFormat = "MMM d, yyyy"
        //Output: Jan 1, 2000
        
        dateFormatter.dateFormat = "MM/dd/yyyy"
        //Output: 01/01/2000
        
        dateFormatter.dateFormat = "hh:mm:ss a"
        //Output: 12:16:45 PM
        
        dateFormatter.dateFormat = "MMMM yyyy"
        //Output: January 2000
        
        dateFormatter.dateFormat = "dd.MM.yy"
        //Output: 01.01.00
        
        //Output: Customisable AP/PM symbols
        dateFormatter.amSymbol = "am"
        dateFormatter.pmSymbol = "Pm"
        dateFormatter.dateFormat = "a"
        //Output: Pm
        
        // Usage
        let timeFromDate = dateFormatter.string(from: dateFromStr)
        print(timeFromDate)
    }
    
}
