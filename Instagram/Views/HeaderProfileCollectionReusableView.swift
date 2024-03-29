//
//  HeaderProfileCollectionReusableView.swift
//  Instagram
//
//  Created by Ronen on 04/01/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
protocol HeaderProfileCollectionReusableViewDelegate {
    func updateFollowButton(forUser user: UserModel)
}

protocol HeaderProfileCollectionReusableViewDelegateSwitchSettingVC{
    func goToSettingVC()
}

class HeaderProfileCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var myPostCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    var delegate: HeaderProfileCollectionReusableViewDelegate?
    var delegate2: HeaderProfileCollectionReusableViewDelegateSwitchSettingVC?
    var user: UserModel? {
        didSet {
            updateView()
        }
    }
    
    // Query and display current user information
    func updateView() {
        self.nameLabel.text = user!.username
        if let photoUrlString = user!.profileImageUrl {
            let photoUrl = URL(string: photoUrlString)
            // Uses SDWebimage to download the photo from the url
            self.profileImage.sd_setImage(with: photoUrl)
        }
        //take the data from fetchCountMyPosts- show how many post we upload
        Api.MyPosts.fetchCountMyPosts(userId: user!.id!){ (count) in
            self.myPostCountLabel.text = "\(count)"
        }
        //show how many people we are following
        Api.Follow.fetchCountFollowing(userId: user!.id!){ (count) in
            self.followingCountLabel.text = "\(count)"
        }
        //show how many people followers after me
        Api.Follow.fetchCountFollowers(userId: user!.id!){ (count) in
            self.followersCountLabel.text = "\(count)"
        }
    
        
        //Check if user is the current user or not
        if user?.id == Api.User.CURRENT_USER?.uid{
            followButton.setTitle("Edit Profile", for: UIControl.State.normal)
            followButton.addTarget(self, action: #selector(self.goToSettingVC), for: UIControl.Event.touchUpInside)
        } else {
            updateStateFollowButton()
        }
    }
    @objc func goToSettingVC(){
        delegate2?.goToSettingVC()
    }
    
    func updateStateFollowButton(){
        if user!.isFollowing! == true {
            configureUnFollowButton()
        } else {
            configureFollowButton()
        }
    }
    
    func configureFollowButton(){
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor(red: 226/255, green: 228/255, blue: 232.255, alpha: 1).cgColor
        followButton.layer.cornerRadius = 5
        followButton.clipsToBounds = true
        
        followButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        followButton.backgroundColor = UIColor(red: 69/255, green: 142/255, blue: 255/255, alpha: 1)
        self.followButton.setTitle("Follow", for: UIControl.State.normal)
        followButton.addTarget(self, action: #selector(self.followAction), for: UIControl.Event.touchUpInside)
    }
    func configureUnFollowButton(){
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor(red: 226/255, green: 228/255, blue: 232.255, alpha: 1).cgColor
        followButton.layer.cornerRadius = 5
        followButton.clipsToBounds = true
        
        followButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        followButton.backgroundColor = UIColor.clear
        self.followButton.setTitle("Following", for: UIControl.State.normal)
        followButton.addTarget(self, action: #selector(self.unFollowAction), for: UIControl.Event.touchUpInside)
    }
    
    @objc func followAction(){
        if user!.isFollowing! == false{
            Api.Follow.followAction(withUser: user!.id!)
            configureUnFollowButton()
            user!.isFollowing! = true
            delegate?.updateFollowButton(forUser: user!)
        }
    }
    
    @objc func unFollowAction(){
        if user!.isFollowing! == true{
            Api.Follow.unFollowAction(withUser: user!.id!)
            configureFollowButton()
            user!.isFollowing! = false
            delegate?.updateFollowButton(forUser: user!)
        }
    }
}
