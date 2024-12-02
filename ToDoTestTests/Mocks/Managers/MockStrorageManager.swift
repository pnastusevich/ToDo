//
//  MockStrorageManager.swift
//  ToDoTestTests
//
//  Created by Паша Настусевич on 27.11.24.
//

import CoreData
import XCTest
@testable import ToDoTest

final class MockStorageManager: StorageManagerProtocol {
    var fetchTasksResult: Result<[Task], Error> = .success([])
    var createdTasks: [Task] = []
    var deletedTask: Task?
    var doneTask: Task?

    private let mockContext: NSManagedObjectContext

    init(mockContext: NSManagedObjectContext) {
        self.mockContext = mockContext
    }

    func createTask(taskName: String, description: String, createdDate: Date, isCompleted: Bool, completion: @escaping (Task) -> Void) {
        let task = Task(context: mockContext)
        task.name = taskName
        task.subname = description
        task.createdAt = createdDate
        task.isCompleted = isCompleted

        createdTasks.append(task)
        completion(task)
    }

    func fetchDataTask(completion: @escaping (Result<[Task], Error>) -> Void) {
        completion(fetchTasksResult)
    }

    func updateTask(_ task: Task, taskName: String, description: String, createdDate: Date, isCompleted: Bool) {}

    func doneTask(_ task: Task) {
         task.isCompleted = true
         doneTask = task
     }

    func deleteTask(_ task: Task) {
        deletedTask = task
    }

    func saveContext() {}
}

// MARK: - CoreDataTestHelpers
extension MockStorageManager {
    static func createMockContext() -> NSManagedObjectContext {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: nil)!
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType,
                                                              configurationName: nil,
                                                              at: nil,
                                                              options: nil)
        } catch {
            fatalError("Ошибка при создании мок-памяти: \(error)")
        }
        
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        return context
    }
}
