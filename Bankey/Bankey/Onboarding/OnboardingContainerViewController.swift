//
//  OnboardingContainerViewController.swift
//  Bankey
//
//  Created by Stephan Schranz on 03/04/2023.
//

import UIKit

protocol OnboardingContainerViewControllerDelegate: AnyObject{
    func didFinishOnboarding()
}

class OnboardingContainerViewController: UIViewController {

    let pageViewController: UIPageViewController
    var pages = [UIViewController]()
    var currentVC: UIViewController
    let closeButton = UIButton(type: .system)
    var delegate: OnboardingContainerViewControllerDelegate?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        let page1 = OnboardingViewController(heroImageName: "delorean", titleText: "Bankey is faster, easier to use, and has a brand new look and feel that will make you fell like you are back in the 1989")
        let page2 = OnboardingViewController(heroImageName: "world", titleText: "Move your money around the world quickly and securely")
        let page3 = OnboardingViewController(heroImageName: "thumbs", titleText: "Learn more at www.bankey.com.")
        
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        
        currentVC = pages.first!
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        style()
        layout()
    }
        
    private func setup(){
            view.backgroundColor = .systemPurple
            
            addChild(pageViewController) //you need to set this relation if this VC is supposed to show view from other VCs
            view.addSubview(pageViewController.view) // we add pageViewControllers's view
            pageViewController.didMove(toParent: self) //conversely to the first line, we have to make this VC the parent of PagViewController
            
            pageViewController.dataSource = self //this is also 'simply' needed. It makes you implement the UIPageViewControllerDataSource protocol.
            pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: pageViewController.view.topAnchor),
                view.leadingAnchor.constraint(equalTo: pageViewController.view.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: pageViewController.view.trailingAnchor),
                view.bottomAnchor.constraint(equalTo: pageViewController.view.bottomAnchor),
            ])
            
            //'setViewControllers' is the central method. It seds the next VC that is supposed to be shown
            // It runs automatically after a swipe. Here we run it manually once to set up what we see when we load PageViewController the first time.
            //[page.first!] It sets the first page to be shown. Its an array because multiple views of multiple ViewControllers could be shown at once.
            // direction: defines the in which direction to swipe
            pageViewController.setViewControllers([pages.first!], direction: .forward, animated: false, completion: nil)
            currentVC = pages.first!
    }
    
    
    private func style(){
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setTitle("Close", for: [])
        closeButton.addTarget(self, action: #selector(closeTapped), for: .primaryActionTriggered)
        
        view.addSubview(closeButton)
        
    }
        
    private func layout(){
        //Close Button
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            closeButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2)
        ])
    }
    

}


// MARK: - UIPageViewControllerDataSource
extension OnboardingContainerViewController: UIPageViewControllerDataSource {

    //the function that returns the VC to 'setViewControllers()' after a right left swipe
    // 'pageViewController' is simply the pageViewController - you don't need it any way
    // 'viewControllerBefore' the curren VC that we want to move away from!
    // this method should return 'nil' if we have arrived at the end
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return getPreviousViewController(from: viewController)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return getNextViewController(from: viewController)
    }

    private func getPreviousViewController(from viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index - 1 >= 0 else { return nil }
        currentVC = pages[index - 1]
        return pages[index - 1]
    }

    private func getNextViewController(from viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index + 1 < pages.count else { return nil }
        currentVC = pages[index + 1]
        return pages[index + 1]
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return pages.firstIndex(of: self.currentVC) ?? 0
    }
}


//MARK: - Actions
extension OnboardingContainerViewController{
    @objc func closeTapped(_ sender: UIButton){
        delegate?.didFinishOnboarding()
    }
}

