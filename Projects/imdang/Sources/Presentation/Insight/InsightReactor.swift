//
//  InsightViewReactor.swift
//  imdang
//
//  Created by daye on 12/31/24.
//

import RxSwift
import ReactorKit

class InsightReactor: Reactor {
    let disposeBag = DisposeBag()
    
    struct State {
        var isShowingCameraSheet: Bool = false
    }
    
    enum Action {
        case tapCameraSheet(Bool)
    }
    
    enum Mutation {
        case showingCameraSheet(Bool)
    }
    
    let initialState = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .tapCameraSheet(let isShowingSheet):
            return Observable.just(.showingCameraSheet(isShowingSheet))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
            
        case .showingCameraSheet(let isShowingSheet):
            newState.isShowingCameraSheet = isShowingSheet
        }
        
        return newState
    }
   
}

