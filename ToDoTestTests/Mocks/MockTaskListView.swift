//
//  MockTaskListView.swift
//  ToDoTestTests
//
//  Created by Паша Настусевич on 27.11.24.
//

import XCTest
@testable import ToDoTest

final class MockTaskListView: TaskListViewInputProtocol {
    var reloadDataCalled = false
    var section: TaskSectionViewModel?

    func reloadData(for section: TaskSectionViewModel) {
        reloadDataCalled = true
        self.section = section
    }
}
