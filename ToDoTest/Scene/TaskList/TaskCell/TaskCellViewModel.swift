//
//  TaskCellViewModel.swift
//  ToDoTest
//
//  Created by Паша Настусевич on 20.11.24.
//

import Foundation

protocol TaskCellViewModelProtocol {
    var name: String { get }
    var subname: String { get }
    var isCompleted: Bool { get set }
    var createdAt: Date { get }
    var task: Task { get }
    init(tasksList: Task)
}

protocol TaskSectionViewModelProtocol {
    var rows: [TaskCellViewModelProtocol] { get set }
    var numberOfRows: Int { get }
}

final class TaskCellViewModel: TaskCellViewModelProtocol {
  
    var name: String {
        tasksList.name ?? "task name"
    }
    
    var subname: String {
        tasksList.subname ?? "description"
    }
    
    var isCompleted: Bool {
        get { tasksList.isCompleted
        }
        set {
            tasksList.isCompleted = newValue
            }
    }
    
    var task: Task {
            return tasksList
        }
    
    var createdAt: Date {
        tasksList.createdAt ?? Date()
    }

    private let tasksList: Task
    
    required init(tasksList: Task) {
        self.tasksList = tasksList
    }
}

final class TaskSectionViewModel: TaskSectionViewModelProtocol {
    var rows: [TaskCellViewModelProtocol] = []
    var numberOfRows: Int {
        rows.count
    }
}

