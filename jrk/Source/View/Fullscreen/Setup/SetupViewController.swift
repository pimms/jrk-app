//
//  Copyright © 2019 Joakim Stien. All rights reserved.
//

import UIKit

protocol SetupViewControllerDelegate: class {
    func setupViewController(_: SetupViewController, didConfigureConnection: ServerConnection)
}

class SetupViewController: UIViewController {

    // MARK: - Public properties

    public weak var delegate: SetupViewControllerDelegate?

    // MARK: - Private properties

    private let connectionSetupHelper = ConnectionSetupHelper()

    // MARK: - UI properties

    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: .jrkLight)
        view.contentMode = .scaleAspectFit
        return view
    }()

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

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .defaultBackground

        view.addSubview(imageView)
        view.addSubview(textField)
        view.addSubview(connectButton)
        view.addSubview(loadOverlay)

        loadOverlay.fillInSuperview()
        loadOverlay.isHidden = true
        loadOverlay.text = "Connecting..."

        let safeLayout = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeLayout.topAnchor, constant: .veryLargeSpacing),
            imageView.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor, constant: .veryLargeSpacing),
            imageView.trailingAnchor.constraint(equalTo: safeLayout.trailingAnchor, constant: -.veryLargeSpacing),

            textField.topAnchor.constraint(greaterThanOrEqualTo: imageView.bottomAnchor, constant: .largeSpacing),
            textField.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor, constant: .veryLargeSpacing),
            textField.trailingAnchor.constraint(equalTo: safeLayout.trailingAnchor, constant: -.veryLargeSpacing),
            textField.centerYAnchor.constraint(equalTo: safeLayout.centerYAnchor),

            connectButton.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor, constant: .veryLargeSpacing),
            connectButton.trailingAnchor.constraint(equalTo: safeLayout.trailingAnchor, constant: -.veryLargeSpacing),
            connectButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: .mediumLargeSpacing),
        ])
    }

    // MARK: - UI interaction

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
        UIView.animate(withDuration: 0.3, delay: 0.1, animations: {
            self.loadOverlay.alpha = 1.0
        })

        connectionSetupHelper.attempt(withRootUrl: urlWithProtocol, resultHandler: { [weak self] result in
            guard let self = self else { return }

            var success: Bool
            var errorMessage = ""
            var connection: ServerConnection?

            switch (result) {
            case .success(let serverConnection):
                if serverConnection.save() {
                    success = true
                    connection = serverConnection
                } else {
                    success = false
                    errorMessage = "Connection succeeded, but saving connection info failed."
                }
            case .failure(let error):
                print("Failed to connect: \(error)")
                success = false
                errorMessage = error.localizedDescription
            }

            DispatchQueue.main.async {
                if success {
                    self.delegate?.setupViewController(self, didConfigureConnection: connection!)
                } else {
                    self.present(UIAlertController.errorAlert(withMessage: errorMessage), animated: true)
                }

                UIView.animate(withDuration: 0.3, delay: 0, options: .beginFromCurrentState, animations: {
                    self.loadOverlay.alpha = CGFloat(0.0)
                }, completion: { _ in
                    self.loadOverlay.isHidden = true
                })
            }
        })
    }

    @objc private func textFieldChanged() {
        connectButton.isEnabled = (textField.text?.count ?? 0) >= 3
    }
}
