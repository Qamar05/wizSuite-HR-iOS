//
//  MyBirthdayVC.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 20/09/23.
//

import UIKit

class BirthdayListVC: UIViewController {
    
    @IBOutlet var tableView: UITableView!    
    @IBOutlet var sideMenuBtn: UIBarButtonItem!
    
    private var indicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    private var viewModel: BirthdayListVM?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()       

        viewModel = BirthdayListVM()
        registerTableViewCells()
        
        indicatorView = self.activityIndicator(style: .large,
                                               center: self.view.center)
        
        sideMenuBtn.target = self.revealViewController()
        sideMenuBtn.action = #selector(self.revealViewController()?.revealSideMenu)
        
        self.fetchBirthdayList()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = .white

    }
    
    
    @IBAction func notificationTapped(_ sender: Any) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NotificationVC") as? NotificationVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    private func registerTableViewCells() {
        let tableViewCell = UINib(nibName: "BirthdayListTableViewCell",
                                  bundle: nil)
        tableView.register(tableViewCell,
                           forCellReuseIdentifier: "BirthdayListTableViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 250
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
    
    func fetchBirthdayList(){
        
        indicatorView.startAnimating()
        
        let token =  GenericMethods.getToken()
        let attendanceDate =  GenericMethods.getCurrentAttendanceDate()
        let body = ["token": token,"attendence_date": "2023-10-03"]
        
        viewModel?.fetchBirthdayDetails(body:body ,completionHandler: { [weak self] (data , error) in
            
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


extension BirthdayListVC: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.model?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BirthdayListTableViewCell") as? BirthdayListTableViewCell {
                        
            if let vm = viewModel, let count = vm.model?.data?.count, count > 0 {

                if let birthdayData = vm.model?.data?[indexPath.row] as? BirthdayData{

                    cell.bindData(withModel: birthdayData)

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
