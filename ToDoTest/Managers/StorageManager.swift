//
//  StorageManager.swift
//  ToDoTest
//
//  Created by Паша Настусевич on 19.11.24.
//

import CoreData

protocol StorageManagerProtocol {
    func createTask(taskName: String, description: String, createdDate: Date, isCompleted: Bool, completion: @escaping (Task) -> Void)
    func fetchDataTask(completion: @escaping (Result<[Task], Error>) -> Void)
    func updateTask(_ task: Task, taskName: String, description: String, createdDate: Date, isCompleted: Bool)
    func doneTask(_ task: Task)
    func deleteTask(_ task: Task)
    func saveContext()
}

final class StorageManager: StorageManagerProtocol {

    private let viewContext: NSManagedObjectContext
    private let persistentContainer: NSPersistentContainer
    private var isSaving = false
    
    init(containerName: String = "TasksModel") {
        self.persistentContainer = NSPersistentContainer(name: containerName)
        self.persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        self.viewContext = persistentContainer.viewContext
    }
    
    // MARK: - CRUD
    func createTask(taskName: String, description: String, createdDate: Date, isCompleted: Bool, completion: @escaping (Task) -> Void) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            let task = Task(context: self.viewContext)
            task.name = taskName
            task.subname = description
            task.createdAt = createdDate
            task.isCompleted = isCompleted
            self.saveContext()
            
            DispatchQueue.main.async {
                completion(task)
            }
        }
    }
    
    func fetchDataTask(completion: @escaping (Result<[Task], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            let fetchRequest = Task.fetchRequest()
            
            do {
                let task = try self.viewContext.fetch(fetchRequest)
                DispatchQueue.main.async {
                    completion(.success(task))
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func updateTask(_ task: Task, taskName: String, description: String, createdDate: Date, isCompleted: Bool) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            task.name = taskName
            task.subname = description
            task.createdAt = createdDate
            task.isCompleted = isCompleted
            self.saveContext()
        }
    }
    
    func doneTask(_ task: Task) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            task.isCompleted.toggle()
            self.saveContext()
        }
    }
    
    func deleteTask(_ task: Task) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            self.viewContext.delete(task)
            self.saveContext()
        }
    }
    
    // MARK: - Core Data Saving support
    func saveContext() {
        guard !isSaving else { return }
        isSaving = true
        
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        
        isSaving = false
    }
}
