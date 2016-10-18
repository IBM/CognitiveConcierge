/**
 * Copyright IBM Corporation 2016
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

import Foundation
import UIKit
import Freddy

class RestaurantViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var backButton: UIButton!
    
    var theRestaurants: [Restaurant] = []
    var chosenRestaurant: Restaurant?
    var keyWords = [:]
    var timeInput: String?
    
    private var occasion: String?
    private var loadingView : HorizontalOnePartStackView?
    private var onePartStackView : HorizontalOnePartStackView?
    private var mySubview : UIView?
    private var watsonOverlay: WatsonOverlay?
    
    //// Endpoint manager to make API calls.
    private let endpointManager = EndpointManager.sharedInstance
    private let kNavigationBarTitle = "Restaurants"
    private let kBackButtonTitle = "CHAT"
    private let kLocationText = "LAS VEGAS, NV"
    private let kHeightForHeaderInSection:CGFloat = 10
    private let kEstimatedHeightForRowAtIndexPath:CGFloat = 104.0
    private let kNumberOfRowsInTableViewSection = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadKeyWords()

        self.onePartStackView = HorizontalOnePartStackView.instanceFromNib()
        self.setupStackView(true)
        getRestaurantRecommendations(self.occasion!)
        
        // Set up the navigation bar
        Utils.setupDarkNavBar(self, title: kNavigationBarTitle)
        
        // set up navigation items.
        Utils.setNavigationItems(self, rightButtons: [MoreIconBarButtonItem()], leftButtons: [WhitePathIconBarButtonItem(), UIBarButtonItem(customView: backButton)])
        
        self.navigationController?.navigationBarHidden = false

    }
    
    override func viewWillAppear(animated: Bool) {
        Utils.setupDarkNavBar(self, title: kNavigationBarTitle)
        self.navigationController?.navigationBarHidden = false
        Utils.setupBackButton(backButton, title: kBackButtonTitle, textColor: UIColor.whiteColor())
        
        // set up navigation items.
        Utils.setNavigationItems(self, rightButtons: [MoreIconBarButtonItem()], leftButtons: [WhitePathIconBarButtonItem(), UIBarButtonItem(customView: backButton)])
        
        Utils.setupNavigationTitleLabel(self, title: kNavigationBarTitle, spacing: 1.0, titleFontSize: 17, color: UIColor.whiteColor())
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    /** call to Restaurant API to receive recommendations.
     - parameter occasion: user defined setting to look up
    */
    func getRestaurantRecommendations(occasion: String) {
        
        endpointManager.requestRestaurantRecommendations(occasion,
                                                         failure: { mockData in
            self.theRestaurants = mockData
            self.setUpTableView()
            self.setupStackView(false)
        }) { recommendations in
            self.theRestaurants = Utils.parseRecommendationsJSON(recommendations)
            self.setUpTableView()
            self.setupStackView(false)
        }
    }
    
    /**
     Method to setup the table view
     */
    func setUpTableView(){
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        registerNibWithTableView("restaurant", nibName: "RecommendedRestaurantTableViewCell", tableView: self.tableView)

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = kEstimatedHeightForRowAtIndexPath

        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 9
        tableView.sectionFooterHeight = UITableViewAutomaticDimension
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
    }
    
    @IBAction func didPressBackButton(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    /**
     Method registers a nib defined by the identifier String parameter and the nibName String parameter with the tableVIew parameter

     - parameter identifier: String
     - parameter nibName:    String
     - parameter tableView:  UITableView
     */
    func registerNibWithTableView(identifier: String, nibName: String, tableView: UITableView){
        tableView.registerNib(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: identifier)
    }
    
    // MARK - Navigation
    // Pass the key words from watson to restaurants view controller.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let recommendationsVC = segue.destinationViewController as? RestaurantDetailViewController {
            if let restaurant = chosenRestaurant {
                recommendationsVC.chosenRestaurant = restaurant
            } else {
                print("no chosen restaurant found in restaurant VC")
            }
        }
    }
}

/**

 MARK: UITableViewDelegate

 */
extension RestaurantViewController: UITableViewDelegate {
    /**
     Method that defines the action that is taken when a cell of the table view is  selected, in this case we segue to the recommendation detail view controller if the cell selected is at indexPath.row 0

     - parameter tableView: UITableView
     - parameter indexPath: NSIndexPath
     */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        chosenRestaurant = self.theRestaurants[indexPath.section]
        performSegueWithIdentifier("toRecommendationDetail", sender: self)
    }

}

/**

 MARK: UITableViewDataSource

 */
extension RestaurantViewController: UITableViewDataSource {

    /**
     Method that returns the number of section in the table view by asking the view model

     - parameter tableView: UITableView

     - returns: Int
     */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return theRestaurants.count
    }


    /**
     Method that returns the number of rows in the section by asking the view model

     - parameter tableView: UITableView
     - parameter section:   Int

     - returns: Int
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kNumberOfRowsInTableViewSection
    }


    /**
     Method that sets up the cell right before its about to be displayed. In this case we remove the 15 pt separator inset

     - parameter tableView: UITableView
     - parameter cell:      UITableViewCell
     - parameter indexPath: NSIndexPath
     */
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //remove 15 pt separator inset so it goes all the way across width of tableview
        if cell.respondsToSelector(Selector("setSeparatorInset:")) {
            cell.separatorInset = UIEdgeInsetsZero
        }
        if cell.respondsToSelector(Selector("setLayoutMargins:")) {
            cell.layoutMargins = UIEdgeInsetsZero
        }
        if cell.respondsToSelector(Selector("setPreservesSuperviewLayoutMargins:")) {
            cell.preservesSuperviewLayoutMargins = false
        }
        
        UIView.performWithoutAnimation { () -> Void in
            cell.layoutIfNeeded()
        }
    }


    /**
     Method that returns the cell for row at indexPath by asking the view model to set up th cell

     - parameter tableView: UITableView
     - parameter indexPath: NSIndexPath

     - returns: UITableViewCell
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return setUpTableViewCell(indexPath, tableView: tableView)
    }
    
    // space between cells.
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kHeightForHeaderInSection
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.customPaleGrayColor()
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return UITableViewAutomaticDimension
        }
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return kEstimatedHeightForRowAtIndexPath
        }

    /**
     Method that sets up the tableViewCell at the indexPath parameter depending on the type of recommendation type the recommendation is at indexPath

     - parameter indexPath: NSIndexPath
     - parameter tableView: UITableView

     - returns: UITableViewCell
     */
    func setUpTableViewCell(indexPath : NSIndexPath, tableView: UITableView) -> UITableViewCell{
        let myRestaurant = self.theRestaurants[indexPath.section]
        var cell : UITableViewCell = UITableViewCell()
        cell = setupRestaurantRecommendationTableViewCell(indexPath, tableView: tableView, restaurant: myRestaurant)
        return cell
    }

    /**
     Method sets up the tableViewCell at indexPath as a RecommendedRestaurantTableViewCell

     - parameter indexPath:      NSIndexPath
     - parameter tableView:      UITableView
     - parameter recommendation: Event

     - returns: UITableViewCell
     */
    private func setupRestaurantRecommendationTableViewCell(indexPath : NSIndexPath, tableView : UITableView, restaurant : Restaurant) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("restaurant", forIndexPath: indexPath) as! RecommendedRestaurantTableViewCell

        cell.setUpData(
            restaurant.getName(),
            openNowStatus: restaurant.getOpenNowStatus(),
            matchScorePercentage : restaurant.getMatchPercentage(),
            rating: restaurant.getRating(),
            expensiveness: restaurant.getExpense(),
            googleID: restaurant.getGoogleID(),
            image: restaurant.getImage()
        )

        return cell
    }
    
    func setupStackView(isLoading:Bool) {
        if(isLoading) {
            setupLoadingWatsonView()
            
        } else {
            guard let stackView = onePartStackView else {
                return
            }
            let occasionInput = occasion ?? ""
            let time = timeInput ?? ""
            stackView.setUpData(occasionInput.uppercaseString, location: kLocationText, time: time.uppercaseString)
            stackView.frame = CGRectMake(0, 0, self.view.frame.width, bannerView.frame.height)
            bannerView.addSubview(stackView)
            doneLoading()
        }
    }
    func setupLoadingWatsonView() {
        watsonOverlay = WatsonOverlay.instanceFromNib(self.view)
        guard let overlay = watsonOverlay else {
            return
        }
        overlay.showWatsonOverlay(self.view)
    }
    
    func doneLoading () {
        guard let watson = watsonOverlay else {
            return
        }
        watson.hideWatsonOverlay()
    }
    
    /* Load key words received from Watson Conversation services in the MessagesViewController.
     * Currently looks only for "occasions" and "time".
     */
    func loadKeyWords() {
        occasion = keyWords["occasions"] as? String ?? "None"
        timeInput = timeInput ?? "Any Time"
    }
    
    
}
