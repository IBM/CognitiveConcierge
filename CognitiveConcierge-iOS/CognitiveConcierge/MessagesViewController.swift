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
import JSQMessagesViewController
import ConversationV1
import TextToSpeechV1
import SpeechToTextV1
import AVFoundation

class MessagesViewController: JSQMessagesViewController {
    
    @IBOutlet weak var backButton: UIButton!
    private var keepChattingBtn: UIButton!
    private var seeRestaurantsBtn: UIButton!
    private var borderView: UIView!
    private var questionLabel: UILabel!
    private var microphoneImage: UIImage!
    private var microphoneButton: UIButton!
    private var sendButton: UIButton!
    private var displayName: String!
    private var decisionsView : DecisionsView?
    private var decisionsViewBottomSpacingConstraint : NSLayoutConstraint!
    private var defaultDecisionsViewBottomSpacingConstraintConstant : CGFloat!
    var location:CLLocation!
    
    var viewModel: MessagesViewModel!
    
    // Flag to determine when to show buttons.
    var reachedEndOfConversation = false
    
    private var locationManager:CLLocationManager = CLLocationManager()
    
    // Watson Speech to Text Variables
    private var stt: SpeechToText?
    private var recorder: AVAudioRecorder?
    private var isStreamingDefault = false
    private var stopStreamingDefault: (Void -> Void)? = nil
    private var isStreamingCustom = false
    private var stopStreamingCustom: (Void -> Void)? = nil
    private var captureSession: AVCaptureSession? = nil
    
    /// Acts as a store for messages sent and received.
    private var incomingBubble: JSQMessagesBubbleImage = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor.customAzureColor())
    private var outgoingBubble: JSQMessagesBubbleImage = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.customPaleGrayColor())
    
    let kBackButtonTitle: String = "BACK"
    private let kCollectionViewCellHeight: CGFloat = 12.5
    private let kSendText: String = "SEND"
    private let kPlaceholderText: String = "Speak or type a request"
    private let kKeepChattingButtonTitle: String = "Keep Chatting"
    private let kSeeRestaurantsButtonTitle: String = "See Restaurants"
    private let kQuestionLabelText: String = "WHAT WOULD YOU LIKE TO DO?"
    private let kSegueIdentifier: String = "toRestaurants"
    
    private var isKeyboardShowing:Bool = false
    private var keyboardHeight:CGFloat = 0.0
    
    override func viewDidLoad() {
        // Hide the navigation bar upon loading.
        self.navigationController?.navigationBarHidden = true
        
        super.viewDidLoad()
        
        //set up text bubbles for JSQMessages
        setupTextBubbles()
        
        //add microphone image, send button, textfield to toolbar
        customizeContentView()
        
        //Reload collectionview and layout
        self.collectionView?.reloadData()
        self.collectionView?.layoutIfNeeded()
        
        //setup navigation
        setupNavigation()
        
        //instantiate watson Speech to Text
        instantiateSTT()
        
        setupLocationServices()
        
        subscribeToDecisionButtonNotifications()
        
        setupDecisionsView()
        
        self.inputToolbar.contentView.textView.becomeFirstResponder()
    }
    
    override func viewWillAppear(animated: Bool) {
        Utils.setupLightNavBar(self, title: Utils.kNavigationBarTitle)
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.translucent = false
        Utils.setNavigationItems(self, rightButtons: [], leftButtons: [PathIconBarButtonItem(), UIBarButtonItem(customView: backButton)])
        Utils.setupNavigationTitleLabel(self, title: Utils.kNavigationBarTitle, spacing: 2.9, titleFontSize: 11, color: UIColor.blackColor())
        setupLocationServices()
        //Subscribe to when keyboard appears and hides
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        self.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = nil
        locationManager.stopUpdatingLocation()
        removeKeyboardNotifications()
    }
    
    @IBAction func didPressBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func setupViewModel() {
        viewModel = MessagesViewModel.sharedInstance
        viewModel.messages = []
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
        self.microphoneButton.enabled = false
        startStreaming()
    }
    
    private func didReleaseMicrophoneButton(sender: UIButton) {
    }
    
    private func customizeContentView() {
        setupMicrophone()
        setupSendButton()
        self.inputToolbar.contentView.backgroundColor = UIColor.whiteColor()
        self.inputToolbar.contentView.borderColor = UIColor.blackColor()
        self.inputToolbar.contentView.textView.borderColor = UIColor.whiteColor()
        self.inputToolbar.contentView.textView.placeHolder = kPlaceholderText
        self.inputToolbar.contentView.textView.font = UIFont.regularSFNSDisplay(size: 15)
        
        // Create a border around the text field.
        Utils.addBorderToEdge(self.inputToolbar.contentView.textView, edge: UIRectEdge.Left, thickness: 2.0, color: UIColor.customBlueGrayColor())
        Utils.addBorderToEdge(self.inputToolbar.contentView.textView, edge: UIRectEdge.Right, thickness: 1.0, color: UIColor.customBlueGrayColor())
    }
    
    private func setupNavigation() {
        Utils.setupBackButton(backButton, title: kBackButtonTitle, textColor: UIColor.customGrayColor())
        Utils.setupLightNavBar(self, title: Utils.kNavigationBarTitle)
        Utils.setNavigationItems(self, rightButtons: [], leftButtons: [UIBarButtonItem(customView: backButton)])
        self.navigationController?.navigationBarHidden = false
    }
    
    private func setupTextBubbles() {
        /// Properties defined in JSQMessages
        senderId = User.Hoffman.rawValue
        senderDisplayName = getName(User.Hoffman)
        collectionView?.collectionViewLayout.incomingAvatarViewSize = CGSize(width: 28, height:32 )
        collectionView?.collectionViewLayout.outgoingAvatarViewSize = CGSize(width: 37, height:37 )
        automaticallyScrollsToMostRecentMessage = true
    }
    
    /** Method to setup location services to determine user's current location. */
    private func setupLocationServices() -> CLLocationManager {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        switch CLLocationManager.authorizationStatus() {
        case .AuthorizedWhenInUse, .AuthorizedAlways:
            locationManager.startUpdatingLocation()
        case .NotDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .Restricted, .Denied:
            break
            // tell users to enable access in settings
        }
        return locationManager
    }
    
    private func instantiateSTT() {
        // identify credentials file
        let bundle = NSBundle(forClass: self.dynamicType)
        // load credentials file
        guard let credentialsURL = bundle.pathForResource("CognitiveConcierge", ofType: "plist") else {
            return
        }
        let dict = NSDictionary(contentsOfFile: credentialsURL)
        guard let credentials = dict as? Dictionary<String, String>,
            let user = credentials["SpeechToTextUsername"],
            let password = credentials["SpeechToTextPassword"]
            else {
                return
        }
        
        stt = SpeechToText(username: user, password: password)
    }
    
    private func setupMicrophone() {
        microphoneImage = UIImage(named: "microphone")
        microphoneButton = UIButton(type: UIButtonType.Custom)
        microphoneButton.setImage(microphoneImage, forState: UIControlState.Normal)
        microphoneButton.frame = CGRectMake(18, 683, 14.5, 22)
        self.inputToolbar.contentView.leftBarButtonItem = microphoneButton
    }
    
    private func startStreaming() {
        var settings = RecognitionSettings(contentType: .Opus)
        settings.continuous = false
        settings.interimResults = true
        
        // ensure SpeechToText service is up
        guard let stt = stt else {
            print("SpeechToText not properly set up.")
            return
        }
        let failure = { (error: NSError) in print(error) }
        stt.recognizeMicrophone(settings, failure: failure) { results in
            self.inputToolbar.contentView.textView.text = results.bestTranscript
            self.sendButton.enabled = true
            stt.stopRecognizeMicrophone()
            self.microphoneButton.enabled = true
        }
    }
    
    private func changeCollectionBottomInset(bottom bottom: CGFloat) {
        let collectionViewLayout = collectionView.collectionViewLayout
        collectionViewLayout?.invalidateLayout()
        collectionViewLayout?.sectionInset = UIEdgeInsetsMake(0, 0, bottom, 0)
    }
    
    private func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(MessagesViewController.keyboardWillAppear(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(MessagesViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    @objc private func keyboardWillAppear (notification: NSNotification) {
        let keyboardHeightTest = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue().size.height

        // Push up decisions view frame by the keyboard height amount
        if (isKeyboardShowing == false) {
            isKeyboardShowing = true
            keyboardHeight = ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue().size.height)!
            self.decisionsViewBottomSpacingConstraint.constant = decisionsViewBottomSpacingConstraint.constant - keyboardHeight
            self.view.layoutIfNeeded()
        } else {
            if (keyboardHeightTest > keyboardHeight) {
                self.decisionsViewBottomSpacingConstraint.constant += keyboardHeight
                self.decisionsViewBottomSpacingConstraint.constant -= keyboardHeightTest!
            }
        }
        // Push up collection view by decisions view height
        changeCollectionBottomInset(bottom: decisionsView!.frame.height)
    }
    
    @objc private func keyboardWillHide (notification: NSNotification) {
        // Push up decisions view frame by the keyboard height amount
        if (isKeyboardShowing == true) {
            isKeyboardShowing = false;
            self.decisionsViewBottomSpacingConstraint.constant = defaultDecisionsViewBottomSpacingConstraintConstant
            self.view.layoutIfNeeded()
        }
        // Push up collection view by decisions view height
        changeCollectionBottomInset(bottom: decisionsView!.frame.height)
    }
    
    private func hideDecisionsView() {
        decisionsView!.hidden = true
        self.sendButton.enabled = true
    }
    
    private func showDecisionsView() {
        decisionsView!.hidden = false
        
    }
    private func setupDecisionsView() {
        decisionsView = DecisionsView.instanceFromNib() ?? DecisionsView()
        
        self.view.addSubview(decisionsView!)
        decisionsView?.translatesAutoresizingMaskIntoConstraints = false
        decisionsView?.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
        decisionsView?.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true
        decisionsViewBottomSpacingConstraint = decisionsView?.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: -inputToolbar.frame.height + 5)
        decisionsViewBottomSpacingConstraint.active = true
        defaultDecisionsViewBottomSpacingConstraintConstant = decisionsViewBottomSpacingConstraint.constant
        
        decisionsView?.heightAnchor.constraintEqualToConstant(95).active = true
        hideDecisionsView()
    }
    
    private func setupSendButton() {
        sendButton = UIButton(type: UIButtonType.Custom)
        sendButton.setTitle(kSendText, forState: UIControlState.Normal)
        sendButton.setTitleColor(UIColor.customSendButtonColor(), forState: UIControlState.Normal)
        sendButton.titleLabel?.font = UIFont.boldSFNSDisplay(size: 15)
        sendButton.titleLabel?.addTextSpacing(0.5)
        sendButton.frame = CGRectMake(321.2, 634.5, 45, 17.5)
        self.inputToolbar.contentView.rightBarButtonItem = sendButton
    }
    
    private func subscribeToDecisionButtonNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MessagesViewController.keepChattingButtonPressed(_:)), name: "keepChattingButtonPressed", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MessagesViewController.seeRestaurantsButtonPressed(_:)), name: "seeRestaurantsButtonPressed", object: nil)
    }
    
    @objc private func keepChattingButtonPressed ( object: AnyObject) {
        hideDecisionsView()
        reachedEndOfConversation = false
    }
    
    @objc private func seeRestaurantsButtonPressed (object: AnyObject) {
        self.performSegueWithIdentifier(kSegueIdentifier, sender: nil)
    }
    
    // MARK: JSQMessagesViewController method overrides
    override func didPressSendButton(button: UIButton, withMessageText text: String, senderId: String, senderDisplayName: String, date: NSDate) {
        viewModel.parseConversationResponse(text, date: date, senderId: senderId, senderDisplayName: senderDisplayName){ (reachedEndOfConversation, watsonReply) in
            self.reachedEndOfConversation = reachedEndOfConversation
            self.viewModel.synthesizeText(watsonReply)
            self.finishSendingMessageAnimated(true)
        }
        let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
        viewModel.messages.append(message)
        finishSendingMessageAnimated(true)
    }
    
    // MARK: - Navigation
    
    // Pass the key words from watson to restaurants view controller.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let restaurantsVC = segue.destinationViewController as? RestaurantViewController {
            restaurantsVC.keyWords = self.viewModel.watsonEntities
            restaurantsVC.location = self.location;
            restaurantsVC.timeInput = self.viewModel.timeInput
        }
    }
}

// MARK: - JSQMessagesViewController
extension MessagesViewController {
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView, messageDataForItemAtIndexPath indexPath: NSIndexPath) -> JSQMessageData {
        return viewModel.messages[indexPath.item]
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath) -> JSQMessageBubbleImageDataSource {
        return viewModel.messages[indexPath.item].senderId == self.senderId ? outgoingBubble : incomingBubble
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath) -> JSQMessageAvatarImageDataSource? {
        let message = viewModel.messages[indexPath.item]
        return getAvatar(message.senderId)
    }
    //
    override func collectionView(collectionView: JSQMessagesCollectionView, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath) -> NSAttributedString? {
        if (indexPath.item % 3 == 0) {
            //show a timestamp for every 3rd message
            let message = viewModel.messages[indexPath.item]
            return JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(message.date)
        }
        return nil
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        //show a timestamp for every 3rd message
        if indexPath.item % 3 == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        return kCollectionViewCellHeight
    }
    
    override func collectionView(collectionView: UICollectionView,
                                 cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
            as! JSQMessagesCollectionViewCell
        let message = viewModel.messages[indexPath.item]
        if message.senderId == senderId {
            cell.textView!.textColor = UIColor.blackColor()
        } else {
            cell.textView!.textColor = UIColor.whiteColor()
            if (reachedEndOfConversation && (indexPath.item == (viewModel.messages.count - 1))) {
                /// Add buttons on top of input toolbar.
                showDecisionsView()
            }
        }
        return cell
    }
}

// MARK: - CLLocationManagerDelegate
extension MessagesViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Grab last object to get the most recent updated location and send to backend.
        let theLocation = locations[locations.count-1]
        self.location = theLocation;
        print(self.location)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        locationManager.stopUpdatingLocation()
        print ("Unable to grab location: \(error)")
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if (status == .AuthorizedAlways) || (status == .AuthorizedWhenInUse) {
            locationManager.startUpdatingLocation()
        }
    }
}
