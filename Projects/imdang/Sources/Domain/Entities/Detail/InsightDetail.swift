//
//  InsightDetail.swift
//  imdang
//
//  Created by 임대진 on 1/8/25.
//

import UIKit


struct Adress {
    var siDo: String
    var siGungu: String
    var eupMyeonDong: String
    var roadName: String? = ""
    var buildngNumber: String
    var detail: String? = ""
    
    func toString() -> String {
        return "\(siDo) \(siGungu) \(eupMyeonDong)\( roadName ?? "") \(buildngNumber)\( detail ?? "")"
    }
}

struct InsightDetail {
    let memberId: String = UserdefaultKey.memberId
    var score: Int
    var mainImage: String
    var title: String
    var adress: Adress
    var apartmentComplex: String
    var visitAt: String
    var visitTimes: [String]
    var visitMethods: [String]
    var summary: String
    var access: String
    
    var infra: Infrastructure
    var complexEnvironment: Environment
    var complexFacility: Facility
    var favorableNews: FavorableNews
    
    func printDetails() {
        print("Member ID: \(memberId)")
        print("Score: \(score)")
        print("Main Image: \(mainImage)")
        print("Title: \(title)")
        print("Address: \(adress.toString())")
        print("Apartment Complex: \(apartmentComplex)")
        print("Visit At: \(visitAt)")
        print("Visit Times: \(visitTimes.joined(separator: ", "))")
        print("Visit Methods: \(visitMethods.joined(separator: ", "))")
        print("Summary: \(summary)")
        print("Access: \(access)")
        
        print("Infrastructure: \(infra)")
        print("Complex Environment: \(complexEnvironment)")
        print("Complex Facility: \(complexFacility)")
        print("Favorable News: \(favorableNews)")
    }
    
    static var testData = InsightDetail(score: 0 , mainImage: "", title: "초역세권 대단지 아파트 후기", adress: Adress(siDo: "서울특별시", siGungu: "영등포구", eupMyeonDong: "당산 2동", buildngNumber: "123-456"), apartmentComplex: "당산아이파크1차", visitAt: "2024.01.01", visitTimes: ["저녁"], visitMethods: ["자차", "도보"], summary: "단지는 전반적으로 관리 상태가 양호했으며, 주변에 대형 마트와 초등학교가 가까워 생활 편의성이 뛰어납니다. 다만 주차 공간이 협소하고, 단지 내 보안 카메라 설치가 부족한 점이 아쉬워요. 단지는 전반적으로 관리 상태가 양호했으며, 주변에 대형 마트와 초등학교가 가까워 생활 편의성이 뛰어납니다. 다만 주차 공간이 협소하고, 단지 내 보안 카메라 설치가 부족한 점이 아쉬워요. 단지는 전반적으로 관리 상태가 양호했으며, 주변에 대형 마트와 초등학교가 가까워 생활 편의성이 뛰어납니다. 다만 주차 공간이 협소하고, 단지 내 보안 카메라 설치가 부족한 점이 아쉬워요.", access: "자유로움",
                                        infra: Infrastructure(transportations: ["해당 없음"], schoolDistricts: ["초품아", "학원가"], amenities: ["주민센터", "편의점"], facilities: ["도서관", "영화관", "헬스장"], surroundings: ["산", "공원"], landmarks: ["놀이공원", "복합 쇼핑몰", "고궁", "전망대", "국립공원", "한옥마을"], unpleasantFacilities: ["고속도로", "유흥거리"], text: "단지는 전반적으로 관리 상태가 양호했으며, 주변에 대형 마트와 초등학교가 가까워 생활 편의성이 뛰어납니다. 다만 주차 공간이 협소하고, 단지 내 보안 카메라 설치가 부족한 점이 아쉬워요. 단지는 전반적으로 관리 상태가 양호했으며, 주변에 대형 마트와 초등학교가 가까워 생활 편의성이 뛰어납니다."),
                                        complexEnvironment: Environment(buildingCondition: ["잘 모르겠어요"], security: ["좋아요"], childrenFacility: ["평범해요"], seniorFacility: ["좋아요"], text: "단지는 전반적으로 관리 상태가 양호했으며, 주변에 대형 마트와 초등학교가 가까워 생활 편의성이 뛰어납니다. 다만 주차 공간이 협소하고, 단지 내 보안 카메라 설치가 부족한 점이 아쉬워요. 단지는 전반적으로 관리 상태가 양호했으며, 주변에 대형 마트와 초등학교가 가까워 생활 편의성이 뛰어납니다."),
                                        complexFacility: Facility(familyFacilities: ["어린이집"], multipurposeFacilities: ["해당 없음"], leisureFacilities: ["피트니스 센터", "독서실", "사우나", "목욕탕", "스크린 골프장", " 영화관", "도서관", "수영장"], surroundings: ["잔디밭"], text: "단지는 전반적으로 관리 상태가 양호했으며, 주변에 대형 마트와 초등학교가 가까워 생활 편의성이 뛰어납니다. 다만 주차 공간이 협소하고, 단지 내 보안 카메라 설치가 부족한 점이 아쉬워요. 단지는 전반적으로 관리 상태가 양호했으며, 주변에 대형 마트와 초등학교가 가까워 생활 편의성이 뛰어납니다."),
                                        favorableNews: FavorableNews(transportations: ["잘 모르겠어요"], developments: ["재개발", "재건축", "인근 신도시 개발"], educations: ["잘 모르겠어요"], environments: ["하천 복원", "호수 복원"], cultures: ["대형병원", "문화센터", "도서관", "공연장"], industries: ["산업단지"], policies: ["투기 과열 지구 해제", "일자리 창출 정책"], text: "단지는 전반적으로 관리 상태가 양호했으며, 주변에 대형 마트와 초등학교가 가까워 생활 편의성이 뛰어납니다. 다만 주차 공간이 협소하고, 단지 내 보안 카메라 설치가 부족한 점이 아쉬워요. 단지는 전반적으로 관리 상태가 양호했으며, 주변에 대형 마트와 초등학교가 가까워 생활 편의성이 뛰어납니다."))
    
    static var emptyInsight = InsightDetail(score: 0, mainImage: "", title: "", adress: Adress(siDo: "", siGungu: "", eupMyeonDong: "", buildngNumber: ""), apartmentComplex: "", visitAt: "", visitTimes: [], visitMethods: [], summary: "", access: "", infra: Infrastructure(transportations: [], schoolDistricts: [], amenities: [], facilities: [], surroundings: [], landmarks: [], unpleasantFacilities: [], text: ""), complexEnvironment: Environment(buildingCondition: [""], security: [""], childrenFacility: [""], seniorFacility: [""], text: ""), complexFacility: Facility(familyFacilities: [], multipurposeFacilities: [], leisureFacilities: [], surroundings: [], text: ""), favorableNews: FavorableNews(transportations: [], developments: [], educations: [], environments: [], cultures: [], industries: [], policies: [], text: ""))
}
