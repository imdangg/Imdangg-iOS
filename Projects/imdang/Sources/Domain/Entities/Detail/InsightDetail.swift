//
//  InsightDetail.swift
//  imdang
//
//  Created by 임대진 on 1/8/25.
//

import UIKit

struct InsightDetail {
    let id: Int
    let titleName: String
    let titleImage: UIImage
    let userName: String
    var profileImage: UIImage
    var likeCount: Int
    
    let basicInfo: BasicInfo
    let infra: Infrastructure
    let environment: Environment
    let facility: Facility
    let goodNews: GoodNews
    
    static var testData = InsightDetail(id: 0, titleName: "초역세권 대단지 아파트 후기", titleImage: UIImage(), userName: "홍길동", profileImage: UIImage(), likeCount: 20, basicInfo: BasicInfo(adress: "서울특별시 영등포구 당산 2동 123-467\n(당산아이파크1차)", adressCoordinates: "", writeDate: "2024.01.01 / 저녁", transportation: "자차, 도보", restrictionsOnAccess: "자유로움", summary: "단지는 전반적으로 관리 상태가 양호했으며, 주변에 대형 마트와 초등학교가 가까워 생활 편의성이 뛰어납니다. 다만 주차 공간이 협소하고, 단지 내 보안 카메라 설치가 부족한 점이 아쉬워요. 단지는 전반적으로 관리 상태가 양호했으며, 주변에 대형 마트와 초등학교가 가까워 생활 편의성이 뛰어납니다. 다만 주차 공간이 협소하고, 단지 내 보안 카메라 설치가 부족한 점이 아쉬워요. 단지는 전반적으로 관리 상태가 양호했으며, 주변에 대형 마트와 초등학교가 가까워 생활 편의성이 뛰어납니다. 다만 주차 공간이 협소하고, 단지 내 보안 카메라 설치가 부족한 점이 아쉬워요."), infra: Infrastructure(traffic: ["해당 없음"], educationInfo: ["초품아", "학원가"], livingFacility: ["주민센터", "편의점"], culturalAndLeisure: ["도서관", "영화관", "헬스장"], surroundEnvironment: ["산", "공원"], landMark: ["놀이공원", "복합 쇼핑몰", "고궁", "전망대", "국립공원", "한옥마을"], repellentFacility: ["고속도로", "유흥걸;"], text: "단지는 전반적으로 관리 상태가 양호했으며, 주변에 대형 마트와 초등학교가 가까워 생활 편의성이 뛰어납니다. 다만 주차 공간이 협소하고, 단지 내 보안 카메라 설치가 부족한 점이 아쉬워요. 단지는 전반적으로 관리 상태가 양호했으며, 주변에 대형 마트와 초등학교가 가까워 생활 편의성이 뛰어납니다."), environment: Environment(building: "잘 모르겠어요", safety: "좋아요", childrenFacility: "평범해요", seniorFacility: "좋아요", text: "단지는 전반적으로 관리 상태가 양호했으며, 주변에 대형 마트와 초등학교가 가까워 생활 편의성이 뛰어납니다. 다만 주차 공간이 협소하고, 단지 내 보안 카메라 설치가 부족한 점이 아쉬워요. 단지는 전반적으로 관리 상태가 양호했으며, 주변에 대형 마트와 초등학교가 가까워 생활 편의성이 뛰어납니다."), facility: Facility(family: ["어린이집"], multipurpose: ["해당 없음"], leisure: ["피트니스 센터", "독서실", "사우나", "목욕탕", "스크린 골프장", " 영화관", "도서관", "수영장"], environment: ["잔디밭"], text: "단지는 전반적으로 관리 상태가 양호했으며, 주변에 대형 마트와 초등학교가 가까워 생활 편의성이 뛰어납니다. 다만 주차 공간이 협소하고, 단지 내 보안 카메라 설치가 부족한 점이 아쉬워요. 단지는 전반적으로 관리 상태가 양호했으며, 주변에 대형 마트와 초등학교가 가까워 생활 편의성이 뛰어납니다."), goodNews: GoodNews(traficNews: ["잘 모르겠어요"], develop: ["재개발", "재건축", "인근 신도시 개발"], education: ["잘 모르겠어요"], naturalEnvironment: ["하천 복원", "호수 복원"], culture: ["대형병원", "문화센터", "도서관", "공연장"], industry: ["산업단지"], policy: ["투기 과열 지구 해제", "일자리 창출 정책"], text: "단지는 전반적으로 관리 상태가 양호했으며, 주변에 대형 마트와 초등학교가 가까워 생활 편의성이 뛰어납니다. 다만 주차 공간이 협소하고, 단지 내 보안 카메라 설치가 부족한 점이 아쉬워요. 단지는 전반적으로 관리 상태가 양호했으며, 주변에 대형 마트와 초등학교가 가까워 생활 편의성이 뛰어납니다."))
}
