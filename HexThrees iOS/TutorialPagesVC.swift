//
//  TutorialPagesVC.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 31.03.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation

class TutorialPagesVC : UIPageViewController, UIPageViewControllerDataSource {
    
    lazy var viewControllersList:[UIViewController] = {
    
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        let mergeVC = sb.instantiateViewController(withIdentifier: "TutorialMergeRulesVC")
        let swipeVC = sb.instantiateViewController(withIdentifier: "TutorialSwipeRulesVC")
        
        return [mergeVC, swipeVC]
    }()
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    
        //@todo: review this, used from https://www.youtube.com/watch?v=jVBtDH6jjl8
        guard let vcIndex = viewControllersList.index(of: viewController) else { return nil }
        let previousIndex = vcIndex - 1
        
        guard previousIndex >= 0 else { return nil }
        
        guard viewControllersList.count > previousIndex else {return nil}
        
        return viewControllersList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllersList.index(of: viewController) else { return nil }
        let nextIndex = vcIndex + 1
        
        guard viewControllersList.count > nextIndex else {return nil}
        
        return viewControllersList[nextIndex]
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        
        if let firstVC = viewControllersList.last {
            self.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        
        //@todo: check why this is not working
        let appearance = UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
        appearance.pageIndicatorTintColor = UIColor.red
        appearance.currentPageIndicatorTintColor = UIColor.red
    }
}
