//
//  InsightViewReactor.swift
//  imdang
//
//  Created by daye on 12/31/24.
//

import RxSwift
import ReactorKit
import Foundation

class InsightReactor: Reactor {
    let disposeBag = DisposeBag()
    
    struct State {
        var isShowingCameraSheet: Bool = false
        
        // infoBaseView
        var selectedItems: [[String]] = Array(repeating: [], count: 8)
        var checkSectionState: [TextFieldState] = Array(repeating: .normal, count: 8)
    }
    
    enum Action {
        case tapCameraSheet(Bool)
        //        case selectItems(IndexPath, [String])
    }
    
    enum Mutation {
        case showingCameraSheet(Bool)
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
        }
        
        func reduce(state: State, mutation: Mutation) -> State {
            var newState = state
            
            switch mutation {
                
            case .showingCameraSheet(let isShowingSheet):
                newState.isShowingCameraSheet = isShowingSheet
                //        case .updateSelectedItems(let indexPath, let selectedArray):
                ////            newState.selectedItems[indexPath] = selectedArray
                //        }
                
                return newState
            }
            
        }
        
    }}
