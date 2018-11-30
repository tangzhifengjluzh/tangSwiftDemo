//
//  WJMySelfRecordController.swift
//  SwiftDemo1
//
//  Created by mac on 2018/11/27.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa
import MJRefresh
import Alamofire

class WJMySelfRecordController: UIViewController {
    var tableView:UITableView!
    var recordArray:[Record] = [Record]()
    let viewModel = WJMySelfRecordViewModel()
    var dataSource:Variable = Variable<[Record]>([Record]())
    var model:Study_Record?
    var p:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "学习记录"
        setUpView()
//        getdata()
           initialBindRx()
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
//            self.p = 1;
//            self.getdata()
            self.viewModel.page.value = 1;
            self.viewModel.refreshTap.value = true
        })
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
//            self.p += 1
//            self.getdata()
            self.viewModel.page.value += 1
            self.viewModel.refreshTap.value = true
        })
       
    }
    /** 绑定Rx */
    func initialBindRx() {
        viewModel.recordObservable.subscribe(onNext: { (result) in
            switch result {
            case let .ok(message: data,state: state):
                self.model = (data as! Study_Record)
                self.dataSource.value = (self.model?.list_data!)!
                if (self.dataSource.value.count == 0)
                {
//                    self.showSVPNoneMessage(message: "暂无信息")
                }
//                self.tableView.tableHeaderView = self.tableHeardView()
                self.tableView.mj_header.endRefreshing()
                if(state == true){
                    self.tableView.mj_footer.isHidden = false
                    self.tableView.mj_footer.endRefreshing()
                }else{
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                    self.tableView.mj_footer.isHidden = true
                }
            case let .error(message: message):
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
//                self.showSVPProgressMessage(message: message)
            case let .faild(message: message):
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
//                self.showSVPMessage(message: message)
            case .empty: break
            }
        }).disposed(by: disposeBag)
        
        self.dataSource.asObservable().bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: WJMySelfRecordCell.self)) { (row, element, cell) in
            cell.selectionStyle = .none
            cell.model = element
            }.disposed(by: disposeBag)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
extension WJMySelfRecordController:UITableViewDelegate{

    func getdata() -> Void {
        let parameters:Dictionary = ["p":p,"token":"5ff40904c23b5759da3b1e159a84317c"] as [String : Any]
        Alamofire.request(KMBASE_URL + "Apiq/study_record", method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
            debugPrint(response)
             self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            guard  response.result.value != nil else{
                return;
            }
            let json:Dictionary =  response.result.value as! Dictionary<String,AnyObject>
            let code:Int = json["ret_code"] as! Int
//            let msg:String = json["msg"] as! String
            if code == 1 {
                let data = json["data"] as! Dictionary<String,AnyObject>
                let totle_page:Int = json["data"]!["totle_page"] as! Int
                let SignUptring = getJSONStringFromDictionary(dictionary: data as AnyObject)
                var model:Study_Record = Study_Record.deserialize(from: SignUptring)!
                if self.p == 1 {
                    self.recordArray = [Record]()
                }
                self.recordArray =  self.recordArray + model.list_data!
                model.list_data = self.recordArray
                if self.p == totle_page {
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                    self.tableView.mj_footer.isHidden = true
                }else{
                    self.tableView.mj_footer.isHidden = false
                    self.tableView.mj_footer.endRefreshing()
                }
            }else if code == -1 {
//                return goBlackLogoInViewController()
            }else{
            }
            self.tableView.reloadData()
        }
    }

    func setUpView() -> Void {
        view.backgroundColor = UIColor.white
        tableView = UITableView().then({
            $0.separatorColor = UIColor.red
            $0.backgroundColor = UIColor.lightGray
            view.addSubview($0)
//            $0.delegate = self
//            $0.dataSource = self
            $0.register(WJMySelfRecordCell.self, forCellReuseIdentifier:"cell")
          _ =  $0.sd_layout().topSpaceToView(view,0)?.leftSpaceToView(view,0)?.rightSpaceToView(view,0)?.bottomSpaceToView(view,0)
        })
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.recordArray.count == 0{
            return 0
        }
        return self.recordArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell:WJMySelfRecordCell = tableView.dequeueReusableCell(withIdentifier:"cell", for: indexPath) as! WJMySelfRecordCell
        let row=self.recordArray[indexPath.row]
        cell.model = row
        return cell
    }
}
