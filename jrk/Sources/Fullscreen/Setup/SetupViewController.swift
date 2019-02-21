//
//  Copyright © 2019 Joakim Stien. All rights reserved.
//

import UIKit

class SetupViewController: UIViewController {

    private lazy var textField: UITextField = {
        let field = UITextField(frame: .zero)
        field.translatesAutoresizingMaskIntoConstraints = false
        field.borderStyle = .roundedRect
        field.placeholder = "Enter a JRK URL"
        field.autocorrectionType = .no
        field.keyboardType = .URL
        field.returnKeyType = .go
        field.clearButtonMode = .always
        field.contentVerticalAlignment = .center
        field.keyboardAppearance = .dark
        field.autocapitalizationType = .none
        field.textColor = .inverseText
        field.backgroundColor = .inverseBackground
        return field
    }()

    private lazy var connectButton: Button = {
        let button = Button(style: .callToAction)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Connect", for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .defaultBackground

        view.addSubview(textField)
        view.addSubview(connectButton)

        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .veryLargeSpacing),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.veryLargeSpacing),
            textField.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            connectButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .veryLargeSpacing),
            connectButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.veryLargeSpacing),
            connectButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: .largeSpacing),
        ])
    }
}
