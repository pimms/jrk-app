//
//  Copyright © 2019 Joakim Stien. All rights reserved.
//

import UIKit

protocol PlayButtonDelegate: class {
    func playButtonClicked(_: PlayButton)
}

class PlayButton: UIView {

    // MARK: - Public properties

    public weak var delegate: PlayButtonDelegate?

    // MARK: - UI properties

    private lazy var button: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        return button
    }()

    // MARK: - Init

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init() {
        super.init(frame: .zero)
        setup()
    }

    private func setup() {
        backgroundColor = .clear

        button.backgroundColor = .white

        button.setTitle("normal", for: .normal)
        button.setTitle("highlighted", for: .highlighted)

        button.setTitleColor(.darkGray, for: .normal)
        button.setTitleColor(.darkGray, for: .highlighted)

        addSubview(button)

        button.fillInSuperview()
        button.constrainAspectRatio(1.0)

        button.addTarget(self, action: #selector(buttonTouchBegan), for: [.touchDown])
        button.addTarget(self, action: #selector(buttonTouchEnded), for: [.touchDragExit, .touchUpInside, .touchUpOutside, .touchCancel])

        addDropShadow()
    }

    private func addDropShadow() {
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOffset = .zero
        layer.masksToBounds = false
        layer.shadowRadius = 45.0
        layer.shadowOpacity = 0.55
        layer.cornerRadius = button.frame.width / 2
    }

    @objc private func buttonClicked() {
        delegate?.playButtonClicked(self)
    }

    let animOptions: UIView.AnimationOptions = [.allowUserInteraction, .beginFromCurrentState]
    let animDuration: CGFloat = 1.6
    let animScale: CGFloat = 0.8

    @objc private func buttonTouchBegan() {
        UIView.animate(withDuration: Double(animDuration), delay: 0, options: animOptions, animations: { [weak self] in
            guard let self = self else { return }
            self.button.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        })

        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.beginFromCurrentState], animations: {
            self.button.backgroundColor = .lightGray
        })
    }

    @objc private func buttonTouchEnded() {
        let currentScale = button.layer.presentation()?.transform.m11 ?? animScale
        let currentState = 1.0 - (currentScale - animScale) / (1.0 - animScale)
        let duration = animDuration * currentState

        // Force the button into its' current state, abort all animations
        button.transform = CGAffineTransform(scaleX: currentScale, y: currentScale)
        button.layer.removeAllAnimations()

        UIView.animate(withDuration: Double(duration), delay: 0, options: animOptions, animations: { [weak self] in
            guard let self = self else { return }
            self.button.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.button.backgroundColor = .white
        })
    }
}

// MARK: - UIView overrides

extension PlayButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        button.layer.cornerRadius = frame.width / 2.0
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let point = convert(point, to: self)

        let radius = frame.width / 2.0
        let center = CGPoint(x: radius, y: radius)

        let delta = CGPoint(x: point.x - center.x, y: point.y - center.y)
        if delta.length > radius {
            return nil
        }

        return super.hitTest(point, with: event)
    }
}
