//
//  ExchangeViewReactor.swift
//  imdang
//
//  Created by daye on 12/5/24.
//

import Foundation
import ReactorKit


final class ExchangeReactor: Reactor {
    
    struct State {
        var selectedExchangeState: ExchangeState
        var selectedRequestState: ExchangeRequestState
    }
    
    enum Action {
        case tapExchangeStateButton(ExchangeState)
        case selectedRequestSegmentControl(ExchangeRequestState)
    }
    
    enum Mutation {
        case changeSelectedExchangeState(ExchangeState)
        case changeSelectedRequestState(ExchangeRequestState)
    }
    
    var initialState: State
    
    init() {
        self.initialState = State(selectedExchangeState: .waiting, selectedRequestState: .request)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        case .tapExchangeStateButton(let exchangeState):
            return Observable.just(.changeSelectedExchangeState(exchangeState))
        case .selectedRequestSegmentControl(let requestState):
            return Observable.just(.changeSelectedRequestState(requestState))
        }
    }
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
            
        case .changeSelectedExchangeState(let exchangeState):
            state.selectedExchangeState = exchangeState
            print("\(exchangeState)")
        case .changeSelectedRequestState(let requestState):
            state.selectedRequestState = requestState
            print("\(requestState)")
        }
        return state
    }
}
