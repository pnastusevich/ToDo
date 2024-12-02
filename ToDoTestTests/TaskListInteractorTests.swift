//
//  ToDoTestTests.swift
//  ToDoTestTests
//
//  Created by Паша Настусевич on 27.11.24.
//

import XCTest
@testable import ToDoTest


final class TaskListInteractorTests: XCTestCase {

    override func setUp()  {
        super.setUp()
        
    }

    override func tearDown()  {
        super.tearDown()
    }

    func testFetchTaskListFromCoreData() {
        let mockContext = MockStorageManager.createMockContext()
        let mockStorageManager = MockStorageManager(mockContext: mockContext)
        let mockPresenter = MockTaskListPresenter()
        let mockNetworkManager = MockNetworkManager()

        let task = Task(context: mockContext)
        task.name = "Core Data Task"
        task.subname = "Task from Core Data"
        task.isCompleted = false
        task.createdAt = Date()
        mockStorageManager.fetchTasksResult = .success([task])
        
        let interactor = TaskListInteractor(
            storageManager: mockStorageManager,
            networkManager: mockNetworkManager,
            presenter: mockPresenter
        )
        interactor.fetchTaskList()
        XCTAssertEqual(mockPresenter.receivedTasks?.tasksList.count, 1)
        XCTAssertEqual(mockPresenter.receivedTasks?.tasksList.first?.name, "Core Data Task")
    }
    
    func testFetchTaskListFromAPIWhenCoreDataIsEmpty() {
        let mockContext = MockStorageManager.createMockContext()
        let mockStorageManager = MockStorageManager(mockContext: mockContext)
        let mockPresenter = MockTaskListPresenter()
        let mockNetworkManager = MockNetworkManager()

        mockStorageManager.fetchTasksResult = .success([])
        mockNetworkManager.fetchResult = .success(TasksInApi(
            todos: [
                Tasks(id: 0, todo: "API Task 1", completed: false),
                Tasks(id: 1, todo: "API Task 2", completed: true)
            ],
            total: 2
        ))

        let interactor = TaskListInteractor(
            storageManager: mockStorageManager,
            networkManager: mockNetworkManager,
            presenter: mockPresenter
        )

        let expectation = self.expectation(description: "Waiting for task list")
        mockPresenter.didReceiveTaskList = {
            expectation.fulfill()
        }
        interactor.fetchTaskList()
        
        waitForExpectations(timeout: 2.0, handler: nil)
        XCTAssertEqual(mockPresenter.receivedTasks?.tasksList.count, 2)
        XCTAssertEqual(mockPresenter.receivedTasks?.tasksList.first?.name, "API Task 1")
    }
    
    func testDoneTaskUpdatesTaskState() {
        let mockContext = MockStorageManager.createMockContext()
        let mockStorageManager = MockStorageManager(mockContext: mockContext)
        let mockPresenter = MockTaskListPresenter()
        let mockNetworkManager = MockNetworkManager()

        let task = Task(context: mockContext)
        task.name = "Task to Complete"
        task.subname = "Pending Task"
        task.isCompleted = false
        task.createdAt = Date()

        mockStorageManager.fetchTasksResult = .success([task])

        let interactor = TaskListInteractor(
            storageManager: mockStorageManager,
            networkManager: mockNetworkManager,
            presenter: mockPresenter
        )

        interactor.doneTask(task)

        XCTAssertTrue(task.isCompleted)
        XCTAssertEqual(task.name, "Task to Complete")
    }
    
    func testDeleteTaskRemovesTaskFromCoreData() {
        let mockContext = MockStorageManager.createMockContext()
        let mockStorageManager = MockStorageManager(mockContext: mockContext)
        let mockPresenter = MockTaskListPresenter()
        let mockNetworkManager = MockNetworkManager()

        let task = Task(context: mockContext)
        task.name = "Task to Delete"
        task.subname = "Temporary Task"
        task.isCompleted = false
        task.createdAt = Date()

        mockStorageManager.fetchTasksResult = .success([task])

        let interactor = TaskListInteractor(
            storageManager: mockStorageManager,
            networkManager: mockNetworkManager,
            presenter: mockPresenter
        )
        interactor.deleteTask(task)
        XCTAssertEqual(mockStorageManager.deletedTask, task)
    }
}
