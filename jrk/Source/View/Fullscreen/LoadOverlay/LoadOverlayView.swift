//
//  Copyright © 2019 Joakim Stien. All rights reserved.
//

import UIKit

class LoadOverlayView: UIView {

    public var text: String? {
        didSet {
            label.text = text
        }
    }

    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .gray)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var label: Label = {
        let label = Label(style: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    init() {
        super.init(frame: .zero)
        setup()
    }

    private func setup() {
        backgroundColor = UIColor(r: 255, g: 255, b: 255, a: 126)

        // addSubview(activityIndicatorView)
        addSubview(label)
        activityIndicatorView.startAnimating()

        NSLayoutConstraint.activate([
            // activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            // activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -.largeSpacing),

            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
            label.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -48.0),
        ])
    }
}
