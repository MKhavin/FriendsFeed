//
//  SMSConfirmationBottomView.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 04.10.2022.
//

import UIKit

class SMSConfirmationBottomView: UIView {
    //MARK: - Sub methods
    private(set) lazy var registrationButton: UIButton = {
        let view = UIButton()
        view.setTitle("ЗАРЕГИСТРИРОВАТЬСЯ", for: .normal)
        view.backgroundColor = .label
        view.setTitleColor(UIColor.systemBackground, for: .normal)
        view.layer.cornerRadius = 20
        return view
    }()
    private lazy var imageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "RegistrationIcon"))
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    //MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        addSubviews([
            registrationButton,
            imageView
        ])
        setSubviewsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
//        registrationButton.snp.updateConstraints { make in
//            make.leading.equalTo(safeAreaLayoutGuide).offset(frame.width / 6)
//            make.trailing.equalTo(safeAreaLayoutGuide).inset(frame.width / 6)
//            make.top.equalTo(safeAreaLayoutGuide).offset(20)
//        }
//
//        imageView.snp.updateConstraints { make in
//            make.height.width.equalTo(150)
//            make.bottom.equalTo(safeAreaLayoutGuide).inset(15)
//            make.leading.equalTo(safeAreaLayoutGuide).offset(frame.width / 6)
//            make.trailing.equalTo(safeAreaLayoutGuide).inset(frame.width / 6)
//        }
//
        super.updateConstraints()
    }
    
    //MARK: - Sub methods
    private func setSubviewsLayout() {
        registrationButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.leading.equalTo(safeAreaLayoutGuide).offset(40)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(40)
        }
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(150)
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(15)
            make.leading.equalTo(safeAreaLayoutGuide).offset(40)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(40)
        }
    }
}
