//
//  IntroForthCell.swift
//  imdang
//
//  Created by daye on 2/4/25.
//

import UIKit
import SnapKit
import Then

class FourthCell: UICollectionViewCell {
    
    private let comment = [
        "관심 있는 아파트에 임장을 다녀오세요. 이때, 간단한\n메모를 해두면, 임장 인사이트를 작성할 때 편리해요.",
        "아파트임당에서 인사이트를 작성한 후 업로드하고\n기록해요.",
        "다른 사람들과 인사이트를 교환하며 수집해요.",
        "교환한 인사이트와 내 인사이트를 비교하며,\n임장 지식을 쌓아요."
    ]
    
    private let titleLabel = UILabel().then {
        $0.setTextWithLineHeight(text: "이렇게 사용하는 것을\n추천해요", lineHeight: 30)
        $0.font = .pretenSemiBold(20)
        $0.textColor = .grayScale900
        $0.numberOfLines = 0
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
        $0.alignment = .leading
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .backgroundLightBlue
        
        [titleLabel, stackView].forEach{contentView.addSubview($0)}
        layout()
        setupScript()
    }
    
    private func layout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.leading.equalToSuperview().inset(20)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(44)
        }
    }
    
    private func setupScript() {
        for i in 0..<4 {
            let container = UIView()
            
            let img = UIImageView(image: UIImage(named: "introRecommand\(i+1)")).then {
                $0.contentMode = .scaleAspectFit
            }
            
            let script = UILabel().then {
                $0.setTextWithLineHeight(text: comment[i], lineHeight: 19.6)
                $0.font = .pretenRegular(14)
                $0.textColor = .grayScale700
                $0.numberOfLines = 0
            }
            
            container.addSubview(img)
            container.addSubview(script)
            
            img.snp.makeConstraints {
                $0.top.leading.bottom.equalToSuperview()
                $0.width.height.equalTo(32)
            }
            
            script.snp.makeConstraints {
                $0.leading.equalTo(img.snp.trailing).offset(16)
                $0.trailing.equalToSuperview()
                $0.centerY.equalTo(img)
            }
            
            stackView.addArrangedSubview(container)
            
            if i < 3 {
                let vector = UIImageView(image: UIImage(named: "vector_vertical")).then {
                    $0.contentMode = .scaleAspectFit
                }
                stackView.addArrangedSubview(vector)
                vector.snp.makeConstraints {
                    $0.width.height.equalTo(32)
                    $0.height.equalTo(24)
                }
            }
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
