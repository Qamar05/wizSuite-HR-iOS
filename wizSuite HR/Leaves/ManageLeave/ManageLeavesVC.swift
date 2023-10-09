//
//  ManageLeavesViewController.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 08/09/23.
//

import UIKit

class ManageLeavesVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var applyLeaveButton: UIButton!
    var viewModel: ManageLeavesVM?
    var indicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    @IBOutlet var collectionViewHeightConstraint: NSLayoutConstraint!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        registerTableViewCells()
        registerCollectionView()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        viewModel = ManageLeavesVM()
        
        fetchHistoryData()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Manage Leaves"
        
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 17)
        ]
        
        let image = UIImage(systemName: "chevron.backward")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style:  .plain, target: self, action:  #selector(self.backAction(_:)))
        self.navigationItem.leftBarButtonItem?.tintColor = .white
        
       // fetchHistoryData()
        
    }
    
    @objc func backAction(_ sender: UIBarButtonItem? = nil) {
        print("Button click...")
        self.navigationController?.popViewController(animated: true)
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
    
    
    private func registerTableViewCells() {
        
        let textFieldCell = UINib(nibName: "LeavesHistoryTableViewCell",
                                  bundle: nil)
        tableView.register(textFieldCell,
                           forCellReuseIdentifier: "LeavesHistoryTableViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.separatorStyle = .none
        tableView.reloadData()
        
    }
    
    
    func registerCollectionView(){
        collectionView.register(UINib(nibName: "LeaveBalanceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 150, height: 150)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        collectionView!.collectionViewLayout = layout
        
    }
    
    func configureView(){
        
        indicatorView = self.activityIndicator(style: .large,
                                               center: self.view.center)
        self.view.addSubview(indicatorView)
        
        applyLeaveButton.layer.cornerRadius = 6
        applyLeaveButton.backgroundColor = GenericColours.myCustomGreen
        applyLeaveButton.setTitleColor(.white, for: .normal)
        applyLeaveButton.setTitle("APPLY LEAVE", for: .normal)
        applyLeaveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    
    
    func fetchHistoryData(){
        
        self.indicatorView.startAnimating()
        
        viewModel?.fetchLeavesData(completionHandler: { [weak self] (data , error) in
            
            if let error = error {
                
                DispatchQueue.main.async {
                    self?.view.makeToast(error.localizedDescription)
                    self?.collectionViewHeightConstraint.constant = 0
                }
            }
            
            else if let dateModel = data, dateModel.status == true {
                if let modelCount = dateModel.data?.count, modelCount > 0  {
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                        self?.collectionView.reloadData()
                    }
                    
                } else{
                    DispatchQueue.main.async {
                        self?.collectionView.reloadData()
                        self?.view.makeToast("No Records Found")
                    }
                }
                
            }
            else{ //status false
                DispatchQueue.main.async {
                    self?.view.makeToast(data?.message)
                    self?.collectionViewHeightConstraint.constant = 0
                }
            }
            
            DispatchQueue.main.async {
                self?.indicatorView.stopAnimating()
            }
            
        })
    }
    
    
    @IBAction func applyLeavesClick(_ sender: Any) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ApplyLeaveVC") as? ApplyNewLeaveVC
        vc?.leavesModel = self.viewModel
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    
    func hitCancelLeaveAPI(cancelIndexPath: IndexPath) {
        
        self.indicatorView.startAnimating()
        
        if let leavesAppliedData = self.viewModel?.model?.data?[cancelIndexPath.row] as? LeavesAppliedModel{
            
            let leaveId =  leavesAppliedData.leaveId
            
            let body = ["leave_id": leaveId]
            
            self.viewModel?.cancelLeaveAPI(body: body as [String : Any], completionHandler: { [weak self] (data , error) in
                
                if let dateModel = data, dateModel.status == true {
                    
                    DispatchQueue.main.async {
                        self?.viewModel?.model?.data?.remove(at: cancelIndexPath.row)
                        self?.tableView.beginUpdates()
                        self?.tableView.deleteRows(at: [cancelIndexPath], with: .automatic)
                        self?.tableView.endUpdates()
                    }
                    
                }
                else{
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
    
    
    
    
    
}

extension ManageLeavesVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.model?.remaining?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as? LeaveBalanceCollectionViewCell{

            if let vm = viewModel, let count = vm.model?.remaining?.count, count > 0 {
                
                if let leavesbalanceData = vm.model?.remaining?[indexPath.row] as? LeaveBalanceModel{
                    
                    cell.bindData(withModel: leavesbalanceData)
                    
                }
            }
            
            
            return cell
        }
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 140, height: 100)
        
    }
    
}





extension  ManageLeavesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.model?.data?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "LeavesHistoryTableViewCell") as? LeavesHistoryTableViewCell {
            
            if let vm = viewModel, let count = vm.model?.data?.count, count > 0 {
                
                if let leavesAppliedData = vm.model?.data?[indexPath.row] as? LeavesAppliedModel{
                    cell.delegate = self
                    cell.bindTableViewData(indexPath: indexPath, withModel: leavesAppliedData, leaveModel:self.viewModel?.model)
                }
            }
            
            return cell
        }
        return UITableViewCell()
        
    }
    
  
    
}

extension ManageLeavesVC: LeavesHistoryTableViewCellDelegate {
    
    
    func cancelButtonClick(indexPath: IndexPath) {
        
        let cancelIndexPath:IndexPath = indexPath
        
        let alert = UIAlertController(title: "Cancel Leave !", message: "Are you Sure? You want to cancel your applied leaves", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.hitCancelLeaveAPI(cancelIndexPath: cancelIndexPath)

        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        
            
        }))
        
        self.present(alert, animated: true, completion: {
            
        })
        
    }
}
