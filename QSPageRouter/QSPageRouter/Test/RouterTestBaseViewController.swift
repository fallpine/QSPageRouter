//
//  RouterTestBaseViewController.swift
//  QSPageRouter
//
//  Created by Codex on 2026/4/21.
//

import UIKit

@MainActor
class RouterTestBaseViewController: UIViewController {

    private let detailText: String

    let resultLabel = UILabel()
    let contentStackView = UIStackView()

    init(title: String, detailText: String) {
        self.detailText = detailText
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNavigationItem()
    }

    func addActionButton(title: String, action: @escaping () -> Void) {
        var configuration = UIButton.Configuration.filled()
        configuration.title = title
        configuration.cornerStyle = .large
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 18, bottom: 14, trailing: 18)

        let button = UIButton(configuration: configuration)
        button.addAction(UIAction { _ in
            action()
        }, for: .touchUpInside)

        contentStackView.addArrangedSubview(button)
    }

    func updateResult(_ text: String) {
        resultLabel.text = text
    }

    @objc
    private func closeSelf() {
        if let navigationController, navigationController.viewControllers.first === self {
            navigationController.dismiss(animated: true)
            return
        }

        dismiss(animated: true)
    }

    private func configureView() {
        view.backgroundColor = .systemBackground

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        contentStackView.axis = .vertical
        contentStackView.spacing = 16
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contentStackView)

        let detailLabel = UILabel()
        detailLabel.text = detailText
        detailLabel.numberOfLines = 0
        detailLabel.font = .preferredFont(forTextStyle: .body)
        detailLabel.textColor = .secondaryLabel

        resultLabel.numberOfLines = 0
        resultLabel.font = .preferredFont(forTextStyle: .body)
        resultLabel.textColor = .label
        resultLabel.text = "等待操作..."

        contentStackView.addArrangedSubview(makeSectionLabel(title: "测试说明"))
        contentStackView.addArrangedSubview(detailLabel)
        contentStackView.addArrangedSubview(makeSectionLabel(title: "测试结果"))
        contentStackView.addArrangedSubview(resultLabel)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }

    private func configureNavigationItem() {
        let closeButton = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(closeSelf)
        )
        navigationItem.rightBarButtonItem = closeButton
    }

    private func makeSectionLabel(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        return label
    }
}
