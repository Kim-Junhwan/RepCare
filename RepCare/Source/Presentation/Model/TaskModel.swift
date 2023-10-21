//
//  TaskModel.swift
//  RepCare
//
//  Created by JunHwan Kim on 2023/10/17.
//

import Foundation
import UIKit

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
        switch self {
        case .feed:
            return "Feed"
        case .clean:
            return "Clean"
        case .molt:
            return "star"
        case .spawn:
            return "Spawn"
        case .memo:
            return "Memo"
        }
    }
    
    var timeLineImage: String {
        switch self {
        case .feed:
            return "TimeLineCricket"
        case .clean:
            return "TimeLineClean"
        case .molt:
            return "star"
        case .spawn:
            return "TimeLineEgg"
        case .memo:
            return "TimeLineMemo"
        }
    }
    
    var color: UIColor {
        switch self {
        case .feed:
            return .lightDeepGreen
        case .clean:
            return .lightPink
        case .molt:
            return .oceanBlue
        case .spawn:
            return .lightYellow
        case .memo:
            return .middleGray
        }
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
    
    init(taskType: Task) {
        switch taskType {
        case .feed:
            self = .feed
        case .clean:
            self = .clean
        case .molt:
            self = .molt
        case .spawn:
            self = .spawn
        case .memo:
            self = .memo
        }
    }
}

struct DetailTaskModel {
    let id: String
    let taskType: TaskModel
    let registerDate: Date
    let memo: String?
    
    init(detailTask: DetailTask) {
        self.id = detailTask.id
        self.taskType = .init(taskType: detailTask.taskType)
        self.registerDate = detailTask.registerDate
        self.memo = detailTask.description
    }
}
