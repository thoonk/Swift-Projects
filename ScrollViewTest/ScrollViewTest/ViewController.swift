//
//  ViewController.swift
//  ScrollViewTest
//
//  Created by 김태훈 on 2021/02/07.
//

import UIKit

class ViewController: UIViewController {
    
    var images = ["Crayon1","Crayon2", "Snoopy1", "Snoopy2"]

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0..<images.count {
            let imageView = UIImageView()
            imageView.image = UIImage(named: images[i])
            
            let xPosition = self.view.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xPosition, y: 0, width:
            self.scrollView.frame.width + 50, height: self.scrollView.frame.height)
            scrollView.contentSize.width =
                   self.view.frame.width * CGFloat(1+i)
            
            scrollView.addSubview(imageView)
        }
    }
}

