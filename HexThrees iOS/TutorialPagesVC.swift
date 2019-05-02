//
//  TutorialPagesVC.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 31.03.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation

class TutorialPagesVC : UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pageControl = UIPageControl()
    
    func configurePageControll() {
        pageControl = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY - 50, width: UIScreen.main.bounds.width, height: 50))
        pageControl.numberOfPages = viewControllersList.count
        pageControl.currentPage = 0
        pageControl.tintColor = .black
        pageControl.pageIndicatorTintColor = .white
        pageControl.currentPageIndicatorTintColor = .black
        self.view.addSubview(pageControl)
    }
    
    func configureBackButton() {
        let btn = UIButton(frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY - 50, width: 60, height: 50))
        
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle("Back", for: .normal)
        btn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        self.view.addSubview(btn)
    }
    
    @objc func goBack() {
        
        dismiss(animated: true, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        let currentPageIndex = viewControllersList.index(of: pageContentViewController)!
        self.pageControl.currentPage = currentPageIndex
    }
    
    lazy var viewControllersList:[UIViewController] = {
    
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        let mergeVC = sb.instantiateViewController(withIdentifier: "TutorialMergeRulesVC")
        let swipeVC = sb.instantiateViewController(withIdentifier: "TutorialSwipeRulesVC")
        
        return [mergeVC, swipeVC]
    }()
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    
        //this is from https://www.youtube.com/watch?v=jVBtDH6jjl8
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
        
        configurePageControll()
        configureBackButton()
        self.delegate = self
    }
}
