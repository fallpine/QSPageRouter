//
//  PageRouter.swift
//  QSPageRouter
//
//  Created by Codex on 2026/4/21.
//

import UIKit

@MainActor
public final class PageRouter {

    public struct SheetConfiguration {
        public let height: CGFloat?
        public let showsGrabber: Bool

        /// 创建 sheet 展示配置。
        /// - Parameters:
        ///   - height: 自定义 sheet 高度，传 `nil` 时默认使用系统 `medium` 高度。
        ///   - showsGrabber: 是否显示顶部拖拽横线。
        public init(height: CGFloat? = nil, showsGrabber: Bool = false) {
            self.height = height
            self.showsGrabber = showsGrabber
        }
    }

    /// 获取当前位于最顶层、适合发起路由跳转的页面控制器。
    /// - Returns: 当前可见的顶层控制器，获取失败时返回 `nil`。
    public static func currentViewController() -> UIViewController? {
        guard let rootViewController = rootViewController() else {
            debugLog("无法获取当前窗口的根控制器")
            return nil
        }

        return topViewController(from: rootViewController)
    }

    /// 通过导航控制器将目标页面 push 到当前页面之上。
    /// - Parameters:
    ///   - route: 需要跳转到的目标路由。
    ///   - animated: 是否使用动画。
    /// - Returns: 成功 push 返回 `true`，当前页面不在导航栈中时返回 `false`。
    @discardableResult
    public static func push(_ route: Routable, animated: Bool = true) -> Bool {
        guard let currentViewController = currentViewController() else {
            debugLog("无法执行 push，当前页面控制器不存在")
            return false
        }

        let navigationController = (currentViewController as? UINavigationController)
            ?? currentViewController.navigationController

        guard let navigationController else {
            debugLog("当前页面不在导航栈中，无法 push")
            return false
        }

        let target = route.buildViewController()
        navigationController.pushViewController(target, animated: animated)
        return true
    }

    /// 以普通模态方式展示目标页面。
    /// - Parameters:
    ///   - route: 需要展示的目标路由。
    ///   - fullScreen: 是否全屏展示。
    ///   - animated: 是否使用动画。
    ///   - completion: 展示完成后的回调。
    public static func present(
        _ route: Routable,
        fullScreen: Bool,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        guard let currentViewController = currentViewController() else {
            debugLog("无法执行 present，当前页面控制器不存在")
            return
        }

        let target = route.buildViewController()
        target.modalPresentationStyle = fullScreen ? .fullScreen : .automatic
        currentViewController.present(target, animated: animated, completion: completion)
    }

    /// 以 sheet 方式展示目标页面，并支持配置高度与拖拽横线显隐。
    /// - Parameters:
    ///   - route: 需要展示的目标路由。
    ///   - config: sheet 展示配置。
    ///   - animated: 是否使用动画。
    ///   - completion: 展示完成后的回调。
    public static func presentSheet(
        _ route: Routable,
        config: SheetConfiguration,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        guard let currentViewController = currentViewController() else {
            debugLog("无法执行 sheet present，当前页面控制器不存在")
            return
        }

        let target = route.buildViewController()
        target.modalPresentationStyle = .pageSheet

        if let sheetPresentationController = target.sheetPresentationController {
            sheetPresentationController.detents = makeDetents(height: config.height)
            sheetPresentationController.prefersGrabberVisible = config.showsGrabber
            sheetPresentationController.prefersScrollingExpandsWhenScrolledToEdge = false
        } else {
            debugLog("当前系统无法创建 sheetPresentationController，将按 pageSheet 展示")
        }

        currentViewController.present(target, animated: animated, completion: completion)
    }

    /// 获取当前前台场景中的根控制器，作为页面层级解析的起点。
    /// - Returns: 当前活跃窗口的根控制器，获取失败时返回 `nil`。
    private static func rootViewController() -> UIViewController? {
        let windowScenes = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }

        let foregroundScene = windowScenes.first(where: { $0.activationState == .foregroundActive })
            ?? windowScenes.first(where: { $0.activationState == .foregroundInactive })

        let keyWindow = foregroundScene?.windows.first(where: \.isKeyWindow)
            ?? windowScenes
                .flatMap(\.windows)
                .first(where: \.isKeyWindow)

        return keyWindow?.rootViewController
    }

    /// 沿着导航、Tab、模态和容器层级递归查找最顶层可见控制器。
    /// - Parameter viewController: 当前递归遍历到的控制器。
    /// - Returns: 最顶层可见控制器。
    private static func topViewController(from viewController: UIViewController) -> UIViewController {
        if let presentedViewController = viewController.presentedViewController {
            return topViewController(from: presentedViewController)
        }

        if let navigationController = viewController as? UINavigationController,
           let visibleViewController = navigationController.visibleViewController {
            return topViewController(from: visibleViewController)
        }

        if let tabBarController = viewController as? UITabBarController,
           let selectedViewController = tabBarController.selectedViewController {
            return topViewController(from: selectedViewController)
        }

        if let childViewController = visibleChildViewController(in: viewController) {
            return topViewController(from: childViewController)
        }

        return viewController
    }

    /// 从自定义容器控制器的子控制器中找出当前可见的页面。
    /// - Parameter viewController: 容器控制器。
    /// - Returns: 当前可见的子控制器；若无法判断，则兜底返回最后一个子控制器。
    private static func visibleChildViewController(in viewController: UIViewController) -> UIViewController? {
        let visibleChild = viewController.children.reversed().first { child in
            guard child !== viewController.presentedViewController else {
                return false
            }

            guard child.isViewLoaded else {
                return false
            }

            return child.view.window != nil && !child.view.isHidden && child.view.alpha > 0.0
        }

        return visibleChild ?? viewController.children.last
    }

    /// 根据配置生成 sheet 可用的高度档位。
    /// - Parameter height: 自定义高度，传 `nil` 时使用默认 `medium` 档位。
    /// - Returns: 可用于 `UISheetPresentationController` 的 detents 数组。
    private static func makeDetents(height: CGFloat?) -> [UISheetPresentationController.Detent] {
        guard let height else {
            return [.medium()]
        }

        return [
            .custom(identifier: .pageRouterCustomHeight) { _ in
                height
            }
        ]
    }

    /// 在调试环境下输出路由失败原因，方便接入时快速定位问题。
    /// - Parameter message: 调试提示信息。
    private static func debugLog(_ message: String) {
        #if DEBUG
        print("PageRouter: \(message)")
        #endif
    }
}

private extension UISheetPresentationController.Detent.Identifier {
    static let pageRouterCustomHeight = Self("page_router_custom_height")
}
