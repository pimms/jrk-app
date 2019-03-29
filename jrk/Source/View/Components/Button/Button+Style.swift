//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public extension Button {
    enum Style {
        case callToAction
        case destructive

        var font: UIFont {
            switch self {
            default: return .body
            }
        }

        var bodyColor: UIColor {
            switch self {
            case .callToAction: return .actionButtonBackground
            case .destructive: return .destructiveButtonBackground
            }
        }

        var borderWidth: CGFloat {
            switch self {
            default: return 0.0
            }
        }

        var borderColor: UIColor? {
            switch self {
            default: return nil
            }
        }

        var textColor: UIColor {
            switch self {
            default: return .defaultText
            }
        }

        var highlightedBodyColor: UIColor? {
            switch self {
            case .destructive: return .destructiveButtonBackgroundHighlight
            case .callToAction: return .actionButtonBackgroundHighlight
            }
        }

        var highlightedBorderColor: UIColor? {
            switch self {
            default: return nil
            }
        }

        var highlightedTextColor: UIColor? {
            switch self {
            default: return nil
            }
        }

        var disabledBodyColor: UIColor? {
            switch self {
            case .callToAction: return .actionButtonBackgroundDisabled
            case .destructive: return .destructiveButtonBackgroundDisabled
            }
        }

        var disabledBorderColor: UIColor? {
            switch self {
            default: return nil
            }
        }

        var disabledTextColor: UIColor? {
            switch self {
            default: return nil
            }
        }

        var margins: UIEdgeInsets {
            switch self {
            default: return UIEdgeInsets(top: .mediumSpacing, left: .mediumLargeSpacing, bottom: .mediumSpacing, right: .mediumLargeSpacing)
            }
        }

        var paddings: UIEdgeInsets {
            switch self {
            default: return UIEdgeInsets(top: .smallSpacing, left: 0, bottom: .smallSpacing, right: 0)
            }
        }
    }
}
