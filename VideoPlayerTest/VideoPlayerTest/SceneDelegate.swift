//
//  SceneDelegate.swift
//  VideoPlayerTest
//
//  Created by MA2103 on 2021/12/07.
//

import UIKit
import AVKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private let screenProtector = ScreenProtector()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        self.window = UIWindow(windowScene: windowScene)
        self.window?.backgroundColor = .systemBackground
        let navigationController = UINavigationController(rootViewController: MainVC())
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        AppDelegate.shared.window = window
        
        screenProtector.setupPreventingRecording()
        screenProtector.setupPreventingCapturing()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {
        // 무음 모드일 때 비디오 재생 사운드 켜기
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        } catch {
            print("AVAudioSessionCategoryPlayback not work")
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {
        presentingVC()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {}
}

private extension SceneDelegate {
    func presentingVC() {
        if #available(iOS 13.0, *) {
            let sceneDelegate = UIApplication.shared.connectedScenes
                .first!.delegate as! SceneDelegate
            if let playerVC = topViewController(base: sceneDelegate.window!.rootViewController) as? PlayerVC {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    playerVC.pipController?.stopPictureInPicture()
                }
            }
        } else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            if let playerVC = topViewController(base: appDelegate.window!.rootViewController) as? PlayerVC {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    playerVC.pipController?.stopPictureInPicture()
                }
            }
        }
    }
    
    func topViewController(base: UIViewController?) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
