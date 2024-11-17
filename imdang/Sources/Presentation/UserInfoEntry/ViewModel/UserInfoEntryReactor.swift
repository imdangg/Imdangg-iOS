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
        var submitButtonEnabled: CommonButtonType
    }
    
    // v -> r
    enum Action {
        case submmited(String)
        case changeNicknameTextFieldState(TextFieldState)
        case changeBirthTextFieldState(TextFieldState)
        case tapGenderButton(Gender)
        case submitButtonTapped
    }
    
    // r -> v
    enum Mutation {
        case isloginSusses(Bool)
        case changeNicknameTextFieldState(TextFieldState)
        case changeBirthTextFieldState(TextFieldState)
        case changeSelectedGender(Gender)
        case isEnableSubmitButton(TextFieldState, TextFieldState)
    }
    
    var initialState: State
    
    init() {
        self.initialState = State(loginResult: false, nicknameTextfieldState: .normal, bitrhTextFieldState: .normal, selectedGender: .none ,submitButtonEnabled: .enabled)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .changeNicknameTextFieldState(let state):
            return Observable.just(.changeNicknameTextFieldState(state))
            
        case .changeBirthTextFieldState(let state):
            return Observable.just(.changeBirthTextFieldState(state))
            
        case .submmited(let id):
            return Observable.just(.isloginSusses(id.isEmpty ? false : true))
            
        case .submitButtonTapped:
            print("tap")
            return Observable.just(.isloginSusses(true))
            
        case .tapGenderButton(let gender):
            return Observable.just(.changeSelectedGender(gender))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .isloginSusses:
            print("로그인 성공")
            state.submitButtonEnabled = .disabled
            
        case .changeNicknameTextFieldState(let textFieldState):
            state.nicknameTextfieldState = textFieldState
            print("nickNameTextfieldState: \(textFieldState)\n")
            
        case .changeBirthTextFieldState(let textFieldState):
            state.bitrhTextFieldState = textFieldState
            print("bitrhTextFieldState: \(textFieldState)\n")
            
        case .isEnableSubmitButton(let nicknameTextField, let birthTextField):
            if nicknameTextField == .done && birthTextField == .done {
                state.submitButtonEnabled = .enabled
            }else {
                state.submitButtonEnabled = .disabled
            }
        case .changeSelectedGender(let gender):
            state.selectedGender = gender
            print("selectedGender: \(gender)")
        }
        return state
    }
}

