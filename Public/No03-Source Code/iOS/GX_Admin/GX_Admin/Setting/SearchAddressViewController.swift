//
//  SearchAddressViewController.swift
//  GX_Admin
//
//  Created by Quang Dat on 1/17/18.
//  Copyright © 2018 SBT Software. All rights reserved.
//

import UIKit
import GooglePlaces

class SearchAddressViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var textFieldSearch: UITextField!
    @IBOutlet weak var viewResult: UIView!
    @IBOutlet weak var labelWarning: UILabel!
    @IBOutlet weak var tableLoadResult: UITableView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var activitySearch: UIActivityIndicatorView!
    @IBOutlet weak var labelLoading: UILabel!
    @IBOutlet weak var labelChooseDetinationTitle: UILabel!
    @IBOutlet weak var btnPinSearch: UIButton!
    @IBOutlet weak var segmentOption: UISegmentedControl!
    var timerSearch: Timer? = nil
     var placesClient: GMSPlacesClient = GMSPlacesClient()
    var mainAddress: String = ""
    var subAddress: String = ""
    var resultArray: Array<Address> = Array<Address>()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableLoadResult.delegate = self
        tableLoadResult.dataSource = self
         self.textFieldSearch.delegate = self
        // Do any additional setup after loading the view.
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if segmentOption.selectedSegmentIndex == 0 {
            timerSearch?.invalidate()
            timerSearch = Timer.scheduledTimer(timeInterval: 0.3,
                                               target: self,
                                               selector: #selector(SearchAddressViewController.getHints(timer:)),
                                               userInfo: ["textField": textField],
                                               repeats: false)
        } else {
            
        }
        
        return true
    }
    @objc func getHints(timer: Timer) {
        var userInfo = timer.userInfo as! [String: UITextField]
        let userText = userInfo["textField"]
       
       
        
        if userText?.text == "" {
            labelLoading.isHidden = true
            activitySearch.isHidden = true
         //   self.resultArray.removeAll()
            self.tableLoadResult.reloadData()
        } else {
            
            guard let textSearch = userText?.text else { return }
            
            if textSearch.count >= 3 {
                labelLoading.isHidden = false
                activitySearch.isHidden = false
     
                GoogleMapHelper.searchPlace(location: Instance.currentUserPosition, region: "VN", type: "street-address", query: (userText?.text)!, success: { (json) in
                    
                    guard let results = json["results"] as? [[String: Any]] else { return }
                    self.resultArray.removeAll()
                    self.tableLoadResult.reloadData()
                    
                    for result in results {
                        
                        guard let place_id = result["place_id"] as? String else { return }
                        self.getInformationOfPlace(placeID: place_id)
                    }
                })
                
                GoogleMapHelper.searchPlace(location: Instance.currentUserPosition, region: "VN", type: "establishment", query: (userText?.text)!, success: { (json) in
                    
                    guard let results = json["results"] as? [[String: Any]] else { return }
                    self.resultArray.removeAll()
                    self.tableLoadResult.reloadData()
                    
                    for result in results {
                        
                        guard let place_id = result["place_id"] as? String else { return }
                        self.getInformationOfPlace(placeID: place_id)
                    }
                })
            } else {
                
            }
            
        }
    }
    func getInformationOfPlace(placeID: String) {
        self.placesClient.lookUpPlaceID(placeID) { (place, error) in
            if (error != nil) { return }
            guard let place = place else { return }
            print("---------")
            print(place)
            self.mainAddress = place.name
            self.subAddress = place.formattedAddress!
            let coordinate = place.coordinate
            let type = place.types[0]
            
            let newAddress = Address.init(street: self.mainAddress,
                                          subStreet: self.subAddress,
                                          type: type,
                                          lat: coordinate.latitude,
                                          long: coordinate.longitude)
            self.resultArray.append(newAddress)
            self.tableLoadResult.reloadData()
            self.labelLoading.isHidden = true
            self.activitySearch.isHidden = true
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentOption.selectedSegmentIndex == 0 {
            return resultArray.count
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as! ResultCell
        if segmentOption.selectedSegmentIndex == 0 {
            if resultArray[indexPath.row].street == NSLocalizedString("Home", comment: "") {
                cell.setTextForAddress(text: resultArray[indexPath.row].street,
                                       subText: resultArray[indexPath.row].subStreet, image: #imageLiteral(resourceName: "ic_home"))
            }
           
        }
         return cell
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
class ResultCell: UITableViewCell {
    
    @IBOutlet weak var viewShadowContent: UIView!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var imageType: UIImageView!
    @IBOutlet weak var labelAddressInformation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewShadowContent.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        viewShadowContent.layer.shadowOffset = CGSize(width: 5, height: 5)
        viewShadowContent.layer.shadowOpacity = 0.25
        viewShadowContent.layer.shadowRadius = 1.0
        viewShadowContent.layer.masksToBounds = false
        viewShadowContent.layer.cornerRadius = 6.0
    }
    
    func setTextForAddress(text: String, subText: String, image: UIImage) {
        labelAddress.text = text
        labelAddressInformation.text = subText
        imageType.image = image
    }
}
