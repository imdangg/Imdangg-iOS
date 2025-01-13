//
//  InsightDetailEtcViewCell.swift
//  imdang
//
//  Created by 임대진 on 1/13/25.
//
import UIKit
import Then
import SnapKit

class InsightDetailEtcCollectionCell: UICollectionViewCell {
    
    private var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
    }
    
    private let separatorView = UIView().then {
        $0.backgroundColor = .grayScale50
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        stackView = UIStackView().then {
            $0.axis = .vertical
            $0.spacing = 4
        }
        [stackView].forEach { contentView.addSubview($0) }
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width)
        }
    }
    
    private func addSubviews() {
        [stackView].forEach { contentView.addSubview($0) }
    }
    
    private func makeConstraints() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width)
        }
    }
    func config(info: [(String, [String])], text: String) {
        
        info.forEach { (name, items) in
            let title = UILabel().then {
                $0.text = name
                $0.font = .pretenMedium(14)
                $0.textColor = .grayScale600
            }
            let labelsView = TagView2()
            labelsView.setup(with: items)
            stackView.addArrangedSubview(title)
            stackView.addArrangedSubview(labelsView)
            
            title.snp.makeConstraints {
                $0.height.equalTo(22)
            }
            labelsView.snp.makeConstraints {
//                $0.width.equalToSuperview()
                $0.height.equalTo(labelsView.currentY)
//                $0.width.equalTo(UIScreen.main.bounds.width - 20)
//                $0.height.equalTo(labelsView.frame.height)
            }
        }
        
        let titleLabel = UILabel().then {
            $0.text = "총평"
            $0.font = .pretenMedium(14)
            $0.textColor = .grayScale600
        }
        
        let descriptionLabel = UILabel().then {
            $0.text = text 
            $0.font = .pretenMedium(16)
            $0.textColor = .grayScale900
            $0.numberOfLines = 0
        }
        
        [titleLabel].forEach { stackView.addArrangedSubview($0) }
        
//        titleLabel.snp.makeConstraints {
//            $0.height.equalTo(22)
//        }
//        descriptionLabel.snp.makeConstraints {
//            $0.width.equalTo(UIScreen.main.bounds.width - 20)
//        }
        
//        separatorView.snp.makeConstraints {
//            $0.top.equalTo(descriptionLabel.snp.bottom).offset(32)
//            $0.leading.equalToSuperview().offset(-20)
//            $0.trailing.equalToSuperview()
//            $0.height.equalTo(8)
//        }
    }
}

class TagView: UIView {
    func setup(with tags: [String]) {
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0)

        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        let padding: CGFloat = 8    // 라벨 사이 간격
        let lineSpacing: CGFloat = 8 // 줄 간격
        let maxWidth = self.bounds.width

        for tag in tags {
            let noneLabel = tag == "해당 없음" || tag == "잘 모르겠어요"
            
            let label = UILabel().then {
                $0.text = tag
                $0.font = .pretenSemiBold(14)
                $0.textColor = noneLabel ? .grayScale500 : .mainOrange500
                $0.backgroundColor = noneLabel ? .grayScale50 : .mainOrange50
                $0.textAlignment = .center
                $0.layer.cornerRadius = 8
                $0.layer.masksToBounds = true
                $0.layer.borderColor = noneLabel ? UIColor.grayScale100.cgColor : UIColor.mainOrange500.cgColor
                $0.layer.borderWidth = 1
                
                $0.sizeToFit()
                $0.frame.size.width += 32
                $0.frame.size.height = 36
            }

            // 가로 방향으로 공간 초과 시 새 줄로 이동
            if currentX + label.frame.width > maxWidth {
                currentX = 0
                currentY += label.frame.height + lineSpacing // 줄바꿈
            }

            // 라벨 위치 설정
            label.frame.origin = CGPoint(x: currentX, y: currentY)
            self.addSubview(label)

            // 다음 라벨의 x 좌표 업데이트
            currentX += label.frame.width + padding
        }

        // 전체 뷰의 높이 업데이트
        self.frame.size.height = 36 + currentY + 20 // 여유 공간 추가
    }
}

class TagView2: UIView {
    var currentY: CGFloat = 36
    func setup(with tags: [String]) {
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0)
        
        var currentX: CGFloat = 0
        let padding: CGFloat = 8    // 라벨 사이 간격
        let lineSpacing: CGFloat = 8 // 줄 간격
        let maxWidth = self.bounds.width
        
        var previousLabel: UILabel? = nil // 이전 라벨을 추적할 변수

        for tag in tags {
            let noneLabel = tag == "해당 없음" || tag == "잘 모르겠어요"
            
            let label = PaddingLabel().then {
                $0.text = tag
                $0.font = .pretenSemiBold(14)
                $0.textColor = noneLabel ? .grayScale500 : .mainOrange500
                $0.backgroundColor = noneLabel ? .grayScale50 : .mainOrange50
                $0.textAlignment = .center
                $0.padding = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
                
                $0.layer.cornerRadius = 8
                $0.layer.masksToBounds = true
                $0.layer.borderColor = noneLabel ? UIColor.grayScale100.cgColor : UIColor.mainOrange500.cgColor
                $0.layer.borderWidth = 1
                                $0.sizeToFit()
                                $0.frame.size.width += 32
                                $0.frame.size.height = 36
            }


            // 가로 방향으로 공간 초과 시 새 줄로 이동
            if currentX + label.frame.width > maxWidth {
                currentY += 36 + padding
                currentX = 0
                self.addSubview(label)
                label.snp.makeConstraints { make in
                    make.top.equalTo(previousLabel?.snp.bottom ?? self.snp.top).offset(lineSpacing)
                    make.leading.equalTo(self.snp.leading)
                }
            } else {
                self.addSubview(label)
                label.snp.makeConstraints { make in
                    make.top.equalTo(previousLabel?.snp.top ?? self.snp.top)
                    make.leading.equalTo(previousLabel?.snp.trailing ?? self.snp.leading).offset(previousLabel == nil ? 0 : lineSpacing)
                }
            }

            // 다음 라벨의 x 좌표 업데이트
            previousLabel = label // 현재 라벨을 이전 라벨로 설정
            currentX += label.frame.width + padding
        }
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: currentY)

        // 전체 뷰의 높이 업데이트
//        self.snp.makeConstraints { make in
//            make.horizontalEdges.equalToSuperview()
//
//        }
    }
}
