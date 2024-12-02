//
//  TaskDetailsConfigurator.swift
//  ToDoTest
//
//  Created by Паша Настусевич on 21.11.24.
//

import Foundation

protocol TaskDetailsConfiguratorInputProtocol {
    func configureDetailTask(withView view: TaskDetailsViewController, and task: Task, and storageManager: StorageManagerProtocol)
    func configureNewTask(withView view: TaskDetailsViewController, and storageManager: StorageManagerProtocol)
}

final class TaskDetailsConfigurator: TaskDetailsConfiguratorInputProtocol {
    
    func configureNewTask(withView view: TaskDetailsViewController, and storageManager: StorageManagerProtocol) {
        let presenter = TaskDetailsPresenter(view: view)
        let interactor = TaskDetailsInteractor(presenter: presenter, storageManager: storageManager)
        view.presenter = presenter
        presenter.interactor = interactor
    }
    
    func configureDetailTask(withView view: TaskDetailsViewController, and task: Task, and storageManager: StorageManagerProtocol) {
        let presenter = TaskDetailsPresenter(view: view)
    
        let interactor = TaskDetailsInteractor(presenter: presenter, task: task, storageManager: storageManager)
        view.presenter = presenter
        presenter.interactor = interactor
    }
}
