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

    @IBOutlet weak var ksVideoView: KSVideoView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // let url = URL(string: "ks://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mov") {
        let url = URL(string: "rtsp://192.168.100.90:8554/mystream")!
        ksVideoView.set(url: url)
    }
}
