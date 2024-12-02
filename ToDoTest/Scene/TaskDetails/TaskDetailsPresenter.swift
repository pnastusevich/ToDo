//
//  TaskDetailsPresenter.swift
//  ToDoTest
//
//  Created by Паша Настусевич on 21.11.24.
//

import Foundation

final class TaskDetailsPresenter: TaskDetailsViewOutputProtocol {
   
    var interactor: TaskDetailsInteractorInputProtocol!
    private unowned let view: TaskDetailsViewInputProtocol
    
    required init(view: TaskDetailsViewInputProtocol) {
        self.view = view
    }
    
    func loadTaskDetails() {
        if let task = interactor.loadTask() {
            view.displayTask(name: task.name ?? "Без названия",
                             description: task.subname ?? "Без описания",
                             date: task.createdAt ?? Date()
            )
        } else {
            view.displayTask(name: "Добавьте название",
                             description: "Опишите задачу",
                             date: Date()
            )
        }
    }
    
    func saveTask(name: String, description: String, date: Date) {
        interactor.saveTask(name: name, description: description, date: date)
    }
}

// MARK: - TaskDetailsInteractorOutputProtocol
extension TaskDetailsPresenter: TaskDetailsInteractorOutputProtocol {
    func newSavedTaskDidReceived(with newTask: Task) {
    }
}


