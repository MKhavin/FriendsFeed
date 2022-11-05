//
//  ProfileViewController.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 20.10.2022.
//

import UIKit
import SwiftUI

class ProfileViewController: UIViewController {
    var viewModel: ProfileViewModelProtocol!
    private weak var mainView: ProfileView?
    
    override func loadView() {
        let currentView = ProfileView()
        mainView = currentView
        view = mainView
        mainView?.tableView.delegate = self
        mainView?.tableView.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.userDataDidLoaded = { result in
            switch result {
            case .success(let profile):
                if let unwrappedData = profile {
                    self.mainView?.titleView.avatarImageView.getImageFor(imagePath: unwrappedData.avatar ?? "")
                    self.mainView?.titleView.firstNameLabel.text = unwrappedData.firstName
                    self.mainView?.titleView.workNameLabel.text = unwrappedData.lastName
                    self.mainView?.titleView.postsCountLabel.text = "\(unwrappedData.postsCount)\nposts"
                    self.mainView?.titleView.subscriptionsCountLabel.text = "\(unwrappedData.subscriptions)\nsubscriptions"
                    self.mainView?.titleView.usersCountLabel.text = "\(unwrappedData.friends)\nfriends"
                }
            case .failure(let error):
                let alert = UIAlertController(title: "Error occured", message: error.localizedDescription, preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default) { action in
                    self.dismiss(animated: true)
                }
                alert.addAction(action)
                self.present(alert, animated: true)
            }
        }
        viewModel.postsDataDidLoad = { error in
            guard error == nil else {
                let alert = UIAlertController(title: "Error occured", message: error!.localizedDescription, preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default) { action in
                    self.dismiss(animated: true)
                }
                alert.addAction(action)
                self.present(alert, animated: true)
                
                return
            }
            
            self.mainView?.tableView.reloadData()
        }
        viewModel.loadUserData(by: nil)
    }

}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return viewModel.getPostsCount()
        default: return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ItemsIdentifier.profilePhotosCell.rawValue,
                                                                              for: indexPath) as? ProfilePhotosTableViewCell else {
                fatalError()
            }
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ItemsIdentifier.profilePostsCell.rawValue,
                                                                              for: indexPath) as? FeedTableViewCell else {
                fatalError()
            }
            
            let postData = viewModel.getPostData(for: indexPath.row)
            cell.setCell(data: postData)

            return cell
        default: return UITableViewCell()
        }
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            viewModel.pushPhotosView()
        case 1:
            viewModel.pushPostInfo(for: indexPath.row)
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 150
        case 1: return UIScreen.main.bounds.height / 3
        default: return 0
        }
    }
}
