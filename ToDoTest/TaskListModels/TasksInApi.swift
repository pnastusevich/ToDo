//
//  TasksInApi.swift
//  ToDoTest
//
//  Created by Паша Настусевич on 19.11.24.
//

import Foundation

struct TasksInApi: Decodable {
    
    let todos: [Tasks]
    let total: Int
}
    struct Tasks: Decodable {
        let id: Int
        let todo: String
        let completed: Bool
}
