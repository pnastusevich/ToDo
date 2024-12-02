//
//  TaskDetailsInteractor.swift
//  ToDoTest
//
//  Created by Паша Настусевич on 21.11.24.
//

import Foundation

protocol TaskDetailsInteractorInputProtocol {
    init(presenter: TaskDetailsInteractorOutputProtocol, task: Task?, storageManager: StorageManagerProtocol)
    
    func loadTask() -> Task?
    func saveTask(name: String, description: String, date: Date)
}

protocol TaskDetailsInteractorOutputProtocol: AnyObject {
    func newSavedTaskDidReceived(with newTask: Task)
}

final class TaskDetailsInteractor: TaskDetailsInteractorInputProtocol {
        
    private unowned let presenter: TaskDetailsInteractorOutputProtocol
    private var task: Task?
    private let storageManager: StorageManagerProtocol
    
   
    init(presenter: TaskDetailsInteractorOutputProtocol, task: Task? = nil, storageManager: StorageManagerProtocol) {
        self.presenter = presenter
        self.task = task
        self.storageManager = storageManager
    }
    
    func loadTask() -> Task? {
        return task
    }
    
    func saveTask(name: String, description: String, date: Date) {
        if let task = task {
            task.name = name
            task.subname = description
            task.createdAt = date
            storageManager.updateTask(task,
                                      taskName: name,
                                      description: description,
                                      createdDate: date,
                                      isCompleted: false
            )
        } else {
            storageManager.createTask(taskName: name,
                                      description: description,
                                      createdDate: date,
                                      isCompleted: false
            ) { newTask in
                self.presenter.newSavedTaskDidReceived(with: newTask)
            }
        }
    }
}
