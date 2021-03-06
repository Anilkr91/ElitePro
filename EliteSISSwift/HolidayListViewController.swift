//
//  HolidayListViewController.swift
//  EliteSISSwift
//
//  Created by Reetesh Bajpai on 23/03/18.
//  Copyright © 2018 Vivek Garg. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ALLoadingView

class HolidayListViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tblViewHolidayList: UITableView!
    var arrHolidayName = [String]()
    var arrHolidayDate = [String]()
    var arrHolidayDay = [String]()
    var arrHolidayList = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblViewHolidayList.separatorStyle = .none
        tblViewHolidayList.sectionHeaderHeight = 45
        tblViewHolidayList.rowHeight = UITableViewAutomaticDimension
        
        //        arrHolidayName = ["Republic Day","Maha Shivratri","Holika Dahan","Holi","Ram Navami","Rakshabandhan","Dussehra","Chhoti Diwali","Badi Diwali","Christmas"]
        //        arrHolidayDate = ["26-Jan-2018", "13-Feb-2018", "01-Mar-2018", "02-Mar-2018", "25-Mar-2018", "26-Aug-2018","19-Oct-2018", "06-Nov-2018", "07-Nov-2018", "25-Dec-2018"]
        //        arrHolidayDay = ["Friday", "Tuesday", "Thursday", "Friday", "Sunday", "Sunday","Friday", "Tuesday", "Wednesday", "Monday"]
        self.tblViewHolidayList.delegate = self
        self.tblViewHolidayList.dataSource = self
        self.tblViewHolidayList.register(UINib(nibName:Constants.Nib.NibIdentifier.holidaylistHeaderReusableviewTableViewCell, bundle: nil), forHeaderFooterViewReuseIdentifier: Constants.Nib.ReusableIdentifier.holidaylistHeaderReusableviewTableViewCell)
        self.tblViewHolidayList.register(UINib(nibName:Constants.Nib.NibIdentifier.holidayListTableViewCell, bundle:nil), forCellReuseIdentifier: Constants.Nib.ReusableIdentifier.holidayListTableViewCell)
        self .callForHolidayListData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrHolidayList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let viewHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.Nib.ReusableIdentifier.holidaylistHeaderReusableviewTableViewCell) as! HolidaylistHeaderReusableviewTableViewCell
        viewHeader.contentView.backgroundColor = UIColor.init(red: 44.0/255.0, green: 154.0/255.0, blue: 243.0/255.0, alpha: 1.0)
        return viewHeader
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Nib.ReusableIdentifier.holidayListTableViewCell) as! HolidayListTableViewCell
        print(self.arrHolidayList[indexPath.row]["sis_name"] as Any)
        cell.lblHolidayName.text = self.arrHolidayList[indexPath.row]["sis_name"] as? String
        cell.lblHolidayDate.text = self.arrHolidayList[indexPath.row]["new_startdate"] as? String
        cell.lblHolidayDay.text = self.arrHolidayList[indexPath.row]["new_dayname"] as? String
        cell.selectionStyle = .none
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showMenu(_ sender: Any) {
        
        toggleSideMenuView()
    }
    
    @IBAction func backbuttonClicked(_ sender: Any) {
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: Constants.Storybaord.MainStoryboard,bundle: nil)
        var destViewController : UIViewController
        //destViewController = mainStoryboard.instantiateViewController(withIdentifier: "dashboard")
        //sideMenuController()?.setContentViewController(destViewController)
        let selectedLogin = UserDefaults.standard.string(forKey: Constants.ServerKey.selectedLogin)
        
        //if (selectedLogin == "S")
        if (selectedLogin == "1") //Student
        {
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: Constants.Storybaord.Identifier.dashboard)
            sideMenuController()?.setContentViewController(destViewController)
            
        }
        //else if(selectedLogin == "E")
        else if(selectedLogin == "2") //Teacher
        {
            destViewController = mainStoryboard.instantiateViewController(withIdentifier:  Constants.Storybaord.Identifier.teacherDashboard)
            sideMenuController()?.setContentViewController(destViewController)
        }
        //else if(selectedLogin == "G")
        else if(selectedLogin == "3") //Parent
        {
            destViewController = mainStoryboard.instantiateViewController(withIdentifier:  Constants.Storybaord.Identifier.parentDashboard)
            sideMenuController()?.setContentViewController(destViewController)
        }
        
        hideSideMenuView()
    }
    
    func callForHolidayListData() {
        ProgressLoader.shared.showLoader(withText: "Please wait... ")
        WebServices.shared.showHolidayList(completion: { (response, error) in
            if error == nil, let responseDict = response
            {
                debugPrint(responseDict)
                print("Responce...........\(responseDict)")
                
                self.arrHolidayList = responseDict["value"].arrayObject as! [[String : Any]]
                print(self.arrHolidayList)
                DispatchQueue.main.async {
                    self.tblViewHolidayList.reloadData()
                }
                ProgressLoader.shared.hideLoader()
            }
            else
            {
                ProgressLoader.shared.hideLoader()
                AlertManager.shared.showAlertWith(title: Constants.Alert.errorOccured, message: Constants.Alert.tryAfterSomeTime)
                debugPrint(error?.localizedDescription ?? "Getting user profile error")
            }
        })
    }
}
