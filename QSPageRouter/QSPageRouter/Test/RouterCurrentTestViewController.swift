//
//  RouterCurrentTestViewController.swift
//  QSPageRouter
//
//  Created by Codex on 2026/4/21.
//

import UIKit

@MainActor
final class RouterCurrentTestViewController: RouterTestBaseViewController {

    private var hasRunCheck = false

    init() {
        super.init(
            title: "Current Test",
            detailText: "进入页面后会自动调用 PageRouter.currentViewController()，验证返回的是否是当前正在显示的测试控制器。"
        )
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard !hasRunCheck else { return }
        hasRunCheck = true

        let currentViewController = PageRouter.currentViewController()
        let controllerName = currentViewController.map { String(describing: type(of: $0)) } ?? "nil"
        let isCurrentController = currentViewController === self

        updateResult("""
        返回控制器: \(controllerName)
        是否等于当前页面: \(isCurrentController ? "是" : "否")
        测试结论: \(isCurrentController ? "通过" : "未通过")
        """)
    }
}
