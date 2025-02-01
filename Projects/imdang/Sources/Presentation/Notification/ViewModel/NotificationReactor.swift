//
//  NotificationReactori.swift
//  imdang
//
//  Created by daye on 1/21/25.
//


import Foundation
import ReactorKit

struct MockNoti: Equatable {
    let username: String
    let type: NotiType
}

enum NotiType {
    case request_accept
    case request_reject
    case response
}

enum NotificationType: String, Equatable {
    case all = "전체"
    case request = "내가 요청한 내역"
    case response = "요청 받은 내역"
}

final class NotificationReactor: Reactor {

    struct State {
        var notifications: [MockNoti] = []
        var selectedNotificationType: NotificationType
    }

    enum Action {
        case tapNotificationTypeButton(NotificationType)
        case loadNotifications
    }

    enum Mutation {
        case changeSelectedNotificationType(NotificationType)
        case setNotifications([MockNoti])
    }

    var initialState: State

    init() {
        self.initialState = State(selectedNotificationType: .all)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadNotifications:
            // Mock
            let mockNotifications = (1...6).map { index in
                MockNoti(
                    username: "User \(index)",
                    type: index % 3 == 0 ? .request_accept : (index % 2 == 0 ? .request_reject : .response)
                )
            }
            return Observable.just(.setNotifications(mockNotifications))
            
        case .tapNotificationTypeButton(let notificationType):
            return Observable.just(.changeSelectedNotificationType(notificationType))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state

        switch mutation {
        case .changeSelectedNotificationType(let notificationType):
            state.selectedNotificationType = notificationType
        case .setNotifications(let notifications):
            state.notifications = notifications
        }
        return state
    }  
}
