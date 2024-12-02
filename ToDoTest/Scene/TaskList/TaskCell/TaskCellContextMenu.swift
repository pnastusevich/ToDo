//
//  TaskCellContextMenu.swift
//  ToDoTest
//
//  Created by Паша Настусевич on 25.11.24.
//

import UIKit

protocol TaskCellContextMenuDelegate: AnyObject {
    func didSelectEdit(for task: TaskCellViewModelProtocol)
    func didSelectShare(for task: TaskCellViewModelProtocol)
    func didSelectDelete(for task: TaskCellViewModelProtocol)
}

// MARK: - UIContextMenuInteractionDelegate
extension TaskCell: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        
        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: { [weak self] in return self?.createContextMenu()},
            actionProvider: { [weak self] suggestedActions in
                return self?.createContextMenuActions()}
        )
    }
    
    private func createContextMenu() -> UIViewController? {
        let previewVC = UIViewController()
        previewVC.view.backgroundColor = .customGray
        previewVC.preferredContentSize = CGSize(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.15)
        
        let elements = createElements()
        let titleLabel = elements.titleLabel
        let descriptionLabel = elements.descriptionLabel
        let dateLabel = elements.dateLabel
        
        addSubviews(to: previewVC.view, elements: [titleLabel, descriptionLabel, dateLabel])
        setupConstraints(for: previewVC.view, titleLabel: titleLabel, descriptionLabel: descriptionLabel, dateLabel: dateLabel)

        return previewVC
    }
    
    private func createElements() -> (titleLabel: UILabel, descriptionLabel: UILabel, dateLabel: UILabel) {
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = viewModel!.name
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.textColor = .white
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        let descriptionLabel: UILabel = {
            let label = UILabel()
            label.text = viewModel!.subname
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = .white
            label.numberOfLines = 2
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        let dateLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = .gray
            return label
        }()
        dateLabel.text = formatDateRange(date: viewModel!.createdAt)
        
        return (titleLabel, descriptionLabel, dateLabel)
    }
    
    private func addSubviews(to view: UIView, elements: [UIView]) {
        elements.forEach { view.addSubview($0) }
    }

    private func setupConstraints(for containerView: UIView, titleLabel: UILabel, descriptionLabel: UILabel, dateLabel: UILabel) {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }

    private func createContextMenuActions() -> UIMenu {
        let editAction = UIAction(
            title: "Редактировать",
            image: UIImage(systemName: "pencil")) { [weak self] _ in
                guard let self = self else { return }
                self.contextMenuDelegate?.didSelectEdit(for: viewModel!)
            }
        
        let shareAction = UIAction(
            title: "Поделиться",
            image: UIImage(systemName: "square.and.arrow.up")) { [weak self] _ in
                guard let self = self else { return }
                self.contextMenuDelegate?.didSelectShare(for: viewModel!)
                
            }
        
        let deleteAction = UIAction(
            title: "Удалить",
            image: UIImage(systemName: "trash"),
            attributes: .destructive) { [weak self] _ in
                guard let self = self else { return }
                self.contextMenuDelegate?.didSelectDelete(for: viewModel!)
            }
        
        return UIMenu(title: "", children: [editAction, shareAction, deleteAction])
    }
}
