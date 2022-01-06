//
//  MasterViewController.swift
//  Demo
//
//  Created by kintan on 2018/4/15.
//  Copyright © 2018年 kintan. All rights reserved.
//

import KSPlayer
import UIKit


class RootViewController: UIViewController {
    @IBOutlet weak var videoView: UIView!

    @IBOutlet weak var videoWidthConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "rtsp://192.168.100.90:8554/mystream")!
        // let url = URL(string: "rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mov") {
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
//        videoWidthConstraint.constant = 300
    }

//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        .lightContent
//    }
//
//    override var prefersStatusBarHidden: Bool {
////        !playerView.isMaskShow
//        true
//    }
//
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        KSPlayerManager.supportedInterfaceOrientations
//    }
//
//    private let playerView = IOSVideoPlayerView()
    private let playerView = RtspPlayerView()
}
