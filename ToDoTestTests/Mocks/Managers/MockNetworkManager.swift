//
//  MockNetworkManager.swift
//  ToDoTestTests
//
//  Created by Паша Настусевич on 27.11.24.
//

import XCTest
@testable import ToDoTest

final class MockNetworkManager: NetworkManagerProtocol {
    var fetchResult: Result<TasksInApi, NetworkError> = .success(TasksInApi(todos: [], total: 0))

    func fetchData(completion: @escaping (Result<TasksInApi, NetworkError>) -> Void) {
        completion(fetchResult)
    }
}
