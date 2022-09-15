//
//  AuthenticationViewModel.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 15.09.2022.
//

protocol AuthenticationViewModelProtocol {
    var coordinator: AppCoordinatorProtocol? { get set }
    func pushRegisterView()
    func pushLogInView()
}

class AuthenticationViewModel: AuthenticationViewModelProtocol {
    var coordinator: AppCoordinatorProtocol?
    
    init(coordinator: AppCoordinatorProtocol?) {
        self.coordinator = coordinator
    }
    
    func pushRegisterView() {
        coordinator?.pushRegisterView()
    }
    
    func pushLogInView() {
        coordinator?.pushLogInView()
    }
}
