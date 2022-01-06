import AVKit
import UIKit
import MediaPlayer
import KSPlayer

open class RtspPlayerView: PlayerView {

    var scrollDirection = KSPanDirection.horizontal
    var tmpPanValue: Float = 0

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
//        backgroundColor = .black
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
        case .bufferFinished:
            isPlayed = true
        case .paused, .playedToTheEnd, .error:
            break
        default:
            break
        }
    }

    override open func resetPlayer() {
        super.resetPlayer()
        resource = nil
        toolBar.reset()
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

    private func addConstraint() {
        playerLayer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playerLayer.topAnchor.constraint(equalTo: topAnchor),
            playerLayer.leadingAnchor.constraint(equalTo: leadingAnchor),
            playerLayer.bottomAnchor.constraint(equalTo: bottomAnchor),
            playerLayer.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
