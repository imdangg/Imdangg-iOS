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
    }
    
    enum Action {
        case tapExchangeStateButton(ExchangeState)
    }
    
    enum Mutation {
        case changeSelectedExchangeState(ExchangeState)
    }
    
    var initialState: State
    
    init() {
        self.initialState = State(selectedExchangeState: .waiting)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        case .tapExchangeStateButton(let exchangeState):
            return Observable.just(.changeSelectedExchangeState(exchangeState))
        }
    }
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
            
        case .changeSelectedExchangeState(let exchangeState):
            state.selectedExchangeState = exchangeState
            print("\(exchangeState)")
        }
        return state
    }
}
