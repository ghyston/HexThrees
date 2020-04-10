//
//  TutorialPagesVC.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 31.03.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation

class HelpPagesVC : UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
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
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        configureBackButton() //this is called here because before safe insects are unknown
        configureRulesLabel()
    }
    
    func configureBackButton() {
        
        let cornerRadius : CGFloat = 20
        let btnHeight = UIScreen.main.bounds.height * 0.075 +
            view.safeAreaInsets.bottom * 0.5 + cornerRadius
        let btnWidth = UIScreen.main.bounds.width * 0.3 + cornerRadius
        
        let btn = UIButton(frame: CGRect(
            x: -cornerRadius,
            y:  UIScreen.main.bounds.maxY - btnHeight + cornerRadius,
            width: btnWidth,
            height: btnHeight))
        
        btn.layer.cornerRadius = cornerRadius
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle("Back", for: .normal)
        btn.titleLabel?.font = UIFont.init(name: "Futura-Medium", size: 24)
        btn.titleEdgeInsets.bottom = cornerRadius
        btn.backgroundColor = .gray
        btn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        self.view.addSubview(btn)
    }
    
    func configureRulesLabel() {
        
        let lbl = UILabel.init(frame: CGRect(
            x: 0,
            //y: view.safeAreaLayoutGuide.layoutFrame.height / 2 - 5,
            y: view.safeAreaInsets.top + 5,
            width: UIScreen.main.bounds.width / 2 - 40,
            height: 65))
        lbl.text = "rules: "
        lbl.textColor = UIColor.init(red: 151, green: 38, blue: 53) //#todo: move to palette?
        lbl.font = UIFont.init(name: "Futura-Medium", size: 48)
        lbl.textAlignment = .right
        self.view.addSubview(lbl)
    }
    
    @objc func goBack() {
        
        dismiss(animated: true, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        let currentPageIndex = viewControllersList.firstIndex(of: pageContentViewController)!
        self.pageControl.currentPage = currentPageIndex
    }
    
    lazy var viewControllersList:[UIViewController] = {
    
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        let mergeVC = sb.instantiateViewController(withIdentifier: "HelpMergeRulesVC")
        let swipeVC = sb.instantiateViewController(withIdentifier: "HelpSwipeRulesVC")
        
        return [mergeVC, swipeVC]
    }()
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    
        //this is from https://www.youtube.com/watch?v=jVBtDH6jjl8
        guard let vcIndex = viewControllersList.firstIndex(of: viewController) else { return nil }
        let previousIndex = vcIndex - 1
        
        guard previousIndex >= 0 else { return nil }
        
        guard viewControllersList.count > previousIndex else {return nil}
        
        return viewControllersList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllersList.firstIndex(of: viewController) else { return nil }
        let nextIndex = vcIndex + 1
        
        guard viewControllersList.count > nextIndex else {return nil}
        
        return viewControllersList[nextIndex]
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        
        if let firstVC = viewControllersList.first {
            self.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        
        configurePageControll()
        self.delegate = self
    }
}
