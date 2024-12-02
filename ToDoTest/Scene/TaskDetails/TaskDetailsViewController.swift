//
//  TaskDetailsViewController.swift
//  ToDoTest
//
//  Created by Паша Настусевич on 21.11.24.
//

import UIKit

protocol TaskDetailsViewInputProtocol: AnyObject {
    func displayTask(name: String, description: String, date: Date)
}

protocol TaskDetailsViewOutputProtocol {
    init(view: TaskDetailsViewInputProtocol)
    func loadTaskDetails()
    func saveTask(name: String, description: String, date: Date)
}

final class TaskDetailsViewController: UIViewController {
    
    var updateDataTaskList: (() -> Void)?
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.boldSystemFont(ofSize: 32)
        textField.textColor = .white
        textField.borderStyle = .none
        textField.textAlignment = .left
        textField.returnKeyType = .done
        return textField
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.textColor = .white
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textView.returnKeyType = .done
        return textView
    }()
        
    var presenter: TaskDetailsViewOutputProtocol!
    
    // MARK: - Life Cycle view
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews(nameTextField, dateLabel, descriptionTextView)
        setConstraints()
        presenter.loadTaskDetails()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        guard let name = nameTextField.text, !name.isEmpty,
              let description = descriptionTextView.text else { return }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        let date = dateFormatter.date(from: dateLabel.text ?? "") ?? Date()
        
        presenter.saveTask(name: name, description: description, date: date)
        updateDataTaskList?()
    }
}

// MARK: - Setup UI
private extension TaskDetailsViewController {
    
    func setupSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
        view.backgroundColor = .black
    }

    func setConstraints() {
            NSLayoutConstraint.activate(
                [
                nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
                nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                
                dateLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 8),
                dateLabel.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
                dateLabel.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
                
                descriptionTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20),
                descriptionTextView.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
                descriptionTextView.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
                descriptionTextView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            ]
            )
        }
    
    func setupInteractions() {
        nameTextField.delegate = self
        descriptionTextView.delegate = self
    }
}

// MARK: - TaskDetailsViewInputProtocol
extension TaskDetailsViewController: TaskDetailsViewInputProtocol {
    func displayTask(name: String, description: String, date: Date) {
        nameTextField.text = name
        descriptionTextView.text = description
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        dateLabel.text = dateFormatter.string(from: date)
    }
}

// MARK: - UITextFieldDelegate, UITextViewDelegate
extension TaskDetailsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
       }
}

extension TaskDetailsViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
}
