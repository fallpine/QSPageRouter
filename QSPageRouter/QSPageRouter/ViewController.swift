//
//  ViewController.swift
//  QSPageRouter
//
//  Created by JXH_2 on 2026/4/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "PageRouter Tests"
        configureMenu()
    }

    private func configureMenu() {
        view.backgroundColor = .systemBackground

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)

        let titleLabel = UILabel()
        titleLabel.text = "PageRouter 手动测试菜单"
        titleLabel.font = .preferredFont(forTextStyle: .largeTitle)
        titleLabel.numberOfLines = 0

        let detailLabel = UILabel()
        detailLabel.text = "点击下面的入口，分别验证 currentViewController、push、present 和 sheet 的行为。所有测试页都放在 Test 目录下，通过代码构建。"
        detailLabel.font = .preferredFont(forTextStyle: .body)
        detailLabel.textColor = .secondaryLabel
        detailLabel.numberOfLines = 0

        [titleLabel, detailLabel].forEach { stackView.addArrangedSubview($0) }

        let menuItems: [(String, TestRoute)] = [
            ("测试 currentViewController()", .currentTest),
            ("测试 push(_:animated:)", .pushEntry),
            ("测试 present(_:fullScreen:)", .presentTest),
            ("测试 presentSheet(_:config:)", .sheetTest)
        ]

        for item in menuItems {
            stackView.addArrangedSubview(makeMenuButton(title: item.0) { [weak self] in
                self?.presentWrappedRoute(item.1)
            })
        }

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

            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }

    private func makeMenuButton(title: String, action: @escaping () -> Void) -> UIButton {
        var configuration = UIButton.Configuration.filled()
        configuration.title = title
        configuration.cornerStyle = .large
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20)

        let button = UIButton(configuration: configuration)
        button.addAction(UIAction { _ in
            action()
        }, for: .touchUpInside)
        return button
    }

    private func presentWrappedRoute(_ route: Routable) {
        let navigationController = UINavigationController(rootViewController: route.buildViewController())
        present(navigationController, animated: true)
    }
}
