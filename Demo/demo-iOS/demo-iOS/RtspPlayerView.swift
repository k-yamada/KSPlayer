import AVKit
import UIKit
import MediaPlayer
import KSPlayer

open class RtspPlayerView: PlayerView {

    var scrollDirection = KSPanDirection.horizontal
    var tmpPanValue: Float = 0

    public let bottomMaskView = LayerContainerView()
    public let topMaskView = LayerContainerView()
    private(set) var isPlayed = false

    public private(set) var currentDefinition = 0 {
        didSet {
            if let resource = resource {
                toolBar.definitionButton.setTitle(resource.definitions[currentDefinition].definition, for: .normal)
            }
        }
    }

    public private(set) var resource: KSPlayerResource? {
        didSet {
            if let resource = resource, oldValue !== resource {
                srtControl.searchSubtitle(name: resource.name)
                toolBar.definitionButton.isHidden = resource.definitions.count < 2
            }
        }
    }

    private var subtitleEndTime = TimeInterval(0)
    /// Activty Indector for loading
    public var loadingIndector: UIView & LoadingIndector = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    public var replayButton = UIButton()
    public let srtControl = KSSubtitleController()
    public var isLock: Bool { false }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupUIComponents()
    }

    // MARK: - Action Response

    override open func onButtonPressed(type: PlayerButtonType, button: UIButton) {
    }

    open func changePlaybackRate(button: UIButton) {
    }

    open func setupUIComponents() {
        addSubview(playerLayer)
        backgroundColor = .black
        topMaskView.gradientLayer.colors = [UIColor.black.withAlphaComponent(0.5).cgColor, UIColor.clear.cgColor]
        bottomMaskView.gradientLayer.colors = topMaskView.gradientLayer.colors
        topMaskView.gradientLayer.startPoint = .zero
        topMaskView.gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        bottomMaskView.gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        bottomMaskView.gradientLayer.endPoint = .zero

        loadingIndector.isHidden = true
        addSubview(loadingIndector)
        addConstraint()
        layoutIfNeeded()
    }

    override open func player(layer: KSPlayerLayer, currentTime: TimeInterval, totalTime: TimeInterval) {
        super.player(layer: layer, currentTime: currentTime, totalTime: totalTime)
    }

    override open func player(layer: KSPlayerLayer, state: KSPlayerState) {
        super.player(layer: layer, state: state)
        switch state {
        case .readyToPlay:
            toolBar.timeSlider.isPlayable = true
        case .buffering:
            isPlayed = true
            replayButton.isHidden = true
            replayButton.isSelected = false
            showLoader()
        case .bufferFinished:
            isPlayed = true
            replayButton.isHidden = true
            replayButton.isSelected = false
            hideLoader()
        case .paused, .playedToTheEnd, .error:
            hideLoader()
            replayButton.isHidden = false
            if state == .playedToTheEnd {
                replayButton.isSelected = true
            }
        default:
            break
        }
    }

    override open func resetPlayer() {
        super.resetPlayer()
        resource = nil
        toolBar.reset()
        hideLoader()
        replayButton.isSelected = false
        replayButton.isHidden = false
        isPlayed = false
    }

    // MARK: - KSSliderDelegate

    override open func slider(value: Double, event: ControlEvents) {
    }

    open func change(definitionIndex: Int) {
        guard let resource = resource else { return }
        var shouldSeekTo = 0.0
        if playerLayer.state != .playedToTheEnd, let currentTime = playerLayer.player?.currentPlaybackTime {
            shouldSeekTo = currentTime
        }
        currentDefinition = definitionIndex >= resource.definitions.count ? resource.definitions.count - 1 : definitionIndex
        let asset = resource.definitions[currentDefinition]
        super.set(url: asset.url, options: asset.options)
        if shouldSeekTo > 0 {
            seek(time: shouldSeekTo)
        }
    }

    open func set(resource: KSPlayerResource, definitionIndex: Int = 0, isSetUrl: Bool = true) {
        self.resource = resource
        currentDefinition = definitionIndex >= resource.definitions.count ? resource.definitions.count - 1 : definitionIndex
        if isSetUrl {
            let asset = resource.definitions[currentDefinition]
            super.set(url: asset.url, options: asset.options)
        }
    }

    override open func set(url: URL, options: KSOptions) {
        set(resource: KSPlayerResource(url: url, options: options))
    }
}

// MARK: - private functions

extension RtspPlayerView {

    private func showLoader() {
        loadingIndector.isHidden = false
        loadingIndector.startAnimating()
    }

    private func hideLoader() {
        loadingIndector.isHidden = true
        loadingIndector.stopAnimating()
    }

    private func addConstraint() {
        playerLayer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playerLayer.topAnchor.constraint(equalTo: topAnchor),
            playerLayer.leadingAnchor.constraint(equalTo: leadingAnchor),
            playerLayer.bottomAnchor.constraint(equalTo: bottomAnchor),
            playerLayer.trailingAnchor.constraint(equalTo: trailingAnchor),
            loadingIndector.centerYAnchor.constraint(equalTo: centerYAnchor),
            loadingIndector.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
}
