//
//  RouterPresentTestViewController.swift
//  QSPageRouter
//
//  Created by Codex on 2026/4/21.
//

import UIKit

@MainActor
final class RouterPresentTestViewController: RouterTestBaseViewController {

    init() {
        super.init(
            title: "Present Test",
            detailText: "分别测试 fullScreen = true 和 false 两种场景。present 完成回调会把结果写回当前页面，目标页内部会展示自己的展示样式信息。"
        )
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addActionButton(title: "测试全屏 present") { [weak self] in
            guard let self else { return }
            let route = TestRoute.modalInfo(input: ModalInfoInput(
                title: "Full Screen Modal",
                detailText: "这个页面通过 PageRouter.present(..., fullScreen: true) 展示。",
                expectedStyleDescription: ".fullScreen"
            ))

            PageRouter.present(route, fullScreen: true) {
                self.updateResult("全屏 present 完成回调已触发。")
            }
        }

        addActionButton(title: "测试非全屏 present") { [weak self] in
            guard let self else { return }
            let route = TestRoute.modalInfo(input: ModalInfoInput(
                title: "Automatic Modal",
                detailText: "这个页面通过 PageRouter.present(..., fullScreen: false) 展示。",
                expectedStyleDescription: ".automatic"
            ))

            PageRouter.present(route, fullScreen: false) {
                self.updateResult("非全屏 present 完成回调已触发。")
            }
        }
    }
}

@MainActor
final class RouterModalInfoViewController: UIViewController {

    private let input: ModalInfoInput

    init(input: ModalInfoInput) {
        self.input = input
        super.init(nibName: nil, bundle: nil)
        title = input.title
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        let detailLabel = UILabel()
        detailLabel.text = input.detailText
        detailLabel.numberOfLines = 0
        detailLabel.font = .preferredFont(forTextStyle: .body)

        let styleLabel = UILabel()
        styleLabel.numberOfLines = 0
        styleLabel.font = .preferredFont(forTextStyle: .body)
        styleLabel.text = """
        预期展示样式: \(input.expectedStyleDescription)
        实际 modalPresentationStyle: \(modalPresentationStyle.readableDescription)
        """

        var configuration = UIButton.Configuration.filled()
        configuration.title = "关闭当前页面"
        configuration.cornerStyle = .large

        let dismissButton = UIButton(configuration: configuration)
        dismissButton.addAction(UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        }, for: .touchUpInside)

        [detailLabel, styleLabel, dismissButton].forEach { stackView.addArrangedSubview($0) }

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

private extension UIModalPresentationStyle {
    var readableDescription: String {
        switch self {
        case .fullScreen:
            return ".fullScreen"
        case .automatic:
            return ".automatic"
        case .pageSheet:
            return ".pageSheet"
        default:
            return "\(rawValue)"
        }
    }
}
