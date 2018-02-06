//
//  TripManagementViewController.swift
//  GX_Admin
//
//  Created by Iam H on 1/3/18.
//  Copyright © 2018 SBT Software. All rights reserved.
//

import UIKit
import FirebaseDatabase
import UserNotifications
import AudioToolbox
import AVFoundation
var tripArray:[TripModel]? = [TripModel]()
class TripManagementViewController: UIViewController {
    var player: AVAudioPlayer?
    @IBOutlet weak var heightConstraintCategoryCollection: NSLayoutConstraint!
   
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    var driverArray:[DriverModel]? = [DriverModel]();
  
   
    var handle:UInt? = 0
    var reachability:DXReachabilitySwift? = DXReachabilitySwift.networkReachabilityForInternetConnection()
    var ref:DatabaseReference? = nil
    @IBOutlet weak var deactivatedView: UIView!
 
    @IBOutlet weak var activatedView: UIView!
    @IBOutlet weak var VerifiedView: UIView!
    @IBOutlet weak var VerifySpedingView: UIView!
    @IBOutlet weak var trialView: UIView!
    
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var allView: UIView!
    
    @IBOutlet weak var layoutFlow: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionViewData: UICollectionView!
    @IBOutlet weak var txtTitle: UILabel!
    var leftMenuView: LeftMenuView?
    var window: UIWindow?
    var api:GxApiClient? = nil
    var loadMoreStatus = ""
    var productArray = [ProductModel]()
    var isDriver = false
    var pageIncrease = 0
    var tempDriverArray = [DriverModel]()
    var userInfo:UserInfo? = nil
    var tempTripArray = [TripModel]()
     var activityView: UIView?
    var userInfoLogin:UserLoginModel? = nil
    var commonClass = CommonClass()
/**
    playSound


    - Todo: play sound when have a trip

    - Author: Quang Tan Dat
**/
    
    @objc func playSound() {
        guard let url = Bundle.main.url(forResource: "over_the_horizon", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            if (player.isPlaying){
            player.stop()
            }
            else{
             player.play()
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
/**
    allTap


    - Todo: action button all

    - Author: Quang Tan Dat
**/
    
    @IBAction func allTap(_ sender: Any) {
   // set up UI
        collectionViewData.setContentOffset(self.collectionViewData.contentOffset, animated: false)
        showActivity()
         loadMoreStatus = ""
        allView.isHidden = false
        trialView.isHidden = true
        VerifySpedingView.isHidden = true
        VerifiedView.isHidden = true
        activatedView.isHidden = true
        deactivatedView.isHidden = true
        driverArray?.removeAll()
        // call api get user info, after that call api get driver list with parameter status is empty
        api?.apiGetUserInfo(userType: (userInfoLogin?.userType)!, success: {(json) in
            let userInfo = UserInfo.init(json: json)
            self.api?.apiGetDriverList(m_company_id: userInfo.m_company_id, userType: (self.userInfoLogin?.userType)!, product: "", search: "", status: "", page: "0", rowperPage: "25", success: {(json) in
                
                let result = json["result"] as! NSArray
                for i in result{
                    let driverInfo = DriverModel.init(json: i as! [String : Any])
                    self.driverArray?.append(driverInfo)
                }
                self.tempDriverArray = self.driverArray!
                self.collectionViewData.reloadData()
                
                self.hideActivity()
            }, failure:{() in
                
            })
        }, failure: {() in
            self.alertShow(title: NSLocalizedString("MessageAlert", comment: ""), meassage: NSLocalizedString("No internet connection. Please try again !", comment: ""))
        })
        
        
    }
    
    @IBAction func trialTap(_ sender: Any) {
        collectionViewData.setContentOffset(self.collectionViewData.contentOffset, animated: false)
        showActivity()
        loadMoreStatus = "TRIAL"
        allView.isHidden = true
        trialView.isHidden = false
        VerifySpedingView.isHidden = true
        VerifiedView.isHidden = true
        activatedView.isHidden = true
        deactivatedView.isHidden = true
        driverArray?.removeAll()
        api?.apiGetUserInfo(userType: (userInfoLogin?.userType)!, success: {(json) in
            let userInfo = UserInfo.init(json: json)
            self.api?.apiGetDriverList(m_company_id: userInfo.m_company_id, userType: (self.userInfoLogin?.userType)!, product: "", search: "", status: "TRIAL", page: "0", rowperPage: "25", success: {(json) in
                
                let result = json["result"] as! NSArray
                for i in result{
                    let driverInfo = DriverModel.init(json: i as! [String : Any])
                    self.driverArray?.append(driverInfo)
                }
                self.hideActivity()
                self.tempDriverArray = self.driverArray!
                self.collectionViewData.reloadData()
                
                self.hideActivity()
            }, failure:{() in
                
            })
        }, failure: {() in
            self.alertShow(title: NSLocalizedString("MessageAlert", comment: ""), meassage: NSLocalizedString("No internet connection. Please try again !", comment: ""))
        })
        
        
    }
    @IBAction func verifySpendingTap(_ sender: Any) {
        collectionViewData.setContentOffset(self.collectionViewData.contentOffset, animated: false)
        showActivity()
        loadMoreStatus = "VERIFY_SPENDING"
        allView.isHidden = true
        trialView.isHidden = true
        VerifySpedingView.isHidden = false
        VerifiedView.isHidden = true
        activatedView.isHidden = true
        deactivatedView.isHidden = true
        driverArray?.removeAll()
        api?.apiGetUserInfo(userType: (userInfoLogin?.userType)!, success: {(json) in
            let userInfo = UserInfo.init(json: json)
            self.api?.apiGetDriverList(m_company_id: userInfo.m_company_id, userType: (self.userInfoLogin?.userType)!, product: "", search: "", status: "VERIFY_SPENDING", page: "0", rowperPage: "25", success: {(json) in
                
                let result = json["result"] as! NSArray
                for i in result{
                    let driverInfo = DriverModel.init(json: i as! [String : Any])
                    self.driverArray?.append(driverInfo)
                }
                self.hideActivity()
                self.tempDriverArray = self.driverArray!
                self.collectionViewData.reloadData()
                
                self.hideActivity()
            }, failure:{() in
                
            })
        }, failure: {() in
            self.alertShow(title: NSLocalizedString("MessageAlert", comment: ""), meassage: NSLocalizedString("Your account was logged into from a new device or session expired", comment: ""))
        })
    }
    
    @IBAction func verifiedTap(_ sender: Any) {
       showActivity()
        collectionViewData.setContentOffset(self.collectionViewData.contentOffset, animated: false)
        loadMoreStatus = "VERIFIED"
        allView.isHidden = true
        trialView.isHidden = true
        VerifySpedingView.isHidden = true
        VerifiedView.isHidden = false
        activatedView.isHidden = true
        deactivatedView.isHidden = true
        driverArray?.removeAll()
        api?.apiGetUserInfo(userType: (userInfoLogin?.userType)!, success: {(json) in
            let userInfo = UserInfo.init(json: json)
            self.api?.apiGetDriverList(m_company_id: userInfo.m_company_id, userType: (self.userInfoLogin?.userType)!, product: "", search: "", status: "VERIFIED", page: "0", rowperPage: "25", success: {(json) in
                
                let result = json["result"] as! NSArray
                for i in result{
                    let driverInfo = DriverModel.init(json: i as! [String : Any])
                    self.driverArray?.append(driverInfo)
                }
                self.tempDriverArray = self.driverArray!
                self.collectionViewData.reloadData()
                
                self.hideActivity()
            }, failure:{() in
                
            })
        }, failure: {() in
            self.alertShow(title: NSLocalizedString("MessageAlert", comment: ""), meassage: NSLocalizedString("Your account was logged into from a new device or session expired", comment: ""))
        })
    }
    
    @IBAction func activatedTap(_ sender: Any) {
        collectionViewData.setContentOffset(self.collectionViewData.contentOffset, animated: false)
        showActivity()
        loadMoreStatus = "ACTIVATED"
        allView.isHidden = true
        trialView.isHidden = true
        VerifySpedingView.isHidden = true
        VerifiedView.isHidden = true
        activatedView.isHidden = false
        deactivatedView.isHidden = true
        driverArray?.removeAll()
        api?.apiGetUserInfo(userType: (userInfoLogin?.userType)!, success: {(json) in
            let userInfo = UserInfo.init(json: json)
            self.api?.apiGetDriverList(m_company_id: userInfo.m_company_id, userType: (self.userInfoLogin?.userType)!, product: "", search: "", status: "ACTIVATED", page: "0", rowperPage: "25", success: {(json) in
                
                let result = json["result"] as! NSArray
                for i in result{
                    let driverInfo = DriverModel.init(json: i as! [String : Any])
                    self.driverArray?.append(driverInfo)
                }
                self.tempDriverArray = self.driverArray!
                self.collectionViewData.reloadData()
                
                self.hideActivity()
            }, failure:{() in
                
            })
        }, failure: {() in
            self.alertShow(title: NSLocalizedString("MessageAlert", comment: ""), meassage: NSLocalizedString("Your account was logged into from a new device or session expired", comment: ""))
        })
        
    }
    var filterdTerms = [DriverModel]()
    func filterContentForSearchText(searchText: String) {
        filterdTerms = (driverArray?.filter { term in
            return (term.status?.lowercased().contains(searchText.lowercased()))!
            })!
    }
    @IBAction func deactivedTap(_ sender: Any) {
        collectionViewData.setContentOffset(self.collectionViewData.contentOffset, animated: false)
        showActivity()
        loadMoreStatus = "DEACTIVED"
        allView.isHidden = true
        trialView.isHidden = true
        VerifySpedingView.isHidden = true
        VerifiedView.isHidden = true
        activatedView.isHidden = true
        deactivatedView.isHidden = false
        tempDriverArray.removeAll()
        api?.apiGetUserInfo(userType: (userInfoLogin?.userType)!, success: {(json) in
            let userInfo = UserInfo.init(json: json)
            self.api?.apiGetDriverList(m_company_id: userInfo.m_company_id, userType: (self.userInfoLogin?.userType)!, product: "", search: "", status: "DEACTIVATED", page: "0", rowperPage: "25", success: {(json) in
                
                let result = json["result"] as! NSArray
                for i in result{
                    let driverInfo = DriverModel.init(json: i as! [String : Any])
                    self.driverArray?.append(driverInfo)
                }
                  self.hideActivity()
                self.tempDriverArray = self.driverArray!
                self.collectionViewData.reloadData()
                
              
            }, failure:{() in
                 self.hideActivity()
            })
        }, failure: {() in
             self.hideActivity()
            self.alertShow(title: NSLocalizedString("MessageAlert", comment: ""), meassage: NSLocalizedString("page", comment: ""))
        })
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(checkInternet(_:)), name: NSNotification.Name(rawValue: ReachabilityDidChangeNotificationName), object: nil)
          _ = reachability?.startNotifier()
         self.addNibFile()
        self.addNotification()
         ref = Database.database().reference().child("request")
        collectionViewData.delegate = self
        collectionViewData.dataSource = self
        api = GxApiClient()
        scrollViewHeight.constant = 0
        let nib = UINib(nibName: "DriverCollectionCellCollectionViewCell", bundle: nil);
        self.collectionViewData.register(nib, forCellWithReuseIdentifier: "Cell")
        tripArray?.removeAll()
        pageIncrease = 0
        self.txtTitle.text = "TRIP MANAGER"
        isDriver = false
    
       
           self.userInfoLogin = commonClass.loadRememberedUser()
      loadChildChange()
         loadProduct()
    
    }
/**
    loadProduct


    - Todo: load product of service

    - Author: Quang Tan Dat
**/
    
    func loadProduct(){
        
        api?.apiGetUserInfo(userType: (userInfoLogin?.userType)!, success: {(json) in
            let userInfo = UserInfo.init(json: json)
            self.api?.getProduct(provineName: userInfo.provideName,success:{(json) in
                print(json)
                let result = json
                for i in result{
                    let productInfo = ProductModel.init(json: i as! [String : Any])
                    self.productArray.append(productInfo)
                }
                print(self.productArray)
            }, failure:{() in
                print("abc")
            })
        }, failure: {() in
            self.alertShow(title: NSLocalizedString("MessageAlert", comment: ""), meassage: NSLocalizedString("Your account was logged into from a new device or session expired", comment: ""))
        })
    }
/**
    loadChildChange


    - Todo: load trip or driver

    - Author: Quang Tan Dat
**/
    
    @objc func loadChildChange(){
  
    api?.apiGetUserInfo(userType: (userInfoLogin?.userType)!, success: {(json) in
     
        let userInfo = UserInfo.init(json: json)
        self.api?.getTripList(m_province_code: userInfo.provideName, product_group_code: "", rowperPage: "25", page: "0",success:{(json) in
            //    self.hideActivity()
            let result = json["result"] as! NSArray
            for i in result{
                let tripInfo = TripModel.init(json: i as! [String : Any])
              tripArray?.append(tripInfo)
            }
            
            self.tempTripArray = tripArray!
            self.collectionViewData.reloadData()
        }, failure:{() in
            
        })
    }, failure: {() in
        self.alertShow(title: NSLocalizedString("MessageAlert", comment: ""), meassage: NSLocalizedString("Your account was logged into from a new device or session expired", comment: ""))
    })
    }
/**
    check()


    - Todo: check network

    - Author: Quang Tan Dat

    - Returns: Boolean
**/
    
    func check()->Bool{
        guard let r = reachability else {
            return false
        }
        if r.isReachable  {
            return true
        } else {
            return false
        }
    }
/**
     check()
     
     
     - Todo: check network
     
     - Author: Quang Tan Dat
     
     - Returns: Boolean
**/
    @objc func checkInternet(_:NSNotification) {
        if check(){
            hideActivity()
        }
        else{
                self.alertShow(title: NSLocalizedString("MessageAlert", comment: ""), meassage: NSLocalizedString("No internet connection. Please try again !", comment: ""))
           showActivity()
        
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        ref?.removeAllObservers()
        player = nil
        player?.stop()
    }
/**
    settingViewTap

    - Parameter _: NSNotification

    - Todo: setting view tap action

    - Author: Quang Tan Dat
**/
    
@objc func settingViewTap(_:NSNotification){
    let storyBoardSetting = UIStoryboard(name: "Setting", bundle: nil)
    let settingView = storyBoardSetting.instantiateViewController(withIdentifier: "SettingNaV")
    self.present(settingView, animated: true, completion: nil)
    }
/**
    driverViewTap

    - Parameter _: NSNotification

    - Todo: driver menu action tap

    - Author: Quang Tan Dat
**/

    @objc func driverViewTap(_:NSNotification){
   collectionViewData.isUserInteractionEnabled = false
        collectionViewData.setContentOffset(self.collectionViewData.contentOffset, animated: false)
        allView.isHidden = false
        trialView.isHidden = true
        VerifySpedingView.isHidden = true
        VerifiedView.isHidden = true
        activatedView.isHidden = true
        deactivatedView.isHidden = true
        scrollViewHeight.constant = 51
         self.driverArray?.removeAll()
      
        pageIncrease = 0
        self.txtTitle.text = NSLocalizedString("DRIVER MANAGER", comment: "")
        isDriver = true
        api?.apiGetUserInfo(userType: (userInfoLogin?.userType)!, success: {(json) in
            let userInfo = UserInfo.init(json: json)
            self.api?.apiGetDriverList(m_company_id: userInfo.m_company_id, userType: (self.userInfoLogin?.userType)!, product: "", search: "", status: "", page: "0", rowperPage: "25", success: {(json) in
                
            let result = json["result"] as! NSArray
            for i in result{
            let driverInfo = DriverModel.init(json: i as! [String : Any])
            self.driverArray?.append(driverInfo)
            }
                self.tempDriverArray = self.driverArray!
                self.collectionViewData.isUserInteractionEnabled = true
            self.collectionViewData.reloadData()
         
                
            }, failure:{() in
            
            })
            }, failure: {() in
                self.alertShow(title: NSLocalizedString("MessageAlert", comment: ""), meassage: NSLocalizedString("Your account was logged into from a new device or session expired", comment: ""))
            })
        
       
    }
/**
     tripViewTap
     
     - Parameter _: NSNotification
     
     - Todo: trip menu action tap
     
     - Author: Quang Tan Dat
**/
    @objc func tripViewTap(_:NSNotification){
   //     showActivity()
        collectionViewData.isUserInteractionEnabled = false
        scrollViewHeight.constant = 0
        tripArray?.removeAll()
       
        pageIncrease = 0
        self.txtTitle.text = NSLocalizedString("TRIP MANAGER",comment: "")
        isDriver = false
        api?.apiGetUserInfo(userType: (userInfoLogin?.userType)!, success: {(json) in
            let userInfo = UserInfo.init(json: json)
            self.api?.getTripList(m_province_code: userInfo.provideName, product_group_code: "", rowperPage: "25", page: "0",success:{(json) in
           
            let result = json["result"] as! NSArray
            for i in result{
                let tripInfo = TripModel.init(json: i as! [String : Any])
                tripArray?.append(tripInfo)
            }
                self.collectionViewData.isUserInteractionEnabled = true
  //          self.hideActivity()
            self.collectionViewData.reloadData()
           
           
            
        },failure:{() in
            self.alertShow(title: NSLocalizedString("MessageAlert", comment: ""), meassage: NSLocalizedString("Your account was logged into from a new device or session expired", comment: ""))
        })
        }, failure: {() in
            self.alertShow(title: NSLocalizedString("MessageAlert", comment: ""), meassage: NSLocalizedString("Your account was logged into from a new device or session expired", comment: ""))
        })
    }
    override func viewWillAppear(_ animated: Bool) {
 //       print(tripArray?.count)
       //hideActivity()
        tripArray?.removeAll()
        api?.apiGetUserInfo(userType: (userInfoLogin?.userType)! , success: {(json) in
            self.userInfo = UserInfo.init(json: json)
           
        }, failure: {() in
           self.alertShow(title: NSLocalizedString("MessageAlert", comment: ""), meassage: NSLocalizedString("Your account was logged into from a new device or session expired", comment: ""))
        })
        loadChildChange()
        loadProduct()
 NotificationCenter.default.addObserver(self, selector: #selector(tripViewTap(_:)), name: NSNotification.Name(rawValue: "tripTap"), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(driverViewTap(_:)), name: NSNotification.Name(rawValue: "driverTap"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(close(_:)), name: NSNotification.Name(rawValue: "logOutTap"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(settingViewTap(_:)), name: NSNotification.Name(rawValue: "settingViewTap"), object: nil)
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        ref?.queryOrderedByKey().queryEnding(atValue: "request").queryLimited(toLast: 2).observe(.childAdded, with: { snapshot in
           
            var valueSnap = snapshot.value as! [String:Any]
            let provineName = self.userInfo?.provideName
            if (provineName != nil){
                if (valueSnap["m_province_code"] as? String ==  (self.userInfo?.provideName) ){
                    if valueSnap["request_time"] as? String !=
                        (self.tempTripArray.first?.request_time) {
                        tripArray?.removeAll()
                self.loadChildChange()
                    self.playSound()
                    }
            }
            }
        })
        ref?.queryOrderedByKey().queryEnding(atValue: "request").queryLimited(toLast: 2).observe(.childChanged, with: { snapshot in
           // print("changed:")
            var valueSnap = snapshot.value as! [String:Any]
            let provineName = self.userInfo?.provideName
            if (provineName != nil){
                if (valueSnap["m_province_code"] as? String ==  (self.userInfo?.provideName) ){
                tripArray?.removeAll()
            
            self.loadChildChange()
                    
                }
            }
        })
    }
    
  

    func alertShow(title:String, meassage:String){
        let actionNO = UIAlertAction(title: "Ok", style: .cancel, handler: {(action:UIAlertAction) in
        })
        CommonClass.showAlert(title, message:meassage, actions:[actionNO],viewController: self)
    }
    @objc func close(_:NSNotification) {
       
       
       self.dismiss(animated: true, completion: nil)
       
    }
   
    @IBAction func buttonMenu_Pressed(_ sender: Any) {
        self.leftMenuView?.isHidden = false
        self.moveMenuLeftView()
        collectionViewData.setContentOffset(self.collectionViewData.contentOffset, animated: false)
    }
}

extension TripManagementViewController {
    fileprivate func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.hideMenuLeftView), name: NSNotification.Name(rawValue: "hideMenuLeftView"), object: nil)
    }
    
    
    fileprivate func addNibFile() {
        self.leftMenuView = UINib(nibName: "LeftMenuView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? LeftMenuView
        self.leftMenuView?.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(leftMenuView!)
        self.leftMenuView?.isHidden = true
        
        self.animationNibFile()
    }
    
    private func animationNibFile() {
        leftMenuView?.viewMenu.layer.transform = CATransform3DMakeTranslation(-500, 0, 0)
        leftMenuView?.viewBlur.alpha = 0.0
    }
    
    fileprivate func moveMenuLeftView() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.leftMenuView?.viewMenu.layer.transform = CATransform3DIdentity
            
            self.leftMenuView?.viewBlur.alpha = 0.7
        }, completion: {(Bool) in
            self.api?.apiGetUserInfo(userType: (self.userInfoLogin?.userType)!, success: {(json) in
                self.leftMenuView?.txtName.text = json["first_name"] as? String
            }, failure: {() in
                
            })
        })
    }
    func showActivity() {
        activityView = UIButton(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        activityView?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        activityView?.alpha = 0.4
        
        let progressActivity =
            
            commonClass.progressBarDisplayer(msg : NSLocalizedString("Loading...", comment: ""), true, view : self.view)
        
        activityView?.addSubview(progressActivity)
         self.view.isUserInteractionEnabled = false
        view.addSubview(activityView!)
    }
    
    func hideActivity() {
        self.activityView?.isHidden = true
        self.activityView = nil
        self.view.isUserInteractionEnabled = true
    }
    
    @objc func hideMenuLeftView() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.leftMenuView?.viewMenu.layer.transform = CATransform3DMakeTranslation(-500, 0, 0)
            self.leftMenuView?.viewBlur.alpha = 0.0
        }) { (finished) in
            self.leftMenuView?.isHidden = true
        }
    }
}
extension TripManagementViewController:UICollectionViewDataSource{
  
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if(isDriver){ 
            if indexPath.item == tempDriverArray.count{
            
        }
    }
        else{
            if indexPath.item == tempTripArray.count{
           
            }
        }
    }
    
    public func
         collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if (isDriver){
          
            layoutFlow.itemSize.height = 90
            layoutFlow.minimumLineSpacing = 10
            layoutFlow.sectionInset.left = 12
            layoutFlow.sectionInset.right = 12
            return tempDriverArray.count

           
        }
        else{
            layoutFlow.itemSize.height = 200
            layoutFlow.minimumLineSpacing = 10
            layoutFlow.sectionInset.left = 12
            layoutFlow.sectionInset.right = 12
            return tempTripArray.count
        }
    }
     public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
     {
        if(isDriver){
            let cell  = collectionViewData.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DriverCollectionCellCollectionViewCell
            
            
            if(cell.frame.size.width >= self.view.frame.size.width){
                cell.frame.size.width = cell.frame.size.width - (cell.frame.size.width - self.view.frame.size.width + 20 )
                cell.frame.origin.x = 10
            }
            cell.txtName.text = tempDriverArray[indexPath.row].first_name
            cell.lblTypeDriver.text =  (tempDriverArray[indexPath.row].name_lo)!
            cell.lblCreateDate.text =  (tempDriverArray[indexPath.row].mobile)!
            cell.lblID.text = (tempDriverArray[indexPath.row].id)!
            return cell
           // }
        }
        else{
            
            let nib = UINib(nibName: "TripCollectionViewCell", bundle: nil);
            self.collectionViewData.register(nib, forCellWithReuseIdentifier: "TripCell")
     
            let cell  = collectionViewData.dequeueReusableCell(withReuseIdentifier: "TripCell", for: indexPath) as! TripCollectionViewCell
            
            if(cell.frame.size.width >= self.view.frame.size.width){
            cell.frame.size.width = cell.frame.size.width - (cell.frame.size.width - self.view.frame.size.width + 20 )
            cell.frame.origin.x = 10
            }
            
             let object = tempTripArray[indexPath.row]
               
                    cell.txtName.text = TripModel.status[object.status!]
           
              switch(cell.txtName.text!){
              case "Waiting":
                    cell.txtName.backgroundColor = UIColor.init(red: 243/255, green: 156/255, blue: 18/255, alpha: 1)

              case "On driving":
                cell.txtName.backgroundColor = UIColor.init(red: 51/255, green: 122/255, blue: 183/255, alpha: 1)

              case "Complete":
                cell.txtName.backgroundColor = UIColor.init(red: 0/255, green: 166/255, blue: 90/255, alpha: 1)

              case "Cancel":
                cell.txtName.backgroundColor = UIColor.init(red: 221/255, green: 75/255, blue: 57/255, alpha: 1)

              case "On driving":
                 cell.txtName.backgroundColor = UIColor.init(red: 0/255, green: 192/255, blue: 239/225, alpha: 1)
              case "Booking":
                cell.txtName.backgroundColor = UIColor.init(red: 243/255, green: 156/255, blue: 18/255, alpha: 1)
              default:
                break
            }
            
            cell.lblDiscount.text = "- " + commonClass.convertDoubleToCurrency(number: (object.promo_cost! as NSNumber)) + " VND"
            cell.labelDistance.text = object.distance! + "km"
            cell.lblFare.text = commonClass.convertDoubleToCurrency(number: (object.estimate_fare! as NSNumber)) + " VND"
            if  (object.request_type == "0"){
            cell.lblDate.text = self.commonClass.changeToVietnamDate(value: object.request_time!)
            }
            else {
                cell.lblDate.text = self.commonClass.changeToVietnamDate(value: object.pick_up_time!)
            }
            cell.txtStart.text = object.end_address
            cell.txtDes.text = object.start_address
            for pointer in productArray{
                if(pointer.m_product_province_id == object.m_product_province_id){
                cell.lblType.text = pointer.name_en
                }
            }
            
            return cell
        }
        
    }
    
}
extension TripManagementViewController:UICollectionViewDelegate{
   
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        var lastItem = 0
        if(isDriver){
         lastItem = (driverArray?.count)! - 1
        }
        else{
         lastItem = (tripArray?.count)! - 1
        }
        
        if indexPath.row == lastItem{
            if(isDriver){
                
                pageIncrease += 1
                api?.apiGetUserInfo(userType: (userInfoLogin?.userType)!, success: {(json) in
                    let userInfo = UserInfo.init(json: json)
                    self.api?.apiGetDriverList(m_company_id: userInfo.m_company_id, userType: (self.userInfoLogin?.userType)!, product: "", search: "", status: self.loadMoreStatus, page: "\(self.pageIncrease)", rowperPage:"25", success: {(json) in
                        
                        let result = json["result"] as! NSArray
                        for i in result{
                            let driverInfo = DriverModel.init(json: i as! [String : Any])
                            self.driverArray?.append(driverInfo)
                        }
                        self.tempDriverArray = self.driverArray!
                        self.collectionViewData.reloadData()
                    
                    }, failure:{() in
                    })
                }, failure: {() in
                })
            }
            else{
                
                pageIncrease += 1
                api?.apiGetUserInfo(userType: (userInfoLogin?.userType)!, success: {(json) in
                    let userInfo = UserInfo.init(json: json)
                    self.api?.getTripList(m_province_code: userInfo.provideName, product_group_code: "", rowperPage: "25", page: "\(self.pageIncrease)",success:{(json) in
                        
                        let result = json["result"] as! NSArray
                        for i in result{
                            let tripInfo = TripModel.init(json: i as! [String : Any])
                            tripArray?.append(tripInfo)
                        }
                        self.tempTripArray = tripArray!
                        self.collectionViewData.reloadData()
                    }, failure:{() in
                    })
                }, failure: {() in
                })
            }
        }
      
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(isDriver){
            let driverInfo = driverArray![indexPath.row]
            let storyBoardSetting = UIStoryboard(name: "DriverDetail", bundle: nil)
            let settingView = storyBoardSetting.instantiateViewController(withIdentifier: "DriverNav") as! DriverNavigationViewController
            settingView.driverInfoDetail = driverInfo
            self.present(settingView, animated: true, completion: nil)
        }
        else{
           
            if let tripInfo = tripArray?[indexPath.row]{
            let storyBoardSetting = UIStoryboard(name: "DetailTrip", bundle: nil)
            let settingView = storyBoardSetting.instantiateViewController(withIdentifier: "TripNav") as! TripNavigationViewController
            settingView.tripInfoDetail = tripInfo
            self.present(settingView, animated: true, completion: nil)
            }
        }
    }
}

