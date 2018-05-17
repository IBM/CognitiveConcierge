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

import UIKit
import Foundation
import AssistantV1
import TextToSpeechV1

class EntertainmentOptionsViewController: UIViewController {
    
    /// UIViews
    @IBOutlet weak var entertainmentCollectionView: UICollectionView!
    @IBOutlet var gestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var label: UILabel!
    
    var convoContext: Context?
    var greeting: String?
    var tts: TextToSpeech!
    
    // To use for Watson conversation service
    private var convoService: Assistant!
    private var workspaceID: String?
    
    private let kNavigationBarTitle = "Watson Recommendations"
    fileprivate let kCellCount = 3
    private let kLabelText = "WHAT CAN I HELP YOU FIND?"
    fileprivate let kRestaurantLabelText = "RESTAURANTS"
    fileprivate let kVacationsLabelText = "VACATIONS"
    fileprivate let kShowsLabelText = "SHOWS"
    private let kConversationErrorCode = -6004
    private let kInternetErrorCode = -10049

    private let kInternetAlertTitle = "No Internet Connection"
    private let kInternetAlertMessage = "Make sure your device is connected to the internet."
    private let kCredentialsAlertTitle = "Conversation Service Unavailable"
    private let kCredentialsAlertMessage = "Please make sure you entered your Conversation service credentials correctly."
    fileprivate let kRestaurantsAlertTitle = "Please Note"
    fileprivate let kRestaurantsAlertMessage = "This is a demo application for restaurant suggestions only. Feel free to pull and add the functionality for other tiles."
    
    override func viewDidLoad() {
        // Get Watson configuration values
        guard let configurationPath = Bundle.main.path(forResource: "CognitiveConcierge", ofType: "plist") else {
            print("problem loading configuration file CognitiveConcierge.plist")
            return
        }
        let configuration = NSDictionary(contentsOfFile: configurationPath)
        //workspaceID = workspaceID(configuration?["ConversationWorkspaceID"] as! String)
        workspaceID = (configuration?["ConversationWorkspaceID"] as! String)
        convoContext = nil
        
        // Instantiating to start first conversation with Watson.
        convoService = Assistant(username: configuration?["ConversationUsername"] as! String, password: configuration?["ConversationPassword"] as! String, version: configuration?["ConversationVersion"] as! String)
        
        // Instantiating to start text to speech service.
        tts = TextToSpeech(username: configuration?["TextToSpeechUsername"] as! String, password: configuration?["TextToSpeechPassword"] as! String)
        
        /// Assign Collection View dataSource and delegate to self UIViewController
        entertainmentCollectionView.dataSource = self
        self.entertainmentCollectionView.delegate = self

        /// Identify which nib to use for the collectionView
        let nib = UINib(nibName: "EntertainmentCollectionViewCell", bundle: nil)
        self.entertainmentCollectionView.register(nib, forCellWithReuseIdentifier: "entertainmentCell")
        
        // Set the label text and spacing
        label.text = kLabelText
        label.font = UIFont.boldSFNSDisplay(size: 15)
        label.addTextSpacing(spacing: 3.7)
        
        // Set up the navigation bar and buttons.
        Utils.setupDarkNavBar(viewController: self, title: kNavigationBarTitle)
        Utils.setNavigationItems(viewController: self, rightButtons: [MoreIconBarButtonItem()], leftButtons: [ProfileBarButtonItem()])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        /// Re-enable gesture recognizer to allow users to choose tiles again.
        gestureRecognizer.isEnabled = true
        
        // Set up nvaigation bar and buttons
        Utils.setupDarkNavBar(viewController: self, title: kNavigationBarTitle)
        self.navigationController?.isNavigationBarHidden = false
        Utils.setNavigationItems(viewController: self, rightButtons: [MoreIconBarButtonItem()], leftButtons: [ProfileBarButtonItem()])
        Utils.setupNavigationTitleLabel(viewController: self, title: kNavigationBarTitle, spacing: 1.0, titleFontSize: 17, color: UIColor.white)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    /** When a collection cell item is pressed, call the Watson Conversation services to begin
     the conversation. */
    func collectionCellPressed() {

        guard let id = workspaceID else {
            NSLog ("no id or context found")
            gestureRecognizer.isEnabled = true
            return
        }
        
        // Call conversation service for Watson to initiate conversation.
        let request = MessageRequest(input: InputData.init(text:"Hi"))
        let failure = { (error: Error) in
            // Alert user to connect to internet
            self.alertUserWithMessage(title: "Error", message: "\(error)")
            self.gestureRecognizer.isEnabled = true
            
            NSLog ("error generated when sending message to service: \(error)")
        }
        convoService.message(workspaceID: id, request: request, failure: failure) { dataResponse in
            // Save the Watson's greeting response.
            self.greeting = dataResponse.output.text[0]
            
            // Save the conversation context to pass to MessagesVC
            self.convoContext = dataResponse.context
            
            // Perform segue once necessary information is grabbed.
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "toHello", sender: nil)
            }
        }
    }
    
    // Show alert to connect device to internet.
    func alertUserWithMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    // Pass the key words from watson to restaurants view controller.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let messagesVC = segue.destination as? MessagesViewController {
            
            // Make sure we have the necessary conversation instantiation variables
            guard let id = self.workspaceID else {
                NSLog ("no workspace id to give to MessagesVC")
                return
            }
            
            // Make sure we have the greeting for Watson to give
            guard let greeting = self.greeting else {
                NSLog ("no greeting found")
                return
            }
            
            // Pass context and workspace ID
            messagesVC.setupViewModel()
            messagesVC.viewModel.watsonContext = convoContext
            messagesVC.viewModel.workspaceID = id

            messagesVC.viewModel.tts = self.tts
            messagesVC.viewModel.convoService = self.convoService
            // Call to JSQMessage to display Watson's greeting in a text bubble.
            messagesVC.viewModel.storeWatsonReply(date: Date(), output: greeting)
            messagesVC.viewModel.synthesizeText(text: greeting)
        }
    }
}

// MARK: CollectionView for Entertainment Options
extension EntertainmentOptionsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return kCellCount
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "entertainmentCell", for: indexPath) as! EntertainmentCollectionViewCell
        cell.entertainmentNameLabel.font = UIFont.boldSFNSDisplay(size: 12)

        switch indexPath.item {
        case 0:
            cell.entertainmentImage.image = UIImage(named:"restaurants")
            cell.entertainmentNameLabel.text = kRestaurantLabelText
            cell.entertainmentNameLabel.addTextSpacing(spacing: 3.2)
        case 1:
            cell.entertainmentImage.image = UIImage(named:"vacation")
            cell.entertainmentNameLabel.text = kVacationsLabelText
            cell.entertainmentNameLabel.addTextSpacing(spacing: 3.2)
        case 2:
            cell.entertainmentImage.image = UIImage(named:"shows")
            cell.entertainmentNameLabel.text = kShowsLabelText
            cell.entertainmentNameLabel.addTextSpacing(spacing: 3.2)
        default:
            break
        }
        return cell
    }
    
    @IBAction func handleGestureRecognizer(_ sender: AnyObject) {
        if gestureRecognizer.state != UIGestureRecognizerState.ended {
            return
        }
        
        let p = gestureRecognizer.location(in: entertainmentCollectionView)
        let indexPath = entertainmentCollectionView.indexPathForItem(at: p)
        
        if let index = indexPath {
            // Disable other clicks
            gestureRecognizer.isEnabled = false
            switch index.row {
            case 0:
                // Restaurants clicked
                collectionCellPressed()
            case 1:
                // Vacations clicked
                alertUserWithMessage(title: kRestaurantsAlertTitle, message: kRestaurantsAlertMessage)
                gestureRecognizer.isEnabled = true;
            case 2:
                // Shows clicked
                alertUserWithMessage(title: kRestaurantsAlertTitle, message: kRestaurantsAlertMessage)
                gestureRecognizer.isEnabled = true;
            default:
                break
            }
        } else {
            //print("Could not find index path")
        }
    }
}

extension EntertainmentOptionsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.size.width

        let cellSpacing = (collectionView.frame.size.height * (25/451))/2
        let cellHeight = (collectionView.frame.size.height - (2 * cellSpacing))/3

        return CGSize(width: cellWidth, height: cellHeight)
    }
}
