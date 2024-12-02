//
//  MockTaskListRouter.swift
//  ToDoTestTests
//
//  Created by Паша Настусевич on 27.11.24.
//

import XCTest
@testable import ToDoTest

final class MockTaskListRouter: TaskListRouterInputProtocol {
    var viewController: TaskListViewController?

    required init(view: TaskListViewController) {
        self.viewController = view
    }

    func openTaskDetailsViewController(with task: Task, storageManager: StorageManagerProtocol) {
    }

    func openNewTaskViewController(storageManager: StorageManagerProtocol) {
    }
}
