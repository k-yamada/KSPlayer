//
//  AppDelegate.swift
//  Demo
//
//  Created by kintan on 2018/4/15.
//  Copyright © 2018年 kintan. All rights reserved.
//

import KSPlayer
import UIKit
@available(iOS 13.0, tvOS 13.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {
    var window: UIWindow?
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow()
        KSPlayerManager.canBackgroundPlay = true
        KSPlayerManager.logLevel = .debug
        KSPlayerManager.firstPlayerType = KSMEPlayer.self
        KSPlayerManager.secondPlayerType = KSMEPlayer.self
//        KSPlayerManager.supportedInterfaceOrientations = .all
        KSOptions.preferredForwardBufferDuration = 10
        KSOptions.isAutoPlay = true
        KSOptions.isSecondOpen = true
        KSOptions.isAccurateSeek = true
        KSOptions.isLoopPlay = true
        KSOptions.hardwareDecodeH265 = true
        KSOptions.hardwareDecodeH264 = true

        let rootStoryboard: UIStoryboard = UIStoryboard(name: "RootViewController", bundle: nil)
        let rootViewController = rootStoryboard.instantiateViewController(withIdentifier: "RootViewController") as! RootViewController
        UIApplication.shared.keyWindow?.rootViewController = rootViewController
        window.rootViewController = UINavigationController(rootViewController: rootViewController)
        window.makeKeyAndVisible()
        self.window = window
        return true
    }

    #if os(iOS)
    func application(_: UIApplication, supportedInterfaceOrientationsFor _: UIWindow?) -> UIInterfaceOrientationMask {
        KSPlayerManager.supportedInterfaceOrientations
    }

    private var menuController: MenuController!
    override func buildMenu(with builder: UIMenuBuilder) {
        if builder.system == .main {
            menuController = MenuController(with: builder)
        }
    }
    #endif
}

var objects: [KSPlayerResource] = {
    var objects = [KSPlayerResource]()
    if let url = URL(string: "rtsp://192.168.100.90:8554/mystream") {
//    if let url = URL(string: "rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mov") {
        let options = KSOptions()
        options.formatContextOptions["timeout"] = 0
        objects.append(KSPlayerResource(url: url, options: options, name: "rtsp video"))
    }

    return objects
}()

class CustomVideoPlayerView: VideoPlayerView {
    override func customizeUIComponents() {
        super.customizeUIComponents()
        toolBar.isHidden = true
        toolBar.timeSlider.isHidden = true
    }

    override open func player(layer: KSPlayerLayer, state: KSPlayerState) {
        super.player(layer: layer, state: state)
        if state == .readyToPlay, let player = layer.player {
            print(player.naturalSize)
            // list the all subtitles
            let subtitleInfos = srtControl.filterInfos { _ in true }
            subtitleInfos.forEach {
                print($0.name)
            }
            subtitleInfos.first?.makeSubtitle { result in
                self.resource?.subtitle = try? result.get()
            }
            for track in player.tracks(mediaType: .audio) {
                print("audio name: \(track.name) language: \(track.language ?? "")")
            }
            for track in player.tracks(mediaType: .video) {
                print("video name: \(track.name) bitRate: \(track.bitRate) fps: \(track.nominalFrameRate) bitDepth: \(track.bitDepth) colorPrimaries: \(track.colorPrimaries ?? "") colorPrimaries: \(track.transferFunction ?? "") yCbCrMatrix: \(track.yCbCrMatrix ?? "") codecType:  \(track.codecType.string)")
            }
        }
    }

    override func onButtonPressed(type: PlayerButtonType, button: UIButton) {
        if type == .landscape {
            // xx
        } else {
            super.onButtonPressed(type: type, button: button)
        }
    }
}

class SimpleVideoPlayerView: VideoPlayerView {
    override func customizeUIComponents() {
        super.customizeUIComponents()
        toolBar.isHidden = true
        toolBar.timeSlider.isHidden = true
    }

    override open func player(layer: KSPlayerLayer, state: KSPlayerState) {
        super.player(layer: layer, state: state)
        if state == .readyToPlay, let player = layer.player {
            print(player.naturalSize)
            // list the all subtitles
            let subtitleInfos = srtControl.filterInfos { _ in true }
            subtitleInfos.forEach {
                print($0.name)
            }
            subtitleInfos.first?.makeSubtitle { result in
                self.resource?.subtitle = try? result.get()
            }
            for track in player.tracks(mediaType: .audio) {
                print("audio name: \(track.name) language: \(track.language ?? "")")
            }
            for track in player.tracks(mediaType: .video) {
                print("video name: \(track.name) bitRate: \(track.bitRate) fps: \(track.nominalFrameRate) bitDepth: \(track.bitDepth) colorPrimaries: \(track.colorPrimaries ?? "") colorPrimaries: \(track.transferFunction ?? "") yCbCrMatrix: \(track.yCbCrMatrix ?? "") codecType:  \(track.codecType.string)")
            }
        }
    }

    override func onButtonPressed(type: PlayerButtonType, button: UIButton) {
    }
}
