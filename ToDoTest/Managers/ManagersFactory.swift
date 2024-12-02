//
//  ManagersFactory.swift
//  ToDoTest
//
//  Created by Паша Настусевич on 20.11.24.
//

protocol StorageManagerProtocolFactory {
    func makeStorageManager() -> StorageManagerProtocol
}

protocol NetworkManagerProtocolFactory {
    func makeNetworkManager() -> NetworkManagerProtocol
}

final class ManagersFactory: StorageManagerProtocolFactory, NetworkManagerProtocolFactory {
    func makeStorageManager() -> StorageManagerProtocol {
        return StorageManager()
    }

    func makeNetworkManager() -> NetworkManagerProtocol {
        return NetworkManager()
    }
}
