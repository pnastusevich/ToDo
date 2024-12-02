//
//  TaskCell.swift
//  ToDoTest
//
//  Created by Паша Настусевич on 20.11.24.
//

import UIKit

protocol TaskCellDelegate: AnyObject {
    func didTapCompleteButton(in cell: TaskCell)
}

protocol CellModelRepresentable {
    var viewModel: TaskCellViewModelProtocol? { get }
}

final class TaskCell: UITableViewCell, CellModelRepresentable {
    
    static let cellID = "TaskCell"
    weak var delegate: TaskCellDelegate?
    weak var contextMenuDelegate: TaskCellContextMenuDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    private let isCompleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private let separatorView: UIView = {
          let view = UIView()
          view.translatesAutoresizingMaskIntoConstraints = false
          view.backgroundColor = UIColor.darkGray
          return view
      }()
      
    
    var viewModel: TaskCellViewModelProtocol? {
        didSet {
            updateView()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addContextMenuInteraction()

        setupLayout()
        isCompleteButton.addTarget(self, action: #selector(didTapCompleteButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addContextMenuInteraction() {
        let interaction = UIContextMenuInteraction(delegate: self)
        self.addInteraction(interaction)
        
        self.selectionStyle = .none
    }
    
    private func updateView() {
        contentView.backgroundColor = .black
        guard let viewModel = viewModel as? TaskCellViewModel else { return }
        
        titleLabel.text = viewModel.name
        subtitleLabel.text = viewModel.subname
        timeLabel.text = formatDateRange(date: viewModel.createdAt)
        
        if viewModel.isCompleted {
            isCompleteButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            isCompleteButton.tintColor = .systemYellow
            
            let attributedString = NSAttributedString(
                string: viewModel.name,
                attributes: [
//                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: UIColor.gray,
                    .font: UIFont.boldSystemFont(ofSize: 18)
                ]
            )
            titleLabel.attributedText = attributedString
            subtitleLabel.textColor = .gray
        } else {
            isCompleteButton.setImage(UIImage(systemName: "circle"), for: .normal)
            isCompleteButton.tintColor = .gray
            
            titleLabel.attributedText = nil
            titleLabel.text = viewModel.name
            titleLabel.textColor = .white
            titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
            subtitleLabel.textColor = .white
        }
    }
    
    @objc private func didTapCompleteButton() {
        guard let viewModel = viewModel as? TaskCellViewModel else { return }
        viewModel.isCompleted.toggle()
        updateView()
        
        delegate?.didTapCompleteButton(in: self)
    }
    
    func formatDateRange(date: Date) -> String {
        let dateFormatter = DateFormatter()
        
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            dateFormatter.dateFormat = "'Сегодня, 'dd/MM/yy"
        } else {
            dateFormatter.dateFormat = "dd/MM/yy"
        }
        
        let dateString = dateFormatter.string(from: date)
        return "\(dateString)"
    }
    
    private func setupLayout() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(isCompleteButton)
        contentView.addSubview(separatorView)
        
        NSLayoutConstraint.activate(
            [
                isCompleteButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
                isCompleteButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
                isCompleteButton.widthAnchor.constraint(equalToConstant: 24),
                isCompleteButton.heightAnchor.constraint(equalToConstant: 24),
                
                titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                titleLabel.leadingAnchor.constraint(equalTo: isCompleteButton.trailingAnchor, constant: 16),
                titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                
                subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
                subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
                
                timeLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8),
                timeLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                timeLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
                
                separatorView.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 16),
                separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                separatorView.trailingAnchor.constraint(equalTo: timeLabel.trailingAnchor),
                separatorView.heightAnchor.constraint(equalToConstant: 1),
                separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ]
        )
    }
}
