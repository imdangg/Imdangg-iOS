//
//  InsightWriteService.swift
//  SharedLibraries
//
//  Created by 임대진 on 1/17/25.
//

import UIKit
import NetworkKit
import RxSwift
import Alamofire
import CoreLocation

final class InsightWriteService {
    static let shared = InsightWriteService()
    
    private var disposeBag = DisposeBag()
    private let networkManager = NetworkManager()

    func createInsight(dto: InsightDTO, image: UIImage) -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            let url = "http://imdang.info/insights/create"
            
            guard let jsonData = try? JSONEncoder().encode(dto) else {
                return Disposables.create()
            }
            
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(UserdefaultKey.accessToken)"
            ]
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(jsonData, withName: "createInsightCommand", mimeType: "application/json")
                
                if let imageData = image.jpegData(compressionQuality: 0.2) {
                    multipartFormData.append(imageData, withName: "mainImage", fileName: "image.jpg", mimeType: "image/jpeg")
                }
                
            }, to: url, method: .post, headers: headers)
            .validate()
            .response { response in
                switch response.result {
                case .success(let data):
                    if let data = data {
                        print("Upload successful: \(String(data: data, encoding: .utf8) ?? "")")
                        observer.onNext(true)
                    } else {
                        print("Upload successful but no data received.")
                        observer.onNext(true)
                    }
                case .failure(let error):
                    print("Upload error: \(error)")
                    observer.onNext(false)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func getCoordinates(address: String, completion: @escaping (Double?, Double?) -> Void) {

        let url = "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?query=\(address)"
        
        if let APIID = Bundle.main.object(forInfoDictionaryKey: "NAVER_APP_KEY_ID") as? String, let APIKEY = Bundle.main.object(forInfoDictionaryKey: "NAVER_APP_KEY") as? String {
            let headers: HTTPHeaders = [
                "X-NCP-APIGW-API-KEY-ID": APIID,
                "X-NCP-APIGW-API-KEY": APIKEY,
                "Accept": "application/json"
            ]

            AF.request(url, method: .get, headers: headers)
                .validate()
                .responseDecodable(of: NaverGeocodeResponse.self) { response in
                    switch response.result {
                    case .success(let result):
                        if let firstResult = result.addresses.first {
                            let latitude = Double(firstResult.y)
                            let longitude = Double(firstResult.x)
                            completion(latitude, longitude)
                        } else {
                            completion(nil, nil)
                        }
                    case .failure(let error):
                        print("네이버 Geocoding API 오류: \(error)")
                        completion(nil, nil)
                    }
                }
        }
    }
}

struct NaverGeocodeResponse: Codable {
    let status: String
    let meta: Meta
    let addresses: [Address]
    let errorMessage: String?
    
    struct Meta: Codable {
        let totalCount: Int
        let page: Int
        let count: Int
    }
    
    struct Address: Codable {
        let roadAddress: String
        let jibunAddress: String
        let englishAddress: String
        let addressElements: [AddressElement]
        let x: String  // 경도 (Longitude)
        let y: String  // 위도 (Latitude)
        let distance: Double
    }
    
    struct AddressElement: Codable {
        let types: [String]
        let longName: String
        let shortName: String
        let code: String
    }
}
