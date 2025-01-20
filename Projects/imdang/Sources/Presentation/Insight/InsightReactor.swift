//
//  InsightViewReactor.swift
//  imdang
//
//  Created by daye on 12/31/24.
//

import RxSwift
import RxRelay
import ReactorKit
import Foundation

class InsightReactor: Reactor {
    let disposeBag = DisposeBag()
    
    var detail = InsightDetail.emptyInsight {
        didSet {
            print("update detail info: \(detail)")
        }
    }
    
    struct State {
        var isShowingCameraSheet: Bool = false
        var setCurrentCategory: Int = 0
        // infoBaseView
        var selectedItems: [[String]] = Array(repeating: [], count: 8)
        var checkSectionState: [TextFieldState] = Array(repeating: .normal, count: 8)
    }
    
    enum Action {
        case tapCameraSheet(Bool)
        case tapBackButton
        case tapBaseInfoConfirm(InsightDetail)
        case tapInfraInfoConfirm(Infrastructure)
        case tapEnvironmentInfoConfirm(Environment)
        case tapFacilityInfoConfirm(Facility)
        case tapFavorableNewsInfoConfirm(FavorableNews)
        //        case selectItems(IndexPath, [String])
    }
    
    enum Mutation {
        case showingCameraSheet(Bool)
        case updateBaseInfo(InsightDetail)
        case updateInfra(Infrastructure)
        case updateEnvironment(Environment)
        case updateFacility(Facility)
        case updateFavorableNews(FavorableNews)
        case backSubview
        //        case updateSelectedItems(IndexPath, [String])
    }
    
    let initialState = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .tapCameraSheet(let isShowingSheet):
            return Observable.just(.showingCameraSheet(isShowingSheet))
            //        case .selectItems(let indexPath, let selectedArray):
            //            return Observable.just(.updateSelectedItems(indexPath, selectedArray))
            //        }
        case .tapBaseInfoConfirm(let info):
            return Observable.just(.updateBaseInfo(info))
        case .tapInfraInfoConfirm(let info):
            return Observable.just(.updateInfra(info))
        case .tapEnvironmentInfoConfirm(let info):
            return Observable.just(.updateEnvironment(info))
        case .tapFacilityInfoConfirm(let info):
            return Observable.just(.updateFacility(info))
        case .tapFavorableNewsInfoConfirm(let info):
            return Observable.just(.updateFavorableNews(info))
        case .tapBackButton:
            return Observable.just(.backSubview)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
            
            case .showingCameraSheet(let isShowingSheet):
                newState.isShowingCameraSheet = isShowingSheet
                //        case .updateSelectedItems(let indexPath, let selectedArray):
                ////            newState.selectedItems[indexPath] = selectedArray
                //        }
                
            case .updateBaseInfo(let info):
                detail = info
                newState.setCurrentCategory = 1
            
            case .updateInfra(let info):
                detail.infra = info
                newState.setCurrentCategory = 2
            
            case .updateEnvironment(let info):
                detail.complexEnvironment = info
                newState.setCurrentCategory = 3
            
            case .updateFacility(let info):
                detail.complexFacility = info
                newState.setCurrentCategory = 4
            
            case .updateFavorableNews(let info):
                detail.favorableNews = info
            case .backSubview:
                newState.setCurrentCategory -= 1
        }
        
        return newState
    }
}
