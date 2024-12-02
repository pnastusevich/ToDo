//
//  NetworkManager.swift
//  ToDoTest
//
//  Created by Паша Настусевич on 19.11.24.
//

import Foundation

protocol NetworkManagerProtocol {
    func fetchData(completion: @escaping (Result<TasksInApi, NetworkError>) -> Void)
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

final class NetworkManager: NetworkManagerProtocol {
    func fetchData(completion: @escaping (Result<TasksInApi, NetworkError>) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/todos") else {
            completion(.failure(.invalidURL))
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data else {
                completion(.failure(.noData))
                return
            }
            do {
                let tasks = try JSONDecoder().decode(TasksInApi.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(tasks))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
