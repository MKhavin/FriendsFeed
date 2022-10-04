//
//  LogInView.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 19.09.2022.
//

import UIKit

class LogInView: UIView {
    //MARK: - UI Elements
    private lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = nil
        view.addSubviews([
            titleLabel,
            subtitleLabel,
            numberTextField
        ])
        return view
    }()
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = nil
        view.addSubviews([
            logInButton,
            privacyLabel
        ])
        return view
    }()
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "Введите номер"
        view.textColor = .label
        view.font = .systemFont(ofSize: 20, weight: .semibold)
        view.textAlignment = .center
        return view
    }()
    private lazy var subtitleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .label
        view.numberOfLines = 0
        view.text = "Введите номер телефона для входа в приложение"
        view.font = .preferredFont(forTextStyle: .title3)
        view.textAlignment = .center
        view.textColor = .placeholderText
        return view
    }()
    private(set) lazy var numberTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "+7__________"
        view.keyboardType = .phonePad
        view.textColor = .black
        view.textAlignment = .center
        view.layer.borderColor = UIColor.label.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 5
        return view
    }()
    private(set) lazy var logInButton: UIButton = {
       let view = UIButton()
        view.setTitle("ДАЛЕЕ", for: .normal)
        view.backgroundColor = .label
        view.setTitleColor(UIColor.systemBackground, for: .normal)
        view.layer.cornerRadius = 5
        return view
    }()
    private lazy var privacyLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 3
        view.text = "Нажимая кнопку “Далее” Вы принимаете пользовательское Соглашение и политику конфедициальности"
        view.textAlignment = .center
        view.textColor = .placeholderText
        view.font = .systemFont(ofSize: 12)
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
        
        
        super.updateConstraints()
    }
    
    //MARK: - Sub methods
    private func getStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [
            topView,
            bottomView
        ])
        
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.axis = .vertical
        
        return stackView
    }
    
    private func setTopViewSubviewsLayout() {
        numberTextField.snp.makeConstraints { make in
            make.bottom.equalTo(topView.layoutMarginsGuide)
            make.leading.trailing.equalTo(topView.layoutMarginsGuide).inset(60)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(numberTextField.snp.top).inset(5)
            make.leading.trailing.equalTo(topView.layoutMarginsGuide).inset(80)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(subtitleLabel.snp.top).inset(2)
            make.leading.trailing.equalTo(topView.layoutMarginsGuide).inset(80)
        }
    }
    
    private func setBottomViewSubviewsLayout() {
        logInButton.snp.makeConstraints { make in
            make.top.equalTo(bottomView.layoutMarginsGuide)
            make.leading.trailing.equalTo(bottomView.layoutMarginsGuide).inset(100)
        }
        
        privacyLabel.snp.makeConstraints { make in
            make.top.equalTo(logInButton.snp.bottom).offset(10)
            make.leading.trailing.equalTo(bottomView.layoutMarginsGuide)
        }
    }
    
    private func setSubviewsLayout() {
        setTopViewSubviewsLayout()
        setBottomViewSubviewsLayout()
        
        let stackView = getStackView()
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(layoutMarginsGuide)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(layoutMarginsGuide)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(layoutMarginsGuide)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        
        numberTextField.snp.makeConstraints { make in
            make.leading.trailing.equalTo(layoutMarginsGuide)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(10)
        }
        
        logInButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(layoutMarginsGuide)
            make.top.equalTo(numberTextField.snp.bottom).offset(20)
        }
        
        privacyLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(layoutMargins)
            make.top.equalTo(logInButton.snp.bottom).offset(5)
        }
    }
}