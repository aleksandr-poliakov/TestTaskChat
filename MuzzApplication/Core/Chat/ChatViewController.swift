//
//  ViewController.swift
//  MuzzApplication
//
//  Created by Aleksandr on 26.09.2022.
//

import UIKit
import InputBarAccessoryView

final class ChatViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        tableView.register(ChatTableViewCell.self, forCellReuseIdentifier: "ChatTableViewCell")
        return tableView
    }()
    
    private lazy var dataSource = makeDataSource()
    
    private let keyboardManager: KeyboardManager = KeyboardManager()
    private let inputBar: InputBarAccessoryView = MessageInputBar()
    private var viewModel: ChatViewModelType
    
    override var inputAccessoryView: UIView? {
        return inputBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    init(viewModel: ChatViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
    
    // MARK: - Configure Layour
    
    private func setupUI() {
        title = "Chat"
        inputBar.delegate = self
        inputBar.inputTextView.keyboardType = .twitter
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - Bind ViewModel with Observer
    
    private func bind() {
        keyboardManager.on(event: .willChangeFrame) { [weak self] notification in
            UIView.animate(withDuration: 0.3) {
                self?.tableView.contentInset.top = (notification.endFrame.height)
                self?.tableView.setContentOffset(CGPoint(x: .zero, y: (notification.endFrame.height)), animated: true)
                if self?.viewModel.countItems ?? 0 > 0 { self?.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true) }
                self?.view.layoutIfNeeded()
            }
        }
        
        viewModel.transform = { [weak self] chat in
            self?.update(with: chat, animate: true)
        }
    }
}

// MARK: - DiffableDataSource approach

fileprivate extension ChatViewController {
    func makeDataSource() -> UITableViewDiffableDataSource<Date, LocalMessage> {
        return UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, local in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell") as? ChatTableViewCell else {
                    assertionFailure("Failed to dequeue \(ChatTableViewCell.self)!")
                    return UITableViewCell()
                }
                cell.configureCell(model: local)
                return cell
            }
        )
    }

    func update(with messages: [LocalChat], animate: Bool = true) {
        DispatchQueue.main.async {
            var snapshot = NSDiffableDataSourceSnapshot<Date, LocalMessage>()
            
            messages.forEach {
                snapshot.appendSections([$0.date])
                snapshot.appendItems($0.messages, toSection: $0.date)
            }

            self.dataSource.apply(snapshot, animatingDifferences: animate)
            self.inputBar.sendButton.stopAnimating()
        }
    }
}

// MARK: - UITableViewDelegate

extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let header = ChatViewHeader()
        header.configureView(viewModel.allSection(section))
        return header
    }
}

// MARK: - InputBarAccessoryViewDelegate

extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        inputBar.sendButton.startAnimating()
        inputBar.inputTextView.text = ""
        viewModel.sendMessage(text: text)
    }
}
