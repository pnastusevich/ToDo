//
//  MockTaskListInteractor.swift
//  ToDoTestTests
//
//  Created by Паша Настусевич on 27.11.24.
//

import XCTest
@testable import ToDoTest

final class MockTaskListInteractor: TaskListInteractorInputProtocol {
    var fetchTaskListCalled = false
    var doneTaskCalled = false
    var deleteTaskCalled = false
    var taskList: [Task] = []

    required init(storageManager: StorageManagerProtocol, networkManager: NetworkManagerProtocol, presenter: TaskListInteractorOutputProtocol) {}
    
    func fetchTaskList() {
        fetchTaskListCalled = true
    }

    func doneTask(_ task: Task?) {
        doneTaskCalled = true
    }

    func deleteTask(_ task: Task) {
        deleteTaskCalled = true
    }

    func giveStorageManager() -> StorageManagerProtocol {
        return MockStorageManager(mockContext: MockStorageManager.createMockContext())
    }
}
