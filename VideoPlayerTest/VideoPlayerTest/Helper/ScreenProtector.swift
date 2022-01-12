//
//  ScreenProtector.swift
//  VideoPlayerTest
//
//  Created by thoonk on 2022/01/12.
//

import UIKit
import SnapKit

final class ScreenProtector {
    private var warningWindow: UIWindow?
    
    private var window: UIWindow? {
        return (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window
    }
    
    private lazy var warningLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "공작소 앱은 인강 화면에서\n 스크린 녹화를 방지하고 있습니다."
        
        return label
    }()
    
    func setupPreventingCapturing() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didDetectCapturing),
            name: UIApplication.userDidTakeScreenshotNotification,
            object: nil
        )
    }
    
    func setupPreventingRecording() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didDetectRecording),
            name: UIScreen.capturedDidChangeNotification,
            object: nil
        )
    }
}

private extension ScreenProtector {
    @objc
    func didDetectCapturing() {
        let alert = UIAlertController(title: "알림", message: "캡처를 하면 안됩니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        let rootVC = self.window?.rootViewController
        let presentingVC = rootVC?.presentedViewController
        
        if presentingVC != nil {
            presentingVC?.present(alert, animated: true, completion: nil)
        } else {
            rootVC?.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc
    func didDetectRecording() {
        DispatchQueue.main.async { [weak self] in
            self?.hideScreen()
            self?.presentWarningWindow()
        }
    }
    
    func hideScreen() {
        if UIScreen.main.isCaptured {
            window?.isHidden = true
        } else {
            window?.isHidden = false
        }
    }
    
    func presentWarningWindow() {
        warningWindow?.removeFromSuperview()
        warningWindow = nil
        
        if UIScreen.main.isCaptured == true {
            guard let frame = window?.bounds else { return }
            
            var warningWindow = UIWindow(frame: frame)
            
            let windowScene = UIApplication.shared.connectedScenes.first {
                $0.activationState == .foregroundActive
            }
            if let windowScene = windowScene as? UIWindowScene {
                warningWindow = UIWindow(windowScene: windowScene)
            }
            
            warningWindow.frame = frame
            warningWindow.backgroundColor = .black
            warningWindow.windowLevel = UIWindow.Level.statusBar + 1
            warningWindow.addSubview(warningLabel)
            
            warningLabel.snp.makeConstraints {
                $0.centerX.centerY.equalToSuperview()
            }
            
            self.warningWindow = warningWindow
            self.warningWindow?.makeKeyAndVisible()
        }
    }
}
