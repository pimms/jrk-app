//
//  Copyright © 2019 Joakim Stien. All rights reserved.
//

import UIKit

class SetupViewController: UIViewController {

    private let connectionSetupHelper = ConnectionSetupHelper()

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

    private lazy var loadOverlay: LoadOverlayView = {
        let view = LoadOverlayView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .defaultBackground

        view.addSubview(textField)
        view.addSubview(connectButton)
        view.addSubview(loadOverlay)

        loadOverlay.fillInSuperview()
        loadOverlay.isHidden = true
        loadOverlay.text = "Connecting..."

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

        guard let urlString = textField.text else { return }

        let urlWithProtocol: String
        if urlString.prefix(4) != "http" {
            urlWithProtocol = "https://\(urlString)"
        } else {
            urlWithProtocol = urlString
        }

        self.loadOverlay.alpha = 0.0
        self.loadOverlay.isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0.2, animations: {
            self.loadOverlay.alpha = 1.0
        })

        connectionSetupHelper.attempt(withRootUrl: urlWithProtocol, resultHandler: { [weak self] result in
            print("Result: \(result)")

            DispatchQueue.main.async {
                UIView.setAnimationBeginsFromCurrentState(true)
                UIView.animate(withDuration: 0.3, animations: {
                    self?.loadOverlay.alpha = 0.0
                }, completion: { _ in
                    self?.loadOverlay.isHidden = true
                })
            }
        })
    }

    @objc private func textFieldChanged() {
        connectButton.isEnabled = (textField.text?.count ?? 0) >= 3
    }
}

extension SetupViewController: UITextFieldDelegate {

}
