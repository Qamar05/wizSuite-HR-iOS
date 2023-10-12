//
//  HolidayListViewController.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 08/09/23.
//

import UIKit

class HolidayListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private  var indicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    private var viewModel: HolidayListVM?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = HolidayListVM()
        registerTableViewCells()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 250
        tableView.separatorStyle = .none
        
        indicatorView = self.activityIndicator(style: .large,
                                               center: self.view.center)
        fetchHolidayList()
        
        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Holiday List"
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
        let tableViewCell = UINib(nibName: "HolidayListTableViewCell",
                                  bundle: nil)
        tableView.register(tableViewCell,
                                forCellReuseIdentifier: "HolidayListTableViewCell")
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
    
    
    func fetchHolidayList(){
        
        indicatorView.startAnimating()
        
        viewModel?.fetchHolidayData(completionHandler: { [weak self] (data , error) in
            
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
    
    
    
}


extension HolidayListVC: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.model?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HolidayListTableViewCell") as? HolidayListTableViewCell {
            
            if let vm = viewModel, let count = vm.model?.data.count, count > 0 {
                
                if let holidayData = vm.model?.data[indexPath.row] as? HolidayData{
                    
                    cell.bindData(withModel: holidayData)
                    print(holidayData.holidayDate )
                    
                }
            }
            
            return cell
        }
        
        return UITableViewCell()
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80 //or whatever you need
    }
    
    
}
