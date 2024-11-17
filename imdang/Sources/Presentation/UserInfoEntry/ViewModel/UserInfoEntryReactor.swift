//
//  UserInfoEntryReactor.swift
//  imdang
//
//  Created by daye on 11/14/24.
//


import Foundation
import ReactorKit

enum Gender {
    case none
    case man
    case woman
}

class UserInfoEntryReactor: Reactor {
    
    struct State {
        var loginResult: Bool
        
        var nicknameTextfieldState: TextFieldState
        var bitrhTextFieldState: TextFieldState
        var selectedGender: Gender
        var submitButtonEnabled: Bool
    }
    
    // v -> r
    enum Action {
       
        case changeNicknameTextFieldState(TextFieldState)
        case changeBirthTextFieldState(TextFieldState)
        case tapGenderButton(Gender)
        case checkEnableSubmitButton(Bool)
       // case submitButtonTapped
    }
    
    // r -> v
    enum Mutation {
        
        case changeNicknameTextFieldState(TextFieldState)
        case changeBirthTextFieldState(TextFieldState)
        case changeSelectedGender(Gender)
        case isEnableSubmitButton(Bool)
    }
    
    var initialState: State
    
    init() {
        self.initialState = State(loginResult: false, nicknameTextfieldState: .normal, bitrhTextFieldState: .normal, selectedGender: .none ,submitButtonEnabled: false)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .changeNicknameTextFieldState(let state):
            return Observable.just(.changeNicknameTextFieldState(state))
            
        case .changeBirthTextFieldState(let state):
            return Observable.just(.changeBirthTextFieldState(state))
            
        case .tapGenderButton(let gender):
            return Observable.just(.changeSelectedGender(gender))
            
//        case .submitButtonTapped:
//            <#code#>
            
        case .checkEnableSubmitButton(let bool):
            return Observable.just(.isEnableSubmitButton(bool))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .isEnableSubmitButton(let bool):
            state.submitButtonEnabled = bool
                
        case .changeNicknameTextFieldState(let textFieldState):
            state.nicknameTextfieldState = textFieldState
            print("nickNameTextfieldState: \(textFieldState)\n")
            
        case .changeBirthTextFieldState(let textFieldState):
            state.bitrhTextFieldState = textFieldState
            print("bitrhTextFieldState: \(textFieldState)\n")
            
        case .changeSelectedGender(let gender):
            state.selectedGender = gender
            print("selectedGender: \(gender)")
        }
        return state
    }
}

