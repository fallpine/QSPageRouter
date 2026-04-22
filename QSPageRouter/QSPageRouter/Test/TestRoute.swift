//
//  TestRoute.swift
//  QSPageRouter
//
//  Created by Codex on 2026/4/21.
//

import UIKit

struct ModalInfoInput {
    let title: String
    let detailText: String
    let expectedStyleDescription: String
}

struct SheetInfoInput {
    let title: String
    let expectedHeight: CGFloat?
    let expectedGrabberVisible: Bool
}

@MainActor
enum TestRoute: Routable {
    case currentTest
    case pushEntry
    case pushDestination
    case pushFailure
    case presentTest
    case modalInfo(input: ModalInfoInput)
    case sheetTest
    case sheetInfo(input: SheetInfoInput)

    func buildViewController() -> UIViewController {
        switch self {
        case .currentTest:
            return RouterCurrentTestViewController()
        case .pushEntry:
            return RouterPushEntryViewController()
        case .pushDestination:
            return RouterPushDestinationViewController()
        case .pushFailure:
            return RouterPushFailureTestViewController()
        case .presentTest:
            return RouterPresentTestViewController()
        case let .modalInfo(input):
            return RouterModalInfoViewController(input: input)
        case .sheetTest:
            return RouterSheetTestViewController()
        case let .sheetInfo(input):
            return RouterSheetInfoViewController(input: input)
        }
    }
}
