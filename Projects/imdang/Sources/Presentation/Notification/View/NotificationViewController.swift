//
//  NotificationViewController.swift
//  imdang
//
//  Created by daye on 1/20/25.
//

import UIKit
import SnapKit
import Then
import ReactorKit

final class NotificationViewController: BaseViewController, View {
    
    var disposeBag = DisposeBag()
    
    private var collectionView: UICollectionView!

    private let navigationTitleLabel = UILabel().then {
        $0.font = .pretenSemiBold(18)
        $0.textColor = .grayScale900
        $0.text = "알림"
    }
    
    init(reactor: NotificationReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
        bind(reactor: reactor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .grayScale25
        setupCollectionView()
        configNavigationBarItem()
    }

    private func configNavigationBarItem() {
        customBackButton.isHidden = false
        leftNaviItemView.addSubview(navigationTitleLabel)
        navigationTitleLabel.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
        }
    }
    
    private func setupCollectionView() {
        
        let layout = UICollectionViewFlowLayout().then {
            $0.minimumLineSpacing = 10
            $0.headerReferenceSize = CGSize(width: view.frame.width, height: 50)
            $0.itemSize = CGSize(width: view.frame.width - 40, height: 179)
        }

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
            $0.backgroundColor = .grayScale25
            $0.dataSource = self
            $0.delegate = self
            $0.register(NotifivationCollectionViewCell.self, forCellWithReuseIdentifier: "NotifivationCollectionViewCell")
            $0.register(NotificationTitleHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NotificationTitleHeaderView.reuseIdentifier)
            $0.register(NotificationTypeHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NotificationTypeHeaderView.reuseIdentifier)
        }

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.topEqualToNavigationBottom(vc: self).inset(8)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    
    func bind(reactor: NotificationReactor) {
        reactor.action.onNext(.loadNotifications)
    }
}

extension NotificationViewController:  UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let reactor = self.reactor else { return 0 }
        let notifications = reactor.currentState.notifications
        
        switch section {
        case 0:
            return 0
        case 1:
            return notifications.count
        case 2:
            return notifications.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotifivationCollectionViewCell", for: indexPath) as! NotifivationCollectionViewCell

        guard let reactor = self.reactor else { return cell }
        let notifications = reactor.currentState.notifications
        
        if indexPath.section == 1 || indexPath.section == 2 {
            let notification = notifications[indexPath.row]
            
            cell.configure(
                type: notification.type,
                userName: notification.username
            )
            

//            let testState: [DetailExchangeState] = [.beforeRequest, .afterRequest, .done,.beforeRequest, .afterRequest, .done,.beforeRequest, .afterRequest, .done,.beforeRequest, .afterRequest, .done,.beforeRequest, .afterRequest, .done,.beforeRequest, .afterRequest, .done,.beforeRequest, .afterRequest, .done,.beforeRequest, .afterRequest, .done,.beforeRequest, .afterRequest, .done,.beforeRequest, .afterRequest, .done,.beforeRequest, .afterRequest, .done,]

            
            let textImage = UIImageView().then {
                guard let url = URL(string: "https://img1.newsis.com/2023/07/12/NISI20230712_0001313626_web.jpg") else { return }
                $0.kf.setImage(with: url)
                $0.contentMode = .scaleAspectFill
            }
            
            cell.tapAction = { [weak self] type in
                guard let self = self else { return }
                switch type {
                case .request_accept:
                    let tab = TabBarController()
                    tab.selectedIndex = 2
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootView(tab, animated: true)
                case .request_reject:
                    let view2 = InsightDetailViewController(url: "", insight: InsightDetail.emptyInsight)
                    self.navigationController?.pushViewController(view2, animated: true)
                case .response:
                    let view3 = InsightDetailViewController(url: "", insight: InsightDetail.emptyInsight)
                    self.navigationController?.pushViewController(view3, animated: true)
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }

        if indexPath.section == 0 {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NotificationTypeHeaderView.reuseIdentifier, for: indexPath) as! NotificationTypeHeaderView
            
            if let reactor = self.reactor {
                header.bind(reactor: reactor)
            }
            
            header.tapSubject
                .subscribe(onNext: { [weak self] selectedType in
                    guard let self = self else { return }
                    self.reactor?.action.onNext(.tapNotificationTypeButton(selectedType))
                })
                .disposed(by: disposeBag)
            
            return header
        }

        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NotificationTitleHeaderView.reuseIdentifier, for: indexPath) as! NotificationTitleHeaderView
        if indexPath.section == 1 {
            header.configure(title: "신규 알림")
        } else if indexPath.section == 2 {
            header.configure(title: "지난 알림")
        }
        return header
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: collectionView.frame.width, height: 60)
        }
        return CGSize(width: collectionView.frame.width, height: 68)
    }
}
