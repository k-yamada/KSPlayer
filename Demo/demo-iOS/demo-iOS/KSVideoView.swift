import UIKit
import KSPlayer

protocol KSVideoViewDelegate: AnyObject {
    func ksVideoViewDidStart()
}

final class KSVideoView: UIView {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var videoView: UIView!

    @IBOutlet weak var videoWidthConstraint: NSLayoutConstraint!

    weak var delegate: KSVideoViewDelegate?

    private let playerView = KSPlayerView()

    override init(frame: CGRect){
        super.init(frame: frame)
        commonInit()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }

    private func commonInit() {
        let view = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)

        videoView.isHidden = true
        playerView.viewDelegate = self
    }

    func set(url: URL) {
        let options = KSOptions()
        options.formatContextOptions["timeout"] = 0
        let resource = KSPlayerResource(url: url, options: options, name: "")
        playerView.set(resource: resource)

        videoView.addSubview(playerView)
        playerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playerView.topAnchor.constraint(equalTo: videoView.topAnchor),
            playerView.leadingAnchor.constraint(equalTo: videoView.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: videoView.trailingAnchor),
            playerView.bottomAnchor.constraint(equalTo: videoView.bottomAnchor),
        ])
    }
}

// MARK: - KSPlayerViewDelegate
extension KSVideoView: KSPlayerViewDelegate {
    func ksPlayerView(_ ksPlayerView: KSPlayerView, didReadyToPlay naturalSize: CGSize) {
        let ratio = frame.height / naturalSize.height
        let videoWidth = naturalSize.width * ratio
        videoWidthConstraint.constant = videoWidth
    }

    func ksPlayerViewDidFinishBuffer(_ ksPlayerView: KSPlayerView) {
        backgroundView.backgroundColor = .black
        videoView.isHidden = false
    }
}
