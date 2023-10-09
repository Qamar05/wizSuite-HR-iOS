//
//  BirthdayListTableViewCell.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 20/09/23.
//

import UIKit

class BirthdayListTableViewCell: UITableViewCell {
    
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userDesignation: UILabel!
    @IBOutlet var userBirthday: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureUI(){
        
        userImage.layer.cornerRadius = userImage.frame.width / 2
        userImage.layer.borderColor = GenericColours.myCustomGreen.cgColor
        userImage.layer.borderWidth = 2
        userBirthday.textColor = GenericColours.myCustomGreen
    }
    
    
    
    func bindData(withModel model: BirthdayData){
        
        userName.text = model.firstname
        userDesignation.text = model.designation
        
        let dateStr = formattedDateFromString(dateString: model.dob ?? "", withFormat: "MMM d")
        userBirthday.text = dateStr
        
        userImage.downloaded(from: model.photo ?? "")
    
    }
    
    func formattedDateFromString(dateString: String, withFormat format: String) -> String? {
        
        let inputFormatter = DateFormatter()
        //"1985-09-29",
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = inputFormatter.date(from: dateString) {
            
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = format
            
            return outputFormatter.string(from: date)
        }
        
        return nil
    }
    
    
//    func downloadImage(from url: URL) {
//        print("Download Started")
//        getData(from: url) { data, response, error in
//            guard let data = data, error == nil else { return }
//            print(response?.suggestedFilename ?? url.lastPathComponent)
//            print("Download Finished")
//            // always update the UI from the main thread
//            DispatchQueue.main.async() { [weak self] in
//                self?.userImage.image = UIImage(data: data)
//            }
//        }
//    }
//
//
//    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
//        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
//    }
    
}


extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
