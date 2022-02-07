//
//  ViewController.swift
//  Swipes
//
//  Created by thoonk on 2022/02/07.
//

import UIKit

class ViewController: UIViewController {
    
    private let swipeableView: UIView = {
        // Initialize View
        let view = UIView(frame: CGRect(origin: .zero,
                                        size: CGSize(width: 200.0, height: 200.0)))
        
        // Configure View
        view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(swipeableView)
        
        swipeableView.addGestureRecognizer(createSwipeGestureRecognizer(for: .up))
        swipeableView.addGestureRecognizer(createSwipeGestureRecognizer(for: .down))
        swipeableView.addGestureRecognizer(createSwipeGestureRecognizer(for: .left))
        swipeableView.addGestureRecognizer(createSwipeGestureRecognizer(for: .right))
        
    }
    
    private func createSwipeGestureRecognizer(for direction: UISwipeGestureRecognizer.Direction) -> UISwipeGestureRecognizer {
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        
        swipeGestureRecognizer.direction = direction
        
        return swipeGestureRecognizer
    }
    
    @objc
    func didSwipe(_ sender: UISwipeGestureRecognizer) {
        var frame = swipeableView.frame
        
        switch sender.direction {
        case .up:
            frame.origin.y -= 100.0
            frame.origin.y = max(0.0, frame.origin.y)
        case .down:
            frame.origin.y += 100.0
            
            if frame.maxY > view.bounds.maxY {
                frame.origin.y = view.bounds.height - frame.height
            }
        case .left:
            frame.origin.x -= 100.0
            frame.origin.x = max(0.0, frame.origin.x)
        case .right:
            frame.origin.x += 100.0
            
            if frame.maxX > view.bounds.maxX {
                frame.origin.x = view.bounds.width - frame.width
            }
        default:
            break
        }
        
        UIView.animate(withDuration: 0.25) {
            self.swipeableView.frame = frame
        }
    }
}

