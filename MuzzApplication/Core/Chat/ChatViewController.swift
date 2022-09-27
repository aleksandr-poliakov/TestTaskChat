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
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        tableView.register(ChatTableViewCell.self, forCellReuseIdentifier: "ChatTableViewCell")
        return tableView
    }()
    
    private let keyboardManager: KeyboardManager = KeyboardManager()
    private let inputBar: InputBarAccessoryView = MessageInputBar()
    private let viewModel: ChatViewModel
    
    override var inputAccessoryView: UIView? {
        return inputBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    init(viewModel: ChatViewModel) {
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
        fetchData()
    }
    
    // MARK: - Fetch core data items
    
    private func fetchData() {
        viewModel.fetchData()
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
                if self?.viewModel.numberOrSection ?? 0 > 0 { self?.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true) }
                self?.view.layoutIfNeeded()
            }
        }
        
        viewModel.dataRetrieved = { [weak self] _ in
            self?.tableView.reloadData()
            self?.inputBar.sendButton.stopAnimating()
        }
        
        viewModel.messageAppended = { [weak self] index in
            self?.performAnimation(indexPath: index)
        }
    }
    
    // MARK: - Perform Animation
    
    private func performAnimation(indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [indexPath], with: .fade)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            self.tableView.endUpdates()
            self.inputBar.sendButton.stopAnimating()
        }
    }
}

// MARK: - UITableViewDataSource

extension ChatViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOrSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell") as? ChatTableViewCell else { return UITableViewCell() }
        
        cell.configureCell(model: viewModel.message(indexPath: indexPath))
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let header = ChatViewHeader()
        header.configureView(viewModel.chat(section: section))
        return header
    }
}

// MARK: - InputBarAccessoryViewDelegate

extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        inputBar.sendButton.startAnimating()
        viewModel.sendMessage(text: text)
    }
}
