//
//  RouterSheetTestViewController.swift
//  QSPageRouter
//
//  Created by Codex on 2026/4/21.
//

import UIKit

@MainActor
final class RouterSheetTestViewController: RouterTestBaseViewController {

    init() {
        super.init(
            title: "Sheet Test",
            detailText: "分别测试固定高度 + 显示拖拽横线，以及默认高度 + 不显示拖拽横线两种场景。目标页会展示读取到的 sheet 配置。"
        )
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addActionButton(title: "测试固定高度 + 显示横线") { [weak self] in
            guard let self else { return }
            let configuration = PageRouter.SheetConfiguration(height: 320, showsGrabber: true)
            let route = TestRoute.sheetInfo(input: SheetInfoInput(
                title: "Fixed Height Sheet",
                expectedHeight: 320,
                expectedGrabberVisible: true
            ))

            PageRouter.presentSheet(route, config: configuration) {
                self.updateResult("固定高度 sheet 展示完成。")
            }
        }

        addActionButton(title: "测试默认高度 + 不显示横线") { [weak self] in
            guard let self else { return }
            let configuration = PageRouter.SheetConfiguration(height: nil, showsGrabber: false)
            let route = TestRoute.sheetInfo(input: SheetInfoInput(
                title: "Default Medium Sheet",
                expectedHeight: nil,
                expectedGrabberVisible: false
            ))

            PageRouter.presentSheet(route, config: configuration) {
                self.updateResult("默认高度 sheet 展示完成。")
            }
        }
    }
}

@MainActor
final class RouterSheetInfoViewController: UIViewController {

    private let input: SheetInfoInput
    private let infoLabel = UILabel()

    init(input: SheetInfoInput) {
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

        infoLabel.numberOfLines = 0
        infoLabel.font = .preferredFont(forTextStyle: .body)
        infoLabel.text = "等待 sheet 完成布局..."

        var configuration = UIButton.Configuration.filled()
        configuration.title = "关闭当前 Sheet"
        configuration.cornerStyle = .large

        let dismissButton = UIButton(configuration: configuration)
        dismissButton.addAction(UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        }, for: .touchUpInside)

        [infoLabel, dismissButton].forEach { stackView.addArrangedSubview($0) }

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let detentDescriptions = sheetPresentationController?.detents.map(\.identifier.rawValue).joined(separator: ", ") ?? "nil"
        let actualGrabber = sheetPresentationController?.prefersGrabberVisible ?? false

        infoLabel.text = """
        场景: \(input.title)
        预期高度: \(input.expectedHeight.map { "\($0)" } ?? "medium")
        预期显示横线: \(input.expectedGrabberVisible ? "是" : "否")
        实际 detents: \(detentDescriptions)
        实际显示横线: \(actualGrabber ? "是" : "否")
        """
    }
}
