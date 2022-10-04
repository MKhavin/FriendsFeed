//
//  SMSConfirmationTextFieldView.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 04.10.2022.
//

import UIKit

class SMSConfirmationTextFieldView: UIView {
    private lazy var smsTitleLabel: UILabel = {
        let view = UILabel()
        view.text = "Введите код из SMS"
        view.textColor = .lightGray
        view.textAlignment = .left
        
        return view
    }()
    private(set) lazy var smsCodeTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "------"
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.label.cgColor
        view.layer.borderWidth = 1
        view.textAlignment = .center
        view.layer.cornerRadius = 20
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        addSubviews([
            smsTitleLabel,
            smsCodeTextField
        ])
        
        setSubviewsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setSubviewsLayout() {
        smsCodeTextField.snp.makeConstraints { make in
            make.centerY.equalTo(safeAreaLayoutGuide)
            make.leading.equalTo(safeAreaLayoutGuide).offset(40)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(40)
            make.height.equalTo(50)
        }
        smsTitleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(smsCodeTextField.snp.top).inset(-10)
            make.leading.equalTo(safeAreaLayoutGuide).offset(40)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(40)
        }
    }
}
