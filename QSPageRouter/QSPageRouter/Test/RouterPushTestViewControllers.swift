//
//  RouterPushTestViewControllers.swift
//  QSPageRouter
//
//  Created by Codex on 2026/4/21.
//

import UIKit

@MainActor
final class RouterPushEntryViewController: RouterTestBaseViewController {

    init() {
        super.init(
            title: "Push Test",
            detailText: "当前页面被放在测试专用 UINavigationController 中。点击第一个按钮验证 push 成功；点击第二个按钮打开非导航场景页面，验证 push 失败分支返回 false。"
        )
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addActionButton(title: "测试导航场景 push 成功") { [weak self] in
            guard let self else { return }
            let didPush = PageRouter.push(TestRoute.pushDestination)
            self.updateResult("导航场景 push 返回值: \(didPush ? "true" : "false")")
        }

        addActionButton(title: "打开非导航场景 push 失败测试") { [weak self] in
            guard let self else { return }
            PageRouter.present(TestRoute.pushFailure, fullScreen: false) {
                self.updateResult("非导航场景 push 失败测试页已打开。")
            }
        }
    }
}

@MainActor
final class RouterPushDestinationViewController: RouterTestBaseViewController {

    private var hasValidatedCurrentController = false

    init() {
        super.init(
            title: "Push Destination",
            detailText: "这个页面通过 PageRouter.push(...) 入栈。页面显示后会再次检查 currentViewController() 是否已经切换到自己。"
        )
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard !hasValidatedCurrentController else { return }
        hasValidatedCurrentController = true

        let currentViewController = PageRouter.currentViewController()
        let matchesSelf = currentViewController === self

        updateResult("""
        已通过 PageRouter.push(...) 进入目标页。
        currentViewController 是否等于当前页: \(matchesSelf ? "是" : "否")
        """)
    }
}

@MainActor
final class RouterPushFailureTestViewController: RouterTestBaseViewController {

    init() {
        super.init(
            title: "Push Failure Test",
            detailText: "当前页面通过 present 打开，没有嵌入 UINavigationController。点击按钮后调用 PageRouter.push(...)，应返回 false 且页面不跳转。"
        )
        modalPresentationStyle = .automatic
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addActionButton(title: "执行非导航场景 push") { [weak self] in
            guard let self else { return }
            let didPush = PageRouter.push(TestRoute.pushDestination, animated: false)
            self.updateResult("""
            非导航场景 push 返回值: \(didPush ? "true" : "false")
            测试结论: \(!didPush ? "通过" : "未通过")
            """)
        }
    }
}
