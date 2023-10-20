//
//  TaskModel.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/17.
//

import Foundation

enum TaskModel: Int, CaseIterable {
    case feed
    case clean
    case molt
    case spawn
    case memo
    
    var title: String {
        switch self {
        case .feed:
            return "먹이 급여"
        case .clean:
            return "청소"
        case .molt:
            return "탈피"
        case .spawn:
            return "산란"
        case .memo:
            return "메모"
        }
    }
    
    var image: String {
        return "star"
    }
    
    func toDomain() ->  Task {
        switch self {
        case .feed:
            return .feed
        case .clean:
            return .clean
        case .molt:
            return .molt
        case .spawn:
            return .spawn
        case .memo:
            return .memo
        }
    }
}

struct DetailTaskModel {
    let taskType: TaskModel
    let registerDate: Date
    let memo: String?
}
