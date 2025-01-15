//
//  MyPageViewController.swift
//  imdang
//
//  Created by daye on 1/12/25.
//

import UIKit
import SnapKit
import Then
import RxSwift

class MyPageViewController: BaseViewController {

    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let deleteAccountButton = CommonButton(title: "계정 탈퇴", initialButtonType: .unselectedBorderStyle)
    
    private let navigationTitleLabel = UILabel().then {
        $0.font = .pretenSemiBold(18)
        $0.textColor = .grayScale900
        $0.text = "MY 페이지"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        configNavigationBarItem()
    }
    
    private func configNavigationBarItem() {
        // TODO: 색깔변경 해야됨
        customBackButton.isHidden = false
        leftNaviItemView.addSubview(navigationTitleLabel)
        navigationTitleLabel.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
        }
    }

    private func setupTableView() {
        // TableView 설정
        tableView.backgroundColor = .grayScale25
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        // Custom Cell 등록
        tableView.register(UserCell.self, forCellReuseIdentifier: "UserCell")
        tableView.register(InfoCell.self, forCellReuseIdentifier: "InfoCell")
        tableView.register(TermsCell.self, forCellReuseIdentifier: "TermsCell")
        
        deleteAccountButton.addTarget(self, action: #selector(deleteAccountButtonTapped), for: .touchUpInside)
        
        view.addSubview(tableView)
        view.addSubview(deleteAccountButton)
        
        // SnapKit으로 레이아웃 설정
        tableView.snp.makeConstraints {
            $0.topEqualToNavigationBottom(vc: self)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(deleteAccountButton.snp.top).offset(10)
        }
        
        deleteAccountButton.snp.makeConstraints {
            $0.height.equalTo(42)
            $0.width.equalTo(100)
            $0.leading.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(50)
        }
    }
    
    @objc private func deleteAccountButtonTapped() {
        print("탈퇴")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootView(SigninViewController(), animated: true)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension MyPageViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3 // 섹션 수
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1 // UserCell 1개
        case 1: return 2 // InfoCell 2개
        case 2: return 3 // TermsCell 3개
        default: return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.configure(name: "홍길동")
            cell.onLogoutButtonTapped = {
                print("Logout!")
                let vc = TermsViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as? InfoCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            if indexPath.row == 0 {
                cell.configure(title: "작성한 인사이트", num: "16개")
            } else {
                cell.configure(title: "누적 교환", num: "8건")
            }
            return cell
            
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TermsCell", for: indexPath) as? TermsCell else {
                return UITableViewCell()
            }
            if indexPath.row == 0 {
                cell.configure(title: "서비스 소개")
            } else if indexPath.row == 1 {
                cell.configure(title: "서비스 이용 약관")
            } else {
                cell.configure(title: "버전 정보")
            }
            return cell
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 103 // UserCell의 높이
        case 1: return 62 // InfoCell의 높이
        case 2: return 64 // TermsCell의 높이
        default: return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 2 {
            let dividerView = UIView()
            dividerView.backgroundColor = .grayScale50
            return dividerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 2 ? 8 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 {
            return UIView()
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 1 ? 12 : 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
   
    @objc private func footerButtonTapped() {
        print("탈퇴")
//        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootView(SigninViewController(), animated: true)
    }
}

// MARK: - Custom Cells
class UserCell: UITableViewCell {
    
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = ImdangImages.Image(resource: .person)
        $0.clipsToBounds = true
    }
    
    private let userNameLabel = UILabel().then {
        $0.font = .pretenSemiBold(18)
        $0.textColor = UIColor.grayScale900
    }
    
    let logoutButton = ImageTextButton(type: .imageFirst, horizonPadding: 12, spacing: 4).then {
        $0.customImage.image = ImdangImages.Image(resource: .logout)
        $0.customText.text = "로그아웃"
        $0.customText.font = .pretenMedium(12)
        $0.customText.textColor = .grayScale700
        $0.imageSize = 11
        $0.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        $0.layer.cornerRadius = 4
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.grayScale200.cgColor
    }
    
    var onLogoutButtonTapped: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .grayScale25
        addSubViews()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addSubViews() {
        [profileImageView, userNameLabel, logoutButton].forEach { contentView.addSubview($0) }
    }
    
    private func layout() {
        profileImageView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview().inset(20)
            $0.width.height.equalTo(60)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView.snp.centerY)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(15)
            $0.width.lessThanOrEqualTo(86)
        }
        
        logoutButton.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView.snp.centerY)
            $0.width.equalTo(82)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    @objc private func logoutButtonTapped() {
        onLogoutButtonTapped?()
    }
    
    func configure(name: String) {
        userNameLabel.text = name
    }
}

class InfoCell: UITableViewCell {
    
    private let backView = UIView().then {
        $0.backgroundColor = .mainOrange50
        $0.layer.cornerRadius = 10
    }
    private let titleLabel = UILabel().then {
        $0.font = .pretenSemiBold(16)
        $0.textColor = UIColor.grayScale900
    }
    
    private let numberLabel = UILabel().then {
        $0.font = .pretenSemiBold(16)
        $0.textColor = UIColor.mainOrange500
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .grayScale25
        addSubViews()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubViews() {
        [titleLabel, numberLabel].forEach { backView.addSubview($0) }
        contentView.addSubview(backView)
    }
    
    private func layout() {

        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(backView).inset(16)
            $0.leading.equalTo(backView).inset(20)
        }
        
        numberLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(backView).inset(16)
            $0.trailing.equalTo(backView).inset(20)
        }
        
        backView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.bottom.equalToSuperview().inset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    func configure(title: String, num: String) {
        titleLabel.text = title
        numberLabel.text = num
    }
    
}

class TermsCell: UITableViewCell {
    
    private let titleLabel = UILabel().then {
        $0.font = .pretenSemiBold(16)
        $0.textColor = UIColor.grayScale900
    }
    
    private let navigationButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
        $0.tintColor = .grayScale900
    }
    
    private let separator = UIView().then {
        $0.backgroundColor = .grayScale100
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .grayScale25
        addSubViews()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addSubViews() {
        [titleLabel, navigationButton, separator].forEach { contentView.addSubview($0) }
    }
  
    private func layout() {
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(20)
        }
        
        navigationButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(16)
            $0.width.height.equalTo(16)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        separator.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
}

//class FooterButtonCell: UITableViewCell {
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupView()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setupView() {
//        let button = CommonButton(title: "계정 탈퇴", initialButtonType: .unselectedBorderStyle)
//        contentView.addSubview(button)
//        button.snp.makeConstraints {
//            $0.height.equalTo(42)
//            $0.leading.bottom.equalToSuperview().inset(20)
//        }
//      
//    }
//}
