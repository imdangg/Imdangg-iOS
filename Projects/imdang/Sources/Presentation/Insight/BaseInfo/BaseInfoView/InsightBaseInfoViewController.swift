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

}

class InsightBaseInfoViewController: UIViewController, TotalAppraisalFootereViewDelegate {
    
    let disposeBag = DisposeBag()
    
    private var imageData: UIImage?
    private var insightTitle: String = ""
    private var addressData = ["", ""]
    private var date: String = ""
    private var summary: String = ""
    
    private var selectedIndexPaths: [BehaviorRelay<Set<IndexPath>>] = [
        BehaviorRelay<Set<IndexPath>>(value: []), // Section 4
        BehaviorRelay<Set<IndexPath>>(value: []), // Section 5
        BehaviorRelay<Set<IndexPath>>(value: [])  // Section 6
    ]
    private var checkSectionState: [TextFieldState] = Array(repeating: .normal, count: 7)
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .grayScale25
        $0.register(BaseInfoTextFieldCell.self, forCellWithReuseIdentifier: BaseInfoTextFieldCell.identifier)
        $0.register(BaseInfoButtonCell.self, forCellWithReuseIdentifier: BaseInfoButtonCell.identifier)
        $0.register(BaseInfoImageCell.self, forCellWithReuseIdentifier: BaseInfoImageCell.identifier)
        $0.register(BaseInfoAddressCell.self, forCellWithReuseIdentifier: BaseInfoAddressCell.identifier)
        $0.register(InsightTotalAppraisalFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: InsightTotalAppraisalFooterView.identifier)
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

    private let items: [(header: String, script: String, itemType: ItemType, itemData: [String])]
        = [("표시 이미지", "", .image, [""]),
            ("제목", "최소1자-최대20자", .text, [""]),
            ("단지 주소", "", .address, ["지번 주소", "단지 아파트 명"]),
            ("다녀온 날짜", "", .text, [""]),
            ("다녀온 시간", "복수 선택 가능", .button, ["아침", "점심", "저녁", "밤"]),
            ("교통 수단", "복수 선택 가능", .button, ["자차", "대중교통", "도보"]),
            ("출입 제한", "하나만 선택", .button, ["제한됨", "허락시 가능", "자유로움"])
        ]

}

// MARK: - UICollectionViewDataSource
extension InsightBaseInfoViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items[section].itemData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.section].itemType
        switch item {
        case .text:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BaseInfoTextFieldCell.identifier, for: indexPath) as! BaseInfoTextFieldCell
            if indexPath.section == 1 {
                checkSectionState[indexPath.section] = insightTitle != "" ? .done : .normal
            } else if indexPath.section == 3 {
                cell.titleTextField.setConfigure(placeholderText: "예시) 2024.01.01", textfieldType: .decimalPad)
                checkSectionState[indexPath.section] = date != "" ? .done : .normal
            }
            
            return cell
            
        case .button:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: BaseInfoButtonCell.identifier,
                for: indexPath
            ) as! BaseInfoButtonCell

            let itemArray = items[indexPath.section].itemData

            cell.configure(title: itemArray[indexPath.row])

            let selectedSetRelay = selectedIndexPaths[indexPath.section - 4]

                selectedSetRelay
                    .map { selectedSet in
                        selectedSet.contains { $0 == indexPath } ? .selectedBorderStyle : .unselectedBorderStyle
                    }
                    .bind(to: cell.rx.commonButtonState)
                    .disposed(by: disposeBag)

                cell.buttonView.rx.tap
                    .subscribe(onNext: { [weak self] in
                        guard self != nil else { return }

                        var selectedSet = selectedSetRelay.value

                        if indexPath.section == 6 {
                            // 단일 선택
                            if selectedSet.contains(indexPath) {
                                selectedSet.remove(indexPath) // 선택 해제
                            } else {
                                selectedSet = [indexPath] // 선택 변경
                            }
                        } else {
                            // 다중 선택
                            if selectedSet.contains(indexPath) {
                                selectedSet.remove(indexPath)
                            } else {
                                selectedSet.insert(indexPath)
                            }
                        }

                        selectedSetRelay.accept(selectedSet)
                        print("Section: \(indexPath.section), Selected: \(selectedSet.map { itemArray[$0.row] })")
                    })
                    .disposed(by: cell.disposeBag)

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
                        self?.imageData = image
                    }
                    imageModal.onCameraSelected = { image in
                        cell.resultImageAccept(image: image)
                        self?.imageData = image
                    }
                })
                .disposed(by: disposeBag)
            checkSectionState[indexPath.section] = imageData != nil ? .done : .normal
            print("state : \(checkSectionState)")
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
        }
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension InsightBaseInfoViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: BaseInfoHeaderCell.identifier, for: indexPath) as! BaseInfoHeaderCell
            
            headerView.adjustTopPadding(indexPath.section == 0 ? 20 : 0)
            print("header state : \(checkSectionState[indexPath.section])")
            headerView.headerView.setState(checkSectionState[indexPath.section])
            headerView.configure(title: items[indexPath.section].header,
                                 script: items[indexPath.section].script)
            return headerView
        } else if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableFooter(forIndexPath: indexPath, footerType: InsightTotalAppraisalFooterView.self)
            footer.config(title: "인사이트 요약")
            footer.setPlaceHolder(text: "예시)\n지하철역과 도보 10분 거리로 접근성이 좋지만, 근처 공사로 소음 문제가 있을 수 있을 것 같아요. 하지만 단지 내 공원이 잘 조성되어 있어 가족 단위 거주자에게 적합할 것 같아요")
            footer.customTextView.text = summary
            footer.delegate = self
            
            return footer
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == items.count - 1 {
            return CGSize(width: collectionView.bounds.width, height: 300)
        }
        return .zero
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
    
    func didTapButton(title: String, text: String) {
        let childVC = CommonTextViewViewComtroller(title: title, text: text)
        
        childVC.onDataSend = { [weak self] data in
            guard let self = self else { return }
            
            self.summary = data
            let lastSection = self.items.count - 1
            let footerIndexPath = IndexPath(item: 0, section: lastSection)
            self.collectionView.reloadSections(IndexSet(integer: footerIndexPath.section))
        }
        navigationController?.pushViewController(childVC, animated: true)
    }
    
}
