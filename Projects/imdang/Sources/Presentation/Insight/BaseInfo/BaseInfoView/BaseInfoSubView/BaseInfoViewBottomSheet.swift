//
//  BaseInfoViewBottomSheet.swift
//  imdang
//
//  Created by daye on 12/23/24.
//

import UIKit
import SnapKit
import Then


class BaseInfoViewBottomSheet: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var onPhotoLibrarySelected: ((UIImage) -> Void)?
    var onCameraSelected: ((UIImage) -> Void)?
    
    private let backgroundView = UIView().then {
        $0.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
    }
    
    private let containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
    }
    
    private let sheetTitle = UILabel().then {
        $0.text = "이미지 추가"
        $0.textColor = .grayScale900
        $0.font = .pretenSemiBold(18)
    }
    
    private let closeButton = UIButton().then {
        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
        $0.tintColor = .grayScale900
        $0.frame = .init(x: 0, y: 0, width: 20, height: 20)
    }
    
    private let photoLibraryButton = UIButton().then {
        $0.setTitle("앨범에서 선택", for: .normal)
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.grayScale100.cgColor
        $0.setTitleColor(.grayScale700, for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        $0.titleLabel?.font = .pretenSemiBold(16)
    }
    
    private let cameraButton = UIButton().then {
        $0.setTitle("사진 촬영", for: .normal)
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.grayScale100.cgColor
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        $0.setTitleColor(.grayScale700, for: .normal)
        $0.titleLabel?.font = .pretenSemiBold(16)
    }
    
    private let imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        showBottomSheet()
        setupLayout()
        setupActions()
        imagePickerController.delegate = self
    }
    
    private func setupLayout() {
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        view.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(237)
        }
        
        containerView.addSubview(sheetTitle)
        sheetTitle.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(20)
        }
        
        containerView.addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.trailing.equalToSuperview().inset(20)
        }

        containerView.addSubview(photoLibraryButton)
        photoLibraryButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(56)
            $0.top.equalTo(closeButton.snp.bottom).offset(24)
        }
        
        containerView.addSubview(cameraButton)
        cameraButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(40)
            $0.height.equalTo(56)
            $0.top.equalTo(photoLibraryButton.snp.bottom).offset(12)
        }
    }
    
    private func setupActions() {
        // 닫기 버튼
        closeButton.addTarget(self, action: #selector(dismissBottomSheet), for: .touchUpInside)
        
        // 사진 선택 버튼
        photoLibraryButton.addTarget(self, action: #selector(photoLibraryButtonTapped), for: .touchUpInside)
        
        // 사진 촬영 버튼
        cameraButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func photoLibraryButtonTapped() {
        // 사진 라이브러리 선택
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePickerController.sourceType = .photoLibrary
            present(imagePickerController, animated: true, completion: nil)
        }
       
    }
    
    @objc private func cameraButtonTapped() {
        // 카메라 촬영
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
            present(imagePickerController, animated: true, completion: nil)
        }
     
    }
    
    // 잘 안되는데 나중에 봄..
    private func showBottomSheet() {
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundView.alpha = 1
            
            self.containerView.transform = CGAffineTransform(translationX: 0, y: 237)
            
            self.containerView.transform = .identity
            
            self.containerView.frame.origin.y = self.view.frame.height - self.containerView.frame.height
            self.view.layoutIfNeeded()
        })
    }
    
    @objc private func dismissBottomSheet() {
        UIView.animate(withDuration: 0.1, animations: {
            self.backgroundView.alpha = 0
            self.containerView.frame.origin.y = self.view.frame.height
            self.view.layoutIfNeeded()
        }) { _ in
            self.dismiss(animated: false)
        }
    }
  
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            if picker.sourceType == .photoLibrary {
                onPhotoLibrarySelected?(image)
            } else if picker.sourceType == .camera {
                onCameraSelected?(image)
            }
        }
        picker.dismiss(animated: true, completion: nil)
        dismissBottomSheet()
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        dismissBottomSheet()
    }
}
