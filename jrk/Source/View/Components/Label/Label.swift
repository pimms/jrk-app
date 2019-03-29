//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class Label: UILabel {

    // MARK: - Setup

    init(style: Style) {
        super.init(frame: .zero)
        self.style = style
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        isAccessibilityElement = true

        accessibilityLabel = text
        font = style?.font
        textColor = .defaultText
    }

    // MARK: - Dependency injection

    private(set) var style: Style?
}
