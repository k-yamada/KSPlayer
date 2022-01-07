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

    @IBOutlet weak var rtspVideoView: RtspVideoView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // let url = URL(string: "rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mov") {
        let url = URL(string: "rtsp://192.168.1.4:8554/mystream")!
        rtspVideoView.set(url: url)
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

}
