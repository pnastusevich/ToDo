//
//  ViewController.swift
//  ToDoTest
//
//  Created by Паша Настусевич on 19.11.24.
//

import UIKit

protocol TaskListViewInputProtocol: AnyObject {
    func reloadData(for section: TaskSectionViewModel)
}

protocol TaskListViewOutputProtocol: AnyObject {
    var sectionViewModel: TaskSectionViewModelProtocol { get set }
    init(view: TaskListViewInputProtocol)
    func viewDidLoad()
    func didTapAddTaskButton()
    func doneTasks(at index: Int)
    func updateTask(_ task: Task)
    
    func editTask(with task: TaskCellViewModelProtocol)
    func shareTask(with task: TaskCellViewModelProtocol)
    func deleteTask(with task: TaskCellViewModelProtocol)
    
    func searchTasks(with query: String)
}

final class TaskListViewController: UIViewController {
   
    var presenter: TaskListViewOutputProtocol!
    
    private lazy var tableView: UITableView = {
        $0.dataSource = self
        $0.delegate = self
        $0.register(TaskCell.self, forCellReuseIdentifier: TaskCell.cellID)
        $0.backgroundColor = UIColor.black
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UITableView(frame: view.bounds, style: .insetGrouped))
    
    private let footerView: UIView = {
        let view = UIView()
        view.backgroundColor = .customGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let addTaskButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.tintColor = .systemYellow
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let taskCountLabel: UILabel = {
        let countLabel = UILabel()
        countLabel.textColor = .white
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.font = UIFont.systemFont(ofSize: 11)
        return countLabel
    }()

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addTaskButton.addTarget(self, action: #selector (addTaskButtonTapped), for: .touchUpInside)
        presenter.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewDidLoad()
    }
    
    @objc func addTaskButtonTapped() {
        presenter.didTapAddTaskButton()
    }
    
    // MARK: Setup UI
    private func setupView() {
        view.addSubview(tableView)
        view.addSubview(footerView)
        footerView.addSubview(addTaskButton)
        footerView.addSubview(taskCountLabel)
        
        taskCountLabel.text = "\(presenter.sectionViewModel.numberOfRows) задач"
        setupNavigationBar()
        setupSearchBar()
        setConstraint()
    }
    
    private func setupNavigationBar() {
        title = "Задачи"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = .black
        navigationItem.backButtonTitle = "Назад"
        
        let textAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white
        ]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.layer.opacity = 0.5
        searchController.searchBar.barTintColor = UIColor.black
        searchController.searchBar.backgroundColor = UIColor.black
        searchController.searchBar.isTranslucent = false
        
        let textField = searchController.searchBar.searchTextField
        textField.textColor = UIColor.white
        textField.layer.opacity = 0.5
        textField.backgroundColor = UIColor.customGray
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray,
            .font: UIFont.systemFont(ofSize: 16)
        ]
        textField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: placeholderAttributes)
        
        let leftIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        leftIcon.tintColor = .white
        leftIcon.layer.opacity = 0.5
        textField.leftView = leftIcon
        textField.leftViewMode = .always
      }
    
    func setConstraint() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 90),
            
            taskCountLabel.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            taskCountLabel.centerYAnchor.constraint(equalTo: footerView.centerYAnchor, constant: -10),
            
            addTaskButton.centerYAnchor.constraint(equalTo: taskCountLabel.centerYAnchor),
            addTaskButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -30)
                ])
    }
}

// MARK: UITableViewDataSourse
extension TaskListViewController: UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.sectionViewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = presenter.sectionViewModel.rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.cellID, for: indexPath)
        guard let cell = cell as? TaskCell else { return UITableViewCell() }
        
        cell.viewModel = cellViewModel
        cell.contextMenuDelegate = self
        cell.selectionStyle = .none

        return cell
    }
}

// MARK: UITableViewDelegate
extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

// MARK: - TaskListViewInputProtocol
extension TaskListViewController: TaskListViewInputProtocol {
    func reloadData(for section: TaskSectionViewModel) {
        presenter.sectionViewModel = section
        
        if section.rows.isEmpty {
            tableView.setEmptyMessage("Нет задач")
        } else {
            tableView.restore()
        }
        
        tableView.reloadData()
        taskCountLabel.text = "\(presenter.sectionViewModel.numberOfRows) задач"
        
        
    }
    func reloadData() {
        tableView.reloadData()
    }
}

// MARK: - UISearchBarDelegate
extension TaskListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.searchTasks(with: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        presenter.searchTasks(with: "")
        searchBar.resignFirstResponder()
    }
}

// MARK: - TaskCellContextMenuDelegate
extension TaskListViewController: TaskCellContextMenuDelegate {
    func didSelectEdit(for task: TaskCellViewModelProtocol) {
        presenter.editTask(with: task)
    }

    func didSelectShare(for task: TaskCellViewModelProtocol) {
        presenter.shareTask(with: task)
    }

    func didSelectDelete(for task: TaskCellViewModelProtocol) {
        presenter.deleteTask(with: task)
    }
}

// MARK: - UITableView
extension UITableView {
    func setEmptyMessage(_ message: String) {
        let messageLabel: UILabel = {
            let label = UILabel()
            label.text = message
            label.textColor = .gray
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 16)
            label.sizeToFit()
            return label
        }()
        
        backgroundView = messageLabel
        separatorStyle = .none
    }
    
    func restore() {
        backgroundView = nil
        separatorStyle = .singleLine
    }
}
