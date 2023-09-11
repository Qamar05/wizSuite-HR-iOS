//
//  HolidayListViewController.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 08/09/23.
//

import UIKit

class HolidayListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        registerTableViewCells()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        
        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Holiday List"
        
       // self.navigationController?.navigationBar.backgroundColor = UIColor.red
    }
    
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "HolidayListTableViewCell",
                                  bundle: nil)
        tableView.register(textFieldCell,
                                forCellReuseIdentifier: "HolidayListTableViewCell")
    }
    
}


extension HolidayListVC: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HolidayListTableViewCell") as? HolidayListTableViewCell {
            //cell.backView.backgroundColor = .yellow
            return cell
        }
        
        return UITableViewCell()
        
        
    }
    
    
}
