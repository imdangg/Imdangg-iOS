//
//  MyPageWebView.swift
//  imdang
//
//  Created by daye on 2/9/25.
//

import UIKit
import WebKit
import SnapKit
import Then

class MyPageWebViewController: BaseViewController, WKNavigationDelegate {
    
    var webView = WKWebView()
    var urlString: String
    var webTitle: String
    let indicator = UIActivityIndicatorView(style: .medium)
    
    private let navigationTitleLabel = UILabel().then {
        $0.font = .pretenSemiBold(18)
        $0.textColor = .grayScale900
    }
    
    init(title: String, urlString: String) {
        self.webTitle = title
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configNavigationBarItem()
        setupUI()
        loadWebView()
        navigationTitleLabel.text = webTitle
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
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // ✅ Safe Area 영향을 받지 않도록 설정
        edgesForExtendedLayout = .all
        extendedLayoutIncludesOpaqueBars = true

        webView.navigationDelegate = self
        
        // ✅ Safe Area 영향을 받지 않도록 설정
        webView.scrollView.contentInsetAdjustmentBehavior = .never

        view.addSubview(webView)
        view.addSubview(indicator)
        
        webView.snp.makeConstraints {
            $0.topEqualToNavigationBottom(vc: self)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        indicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        indicator.startAnimating()
        indicator.color = .gray
    }
    
    private func loadWebView() {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation?) {
        indicator.stopAnimating()
        indicator.isHidden = true
    }
}

