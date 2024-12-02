//
//  TaskListConfigurator.swift
//  ToDoTest
//
//  Created by Паша Настусевич on 19.11.24.
//

import UIKit

protocol TaskListConfiguratorInputProtocol {
    func createModule(storageManager: StorageManagerProtocol, networkManager: NetworkManagerProtocol) -> UIViewController
}

final class TaskListConfigurator: TaskListConfiguratorInputProtocol {
    func createModule(storageManager: StorageManagerProtocol, networkManager: NetworkManagerProtocol) -> UIViewController {
        
        let view = TaskListViewController()
        let presenter = TaskListPresenter(view: view)
        let interactor = TaskListInteractor(storageManager: storageManager, networkManager: networkManager, presenter: presenter)
        
        let router = TaskListRouter(view: view)
    
        view.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
        
        return view
    }
}
