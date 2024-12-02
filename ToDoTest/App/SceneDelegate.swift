//
//  SceneDelegate.swift
//  ToDoTest
//
//  Created by Паша Настусевич on 19.11.24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private let dependencyFactory = ManagersFactory()
    private let configurator: TaskListConfiguratorInputProtocol = TaskListConfigurator()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let storageManager = dependencyFactory.makeStorageManager()
        let networkManager = dependencyFactory.makeNetworkManager()
        
        let taskListModule = configurator.createModule(
            storageManager: storageManager,
            networkManager: networkManager
        )
        
        let navigationController = UINavigationController(rootViewController: taskListModule)
        
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
        window?.rootViewController = navigationController
    }
    

    func sceneDidEnterBackground(_ scene: UIScene) {
        let storageManager = dependencyFactory.makeStorageManager()
        storageManager.saveContext()
        }
    }


