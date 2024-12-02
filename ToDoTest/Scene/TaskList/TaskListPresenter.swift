//
//  TaskListPresenter.swift
//  ToDoTest
//
//  Created by Паша Настусевич on 19.11.24.
//

import Foundation

struct TaskListDataStore {
    var tasksList: [Task]
    let section = TaskSectionViewModel()
}

final class TaskListPresenter: TaskListViewOutputProtocol {    
   
    var interactor: TaskListInteractorInputProtocol!
    var router: TaskListRouterInputProtocol!
    
    private unowned let view: TaskListViewInputProtocol
    private var dataStore: TaskListDataStore?
    internal var sectionViewModel: TaskSectionViewModelProtocol = TaskSectionViewModel()
    
    required init(view: any TaskListViewInputProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        interactor.fetchTaskList()
    }
    
    func doneTasks(at index: Int) {
        guard let dataStore = dataStore else { return }
        
        dataStore.tasksList[index].isCompleted = true
        let taskCellViewModel = dataStore.section.rows[index] as? TaskCellViewModel
        taskCellViewModel?.isCompleted = true
        interactor.doneTask(dataStore.tasksList[index])
        view.reloadData(for: dataStore.section)
    }
    
    func editTask(with task: TaskCellViewModelProtocol) {
        router.openTaskDetailsViewController(with: task.task, storageManager: interactor.giveStorageManager())
    }
    
    func shareTask(with task: TaskCellViewModelProtocol) {
        print("share task")
    }
    
    func deleteTask(with task: TaskCellViewModelProtocol) {
        interactor.deleteTask(task.task)
    }
    
    func didTapAddTaskButton() {
        router.openNewTaskViewController(storageManager: interactor.giveStorageManager())
    }
    
    func updateTask(_ task: Task) {
        view.reloadData(for: dataStore!.section)
    }
    
    func searchTasks(with query: String) {
        guard let dataStore = dataStore else { return }
        
            let filteredRows: [TaskCellViewModelProtocol]
            
            if query.isEmpty {
                filteredRows = dataStore.section.rows
            } else {
                filteredRows = dataStore.section.rows.filter { viewModel in
                    guard let taskViewModel = viewModel as? TaskCellViewModel else { return false }
                    let taskName = taskViewModel.task.name!.lowercased()
                    let taskSubname = taskViewModel.task.subname!.lowercased()
                    return taskName.contains(query.lowercased()) || taskSubname.contains(query.lowercased())
                }
            }
            
            let updatedSection = TaskSectionViewModel()
            updatedSection.rows.append(contentsOf: filteredRows)
            view.reloadData(for: updatedSection)
    }
}

// MARK: - TaskListInteractorOutputProtocol
extension TaskListPresenter: TaskListInteractorOutputProtocol {
    func taskListDidReceive(with dataStore: TaskListDataStore) {
        self.dataStore = dataStore

        for task in dataStore.tasksList {
            let tasksCellViewModel = TaskCellViewModel(tasksList: task)
            dataStore.section.rows.append(tasksCellViewModel)
        }
        view.reloadData(for: dataStore.section)
    }
    
    func newSavedTaskDidReceived(with newTask: Task) {
        dataStore?.tasksList.append(newTask)
        
        let taskCellViewModel = TaskCellViewModel(tasksList: newTask)
        dataStore?.section.rows.append(taskCellViewModel)
        view.reloadData(for: dataStore!.section)
    }
}

