//
//  Untitled.swift
//  imdang
//
//  Created by daye on 12/22/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxRelay


enum ItemType {
    case text
    case image
    case address
    case button
    case longField
}

class InsightBaseInfoViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    private var selectedIndexPaths: [BehaviorRelay<IndexPath?>] = [
        BehaviorRelay<IndexPath?>(value: nil),
        BehaviorRelay<IndexPath?>(value: nil),
        BehaviorRelay<IndexPath?>(value: nil)
    ]
    
    private var addressData = ["", ""]
    
    
    var address: String = ""
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .grayScale25
        $0.register(BaseInfoTextFieldCell.self, forCellWithReuseIdentifier: BaseInfoTextFieldCell.identifier)
        $0.register(BaseInfoButtonCell.self, forCellWithReuseIdentifier: BaseInfoButtonCell.identifier)
        $0.register(BaseInfoImageCell.self, forCellWithReuseIdentifier: BaseInfoImageCell.identifier)
        $0.register(BaseInfoAddressCell.self, forCellWithReuseIdentifier: BaseInfoAddressCell.identifier)
        $0.register(BaseInfoLongTextFieldCell.self, forCellWithReuseIdentifier: BaseInfoLongTextFieldCell.identifier)
        $0.register(BaseInfoHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BaseInfoHeaderCell.identifier)
        $0.dataSource = self
        $0.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }

    private func layout() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }

    private let items: [(header: String,
                         script: String,
                         item: ItemType)]
    = [("표시 이미지", "", .image),
        ("제목", "최소1자-최대20자", .text),
        ("단지 주소", "", .address),
        ("다녀온 날짜", "", .text),
        ("다녀온 시간", "복수 선택 가능", .button),
        ("교통 수단", "복수 선택 가능", .button),
        ("출입 제한", "하나만 선택", .button),
        ("인사이트 요약", "최소30자-최대200자", .longField),
    ]
}

// MARK: - UICollectionViewDataSource
extension InsightBaseInfoViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0, 1, 3, 7: return 1
        case 2: return 2
        case 5, 6: return 3
        default: return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.section].item
        switch item {
        case .text:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BaseInfoTextFieldCell.identifier, for: indexPath) as! BaseInfoTextFieldCell
            
            if indexPath.section == 3 {
                cell.titleTextField.setConfigure(placeholderText: "예시) 2024.01.01", textfieldType: .decimalPad)
            }
            
            return cell
            
        case .button:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BaseInfoButtonCell.identifier, for: indexPath) as! BaseInfoButtonCell
            var itemArray = [""]
            if indexPath.section == 4 {
                itemArray = ["아침", "점심", "저녁", "밤"]
            }else if indexPath.section == 5 {
                itemArray = ["자차", "대중교통", "도보"]
            } else if indexPath.section == 6 {
                itemArray = ["제한됨", "허락시 가능", "자유로움"]
            }
            
            cell.configure(title: itemArray[indexPath.row])
            
            selectedIndexPaths[indexPath.section - 4]
                .map { $0 == indexPath ? .selectedBorderStyle : .unselectedBorderStyle }
                .bind(to: cell.rx.commonButtonState)
                .disposed(by: disposeBag)
            
            cell.buttonView.rx.tap
                .subscribe(onNext: { [weak self] in
                    self?.selectedIndexPaths[indexPath.section - 4].accept(indexPath)
                    print("Section: \(indexPath.section), Selected: \(itemArray[indexPath.row])")
                })
                .disposed(by: disposeBag)
            
            return cell
            
        case .image:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BaseInfoImageCell.identifier, for: indexPath) as! BaseInfoImageCell
            cell.buttonTapState
                .subscribe(onNext: { [weak self] in
                    let imageModal = BaseInfoViewBottomSheet()
                    imageModal.modalPresentationStyle = .overFullScreen
                    self?.present(imageModal, animated: false, completion: nil)
                    
                    imageModal.onPhotoLibrarySelected = { image in
                        cell.resultImageAccept(image: image)
                    }
                    
                    imageModal.onCameraSelected = { image in
                        cell.resultImageAccept(image: image)
                    }
                })
                .disposed(by: disposeBag)
            return cell
                 
        case .address:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BaseInfoAddressCell.identifier, for: indexPath) as! BaseInfoAddressCell
            
            if indexPath.row == 0 {
                addressData[0] == ""
                ? cell.configure(title: "지번 주소")
                : cell.setData(title: addressData[0])
            } else {
                addressData[1] == ""
                ? cell.configure(title: "아파트 단지 명")
                : cell.setData(title: addressData[1])
            }
            
            cell.buttonAction = { result in
                let webViewController = WebViewController()
                self.present(webViewController, animated: true, completion: nil)
                
                webViewController.onAddressSelected = { data in
                    if let jibunAddress = (data["jibunAddress"]) as? String {
                        self.addressData[0] = jibunAddress
                    }
                    if let buildingName = (data["buildingName"]) as? String {
                        self.addressData[1] = buildingName
                    }
                    print(self.addressData)
                    
                    self.collectionView.reloadSections(IndexSet([2]))
                }
            }
            
            return cell
            
        case .longField:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BaseInfoLongTextFieldCell.identifier, for: indexPath) as! BaseInfoLongTextFieldCell
            
            cell.buttonTapState
                .subscribe(onNext: { [weak self] in
                    let modalVC = InsightSummationViewController()
                    self?.present(modalVC, animated: true, completion: nil)
                })
                .disposed(by: disposeBag)
            return cell
        }
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension InsightBaseInfoViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: BaseInfoHeaderCell.identifier, for: indexPath) as! BaseInfoHeaderCell
            
            headerView.adjustTopPadding(indexPath.section == 0 ? 20 : 0)
            
            headerView.configure(title: items[indexPath.section].header,
                                 script: items[indexPath.section].script)
            return headerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = indexPath.section
        
        switch section {
        case 1, 2, 3:
            let width = collectionView.bounds.width - 40
            return CGSize(width: width, height: 52)
        case 4, 5, 6:
            let width = (collectionView.bounds.width - 40 - 10) / 2
            return CGSize(width: width, height: 52)
        default:
            let width = collectionView.bounds.width - 40
            return CGSize(width: width, height: 100)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 0:
            return UIEdgeInsets(top: 28, left: 20, bottom: 40, right: 20)
        case 7:
            return UIEdgeInsets(top: 8, left: 20, bottom: 120, right: 20)
        default:
            return UIEdgeInsets(top: 8, left: 20, bottom: 40, right: 20)
        }
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
