//
//  AnalyticsService.swift
//  imdang
//
//  Created by 임대진 on 2/15/25.
//

import Foundation
import FirebaseAnalytics

enum AnalyticsEventScreen: String {
    case splash = "스플래쉬"
    case signIn = "로그인"
    case onBoarding = "온보딩"
    case userInfoInput = "기본정보입력"
    case isJoined = "가입완료"
    case homeSearch = "홈_탐색"
    case homeExchange = "홈_교환소"
    case myVisitInsights = "내가 다녀온 단지의 다른 인사이트"
    case todayNewInsights = "오늘 새롭게 올라온 인사이트"
    case searchToDistrictDetail = "지역으로 찾기_상세"
    case StorageBox = "보관함"
    case listOfInsightsByDistrict = "지역별 인사이트 목록"
    case insightWriting = "인사이트 작성"
    case basicInfoSummary = "기본정보 요약"
    case infraSummary = "인프라 총평"
    case environmentSummary = "단지 환경 총평"
    case FacilitySummary = "단지 시설 총평"
    case FavoriteNewsSummary = "호재 총평"
    case insightDetail = "인사이트 상세"
    case mypage = "마이페이지"
    case serviceTerms = "서비스 이용 약관"
    case serviceIntroduction = "서비스 소개"
    case withdrawal = "계정 탈퇴"
    case searchingWithMap = "지도로 탐색"
    case findWithMap = "지도로 찾기"
    case notification = "알림"
}

final class AnalyticsService {
    static var shared = AnalyticsService()
    
    func screenEvent(ScreenName: AnalyticsEventScreen) {
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [ AnalyticsParameterScreenName: ScreenName.rawValue ])
    }
    
    /// 홈_탐색
    func homeSearch() {
        let event = "홈_탐색"
        Analytics.logEvent(event, parameters: [:])
    }
}
