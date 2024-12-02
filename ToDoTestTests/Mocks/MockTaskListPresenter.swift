//
//  File.swift
//  ToDoTestTests
//
//  Created by Паша Настусевич on 27.11.24.
//

import XCTest
@testable import ToDoTest

final class MockTaskListPresenter: TaskListInteractorOutputProtocol {
    var receivedTasks: TaskListDataStore?
    var didReceiveTaskList: (() -> Void)?

    func taskListDidReceive(with dataStore: TaskListDataStore) {
        self.receivedTasks = dataStore
        didReceiveTaskList?()
    }

    func newSavedTaskDidReceived(with newTask: Task) {
      
    }
}
