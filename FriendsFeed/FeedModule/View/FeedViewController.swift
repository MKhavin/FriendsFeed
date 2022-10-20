//
//  FeedViewController.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 05.10.2022.
//

import UIKit

class FeedViewController: UIViewController {
    //MARK: - UI elements
    private weak var mainView: FeedView?
    
    //MARK: - Sub properties
    var viewModel: FeedViewModelProtocol!
    
    //MARK: - Life cycle
    override func loadView() {
        let feedView = FeedView()
        mainView = feedView
        view = feedView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Главная"
        
        setUpRootView()
        setViewModelCallbacks()
        
        viewModel.getFeed()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setNavigationBarApppearance()
    }
    
    //MARK: - Sub methods
    private func setUpRootView() {
        mainView?.feedTableView.delegate = self
        mainView?.feedTableView.dataSource = self
    }
    
    private func setViewModelCallbacks() {
        viewModel.postLoaded = {
            self.mainView?.feedTableView.reloadData()
        }
    }
    
    private func setNavigationBarApppearance() {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

//MARK: - UITableViewDelegate implementation
extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ItemsIdentifier.feedSectionHeader.rawValue) as? FeedSectionView else {
            return nil
        }
    
        let collectionDate = viewModel.postsCollections[section].date
        header.setCell(data: collectionDate)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        view.frame.height / 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.showPostInfo(in: indexPath.section, of: indexPath.row)
    }
}

//MARK: - UITableViewDataSource implementation
extension FeedViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.postsCollections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.postsCollections[section].posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ItemsIdentifier.feedCell.rawValue, for: indexPath) as? FeedTableViewCell else {
            return UITableViewCell()
        }
        
        cell.setCell(data: viewModel.postsCollections[indexPath.section].posts[indexPath.row])
        return cell
    }
}
