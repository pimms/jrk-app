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
        field.enablesReturnKeyAutomatically = true
        field.textColor = .inverseText
        field.backgroundColor = .inverseBackground
        field.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        return field
    }()

    private lazy var connectButton: Button = {
        let button = Button(style: .callToAction)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.setTitle("Connect", for: .normal)
        button.addTarget(self, action: #selector(connectButtonClicked), for: .touchUpInside)
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
            connectButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: .mediumLargeSpacing),
        ])
    }

    @objc private func connectButtonClicked() {
        print("connect pls")
    }

    @objc private func textFieldChanged() {
        connectButton.isEnabled = (textField.text?.count ?? 0) >= 3
    }
}

extension SetupViewController: UITextFieldDelegate {

}
