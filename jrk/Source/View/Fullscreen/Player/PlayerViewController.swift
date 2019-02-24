//
//  Copyright © 2019 Joakim Stien. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {

    // MARK: - Private properties

    private let serverConnection: ServerConnection

    // MARK: - UI properties

    private let imageView: UIImageView = {
        // We need an initial frame before the constraints are activated in order to
        // initialize the edge-shadow layer,
        let screenWidth = UIScreen.main.bounds.width
        let frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth)

        let view = UIImageView(frame: frame)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill

        let shadow = EdgeShadowLayer(forView: view, edge: .bottom, shadowRadius: screenWidth / 3, toColor: .clear, fromColor: .defaultBackground)
        view.layer.addSublayer(shadow)

        return view
    }()

    private let titleLabel: Label = {
        let label = Label(style: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()

    private let seasonLabel: Label = {
        let label = Label(style: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()

    // MARK: - Init

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError()
    }

    init(server: ServerConnection) {
        self.serverConnection = server
        super.init(nibName: nil, bundle: nil)
    }

    // MARK: - Lifecycle

    private var networkClient: NetworkClient? // TODO: REMOVE

    override func viewDidLoad() {
        view.backgroundColor = .defaultBackground

        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(seasonLabel)

        let guide = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),

            titleLabel.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: .largeSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -.largeSpacing),

            seasonLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .mediumSpacing),
            seasonLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: .largeSpacing),
            seasonLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -.largeSpacing),
        ])

        imageView.image = serverConnection.coverImage

        networkClient = NetworkClient(rootUrl: serverConnection.rootUrl)
        networkClient?.fetchNowPlaying(dataCallback: { [weak self] result in
            switch (result) {
            case .success(let nowPlaying):
                self?.titleLabel.text = nowPlaying.episodeName
                self?.seasonLabel.text = nowPlaying.season
            case .failure(let error):
                print("oh no, failed: \(error)")
            }
        })
    }
}
