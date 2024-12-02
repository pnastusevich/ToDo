//
//  TaskListPresenterTests.swift
//  ToDoTestTests
//
//  Created by Паша Настусевич on 27.11.24.
//

import XCTest
@testable import ToDoTest

final class TaskListPresenterTests: XCTestCase {
    var presenter: TaskListPresenter!
    var mockView: MockTaskListView!
    var mockInteractor: MockTaskListInteractor!
    var mockRouter: MockTaskListRouter!

    override func setUp() {
        super.setUp()

        mockView = MockTaskListView()
        mockRouter = MockTaskListRouter(view: TaskListViewController())
        mockInteractor = MockTaskListInteractor(storageManager: MockStorageManager(mockContext: MockStorageManager.createMockContext()), networkManager: MockNetworkManager(), presenter: MockTaskListPresenter())

        presenter = TaskListPresenter(view: mockView)
        presenter.interactor = mockInteractor
        presenter.router = mockRouter
    }

    override func tearDown() {
        super.tearDown()
    }

    func testViewDidLoadCallsFetchTaskList() {
        presenter.viewDidLoad()

        XCTAssertTrue(mockInteractor.fetchTaskListCalled)
    }
}
