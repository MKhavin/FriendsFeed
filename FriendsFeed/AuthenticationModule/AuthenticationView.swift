//
//  AuthenticationView.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 15.09.2022.
//

import UIKit
import SnapKit

final class AuthenticationView: UIView {
    //MARK: - UI Elements
    private lazy var logoImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "LaunchScreenIcon")
        view.contentMode = .scaleAspectFit
        return view
    }()
    private lazy var buttonsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            registerButton,
            logInButton
        ])
        stackView.alignment = .fill
        stackView.spacing = 30
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    private(set) lazy var registerButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .label
        
        view.layer.shadowColor = UIColor.label.withAlphaComponent(0.5).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 1
        
        view.setTitle("ЗАРЕГИСТРИРОВАТЬСЯ", for: .normal)
        view.titleLabel?.font = .preferredFont(forTextStyle: .title1)
        view.titleLabel?.adjustsFontSizeToFitWidth = true
        view.titleLabel?.minimumScaleFactor = 0.2
        view.setTitleColor(UIColor.systemBackground, for: .normal)
        return view
    }()
    private(set) lazy var logInButton: UIButton = {
        let view = UIButton()
        view.setTitle("Уже есть аккаунт", for: .normal)
        view.titleLabel?.font = .preferredFont(forTextStyle: .title3)
        view.setTitleColor(UIColor.label, for: . normal)
        return view
    }()
    
    //MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        setSubviewsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        buttonsStack.snp.updateConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(frame.height/4)
            make.leading.trailing.equalTo(layoutMarginsGuide).inset(frame.width/6)
        }
        registerButton.layer.cornerRadius = frame.height / 100
        
        super.updateConstraints()
    }
    
    //MARK: - Sub methods
    private func setSubviewsLayout() {
        addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(layoutMarginsGuide)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.centerY)
        }
        
        addSubview(buttonsStack)
        buttonsStack.snp.makeConstraints { make in
            make.leading.trailing.equalTo(layoutMarginsGuide).inset(frame.width/6)
            make.top.equalTo(safeAreaLayoutGuide.snp.centerY).offset(40)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(frame.height/4)
        }
    }
}
