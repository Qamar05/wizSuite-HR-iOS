//
//  NotificationVC.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 20/09/23.
//

import UIKit

class NotificationVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    private var indicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    private var viewModel: NotificationVM?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        viewModel = NotificationVM()
        registerTableViewCells()
        
        indicatorView = self.activityIndicator(style: .large,
                                               center: self.view.center)
        self.fetchNotificationList()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Notification"
        let image = UIImage(systemName: "chevron.backward")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style:  .plain, target: self, action:  #selector(self.backAction(_:)))
        self.navigationItem.leftBarButtonItem?.tintColor = .white
        
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 17)
        ]
            
        //arrow.backward
    }
    
    
    @objc func backAction(_ sender: UIBarButtonItem? = nil) {
        print("Button click...")
        self.navigationController?.popViewController(animated: true)
    }
    
    private func registerTableViewCells() {
        let tableViewCell = UINib(nibName: "NotificationTableViewCell",
                                  bundle: nil)
        tableView.register(tableViewCell,
                           forCellReuseIdentifier: "NotificationTableViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        tableView.separatorStyle = .none
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
    
    
    
    func fetchNotificationList(){
        
        indicatorView.startAnimating()
        
        viewModel?.fetchNotificationDetails(completionHandler: { [weak self] (data , error) in
            
            if let data = data, data.status == true {
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.model?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell") as? NotificationTableViewCell {
            
            if let vm = viewModel, let count = vm.model?.data?.count, count > 0 {
                
                if let notiData = vm.model?.data?[indexPath.row] as? NotificationDataModel{
                    
                    cell.bindData(withModel: notiData)
                    
                }
            }
            
            return cell
        }
        
        return UITableViewCell()
        
    }
    
    

}

