//
//  Routable.swift
//  QSPageRouter
//
//  Created by Codex on 2026/4/21.
//

import UIKit

@MainActor
public protocol Routable {

    /// 构建当前路由对应的目标控制器。
    /// - Returns: 用于页面跳转的控制器实例。
    func buildViewController() -> UIViewController
}
