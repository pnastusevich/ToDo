//
//  TaskListInteractor.swift
//  ToDoTest
//
//  Created by Паша Настусевич on 19.11.24.
//

import Foundation

protocol TaskListInteractorInputProtocol {
    init(storageManager: StorageManagerProtocol, networkManager: NetworkManagerProtocol, presenter: TaskListInteractorOutputProtocol)
    func fetchTaskList()
    func doneTask(_ task: Task?)
    func deleteTask(_ task: Task)
    func giveStorageManager() -> StorageManagerProtocol
}

protocol TaskListInteractorOutputProtocol: AnyObject {
    func taskListDidReceive(with dataStore: TaskListDataStore)
    func newSavedTaskDidReceived(with newTask: Task)
}

final class TaskListInteractor: TaskListInteractorInputProtocol {
    
    private let storageManager: StorageManagerProtocol
    private let networkManager: NetworkManagerProtocol
    
    private unowned let presenter: TaskListInteractorOutputProtocol
    
    private var isFetchingFromAPI = false
    
    required init(storageManager: StorageManagerProtocol, networkManager: NetworkManagerProtocol, presenter: TaskListInteractorOutputProtocol) {
        self.storageManager = storageManager
        self.networkManager = networkManager
        self.presenter = presenter
    }
    
    func giveStorageManager() -> StorageManagerProtocol {
        return storageManager
    }
    
    // MARK: - Work in Data - CRUD
    func fetchTaskList() {
        storageManager.fetchDataTask { [weak self] result in
            switch result {
            case .success(let taskList):
                if taskList.isEmpty {
                    if !self!.isFetchingFromAPI {
                        self!.isFetchingFromAPI = true
                        self!.fetchTasksFromAPI()
                    }
                } else {
                    let dataStore = TaskListDataStore(tasksList: taskList)
                    self?.presenter.taskListDidReceive(with: dataStore)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchTasksFromAPI() {
        networkManager.fetchData { [weak self] result in
            switch result {
            case .success(let taskList):
                var newTasks: [Task] = []
                let currentDate = Date()
                
                let group = DispatchGroup() // Для отслеживания асинхронных задач
                
                for task in taskList.todos {
                    group.enter()
                    self?.storageManager.createTask(taskName: task.todo, description: "Нет описания у задачи, которая была получена из API", createdDate: currentDate, isCompleted: task.completed) { task in
                        newTasks.append(task)
                        group.leave()
                    }
                }
                
                group.notify(queue: .main) {
                    let dataStore = TaskListDataStore(tasksList: newTasks)
                    self?.presenter.taskListDidReceive(with: dataStore)
                }
                
            case .failure(let error):
                print("\(error.localizedDescription) ошибка в fetchTasksFromAPI")
            }
        }
    }
    
    func doneTask(_ task: Task?) {
        guard let task = task else { return }
        storageManager.doneTask(task)
    }
    
    func deleteTask(_ task: Task) {
        storageManager.deleteTask(task)
        fetchTaskList()
    }
}
