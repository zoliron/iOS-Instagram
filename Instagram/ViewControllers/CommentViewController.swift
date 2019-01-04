//
//  CommentViewController.swift
//  Instagram
//
//  Created by Ronen on 03/01/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class CommentViewController: UIViewController {

    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendButton.isEnabled = false
        handleTextField()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true // Hides the tabBar
    }
    
    @IBAction func sendButton_TouchUpInside(_ sender: Any) {
        let ref = Database.database().reference()
        let commentsReference = ref.child("comments")
        // Creates new random ID for each post
        let newCommentId = commentsReference.childByAutoId().key
        let newCommentReference = commentsReference.child(newCommentId!)
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        let currentUserId = currentUser.uid
        newCommentReference.setValue(["uid": currentUserId, "commentText": commentTextField.text!], withCompletionBlock: { (error: Error?, ref: DatabaseReference) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            self.empty()
        })
    }
    
    func empty() {
        self.commentTextField.text = ""
        sendButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        sendButton.isEnabled = false
    }
    
    // Observer to see if user input did change
    func handleTextField() {
        commentTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
    }
    
    // Checking if the userinputs are not empty and if not changing the Sign Up botton color and enables is
    func textFieldDidChange() {
        // If the comment field has text, enable the button
        if let commentText = commentTextField.text, !commentText.isEmpty {
            sendButton.setTitleColor(UIColor.black, for: UIControlState.normal)
            sendButton.isEnabled = true
            return
        }
        // If the comment field has no text, disable the button
        sendButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        sendButton.isEnabled = false
    }
    
}
