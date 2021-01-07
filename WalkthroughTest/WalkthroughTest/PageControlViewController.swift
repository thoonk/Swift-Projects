//
//  PageControlViewController.swift
//  WalkthroughTest
//
//  Created by 김태훈 on 2021/01/06.
//

import UIKit

class PageControlViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    lazy var orderedVC: [UIViewController] = {
        return [self.newVC(vc: "screenOne"),
                self.newVC(vc: "screenTwo"),
                self.newVC(vc: "screenThree")]
    }()
    
    var pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.dataSource = self
        self.delegate = self
    
        if let firstVC = orderedVC.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        
        configurePageControl()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = orderedVC.firstIndex(of: pageContentViewController)!
    }
    
    func configurePageControl() {
        pageControl = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY - 50, width: UIScreen.main.bounds.width, height: 50))
        pageControl.numberOfPages = orderedVC.count
        pageControl.currentPage = 0
        pageControl.tintColor = .black
        pageControl.pageIndicatorTintColor = .white
        pageControl.currentPageIndicatorTintColor = .black
        self.view.addSubview(pageControl)
    }
    
    func newVC(vc: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: vc)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = orderedVC.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = vcIndex-1
        
        guard previousIndex >= 0 else { return nil }
        
        guard orderedVC.count > previousIndex else { return nil }
        
        return orderedVC[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = orderedVC.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = vcIndex+1
        
        guard orderedVC.count > nextIndex else { return nil }
                
        return orderedVC[nextIndex]
    }
}
