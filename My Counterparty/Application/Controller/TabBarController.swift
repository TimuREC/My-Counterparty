//
//  TabBarController.swift
//  My Counterparty
//
//  Created by mono on 11.12.2020.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
    }

}

extension TabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let tabViewControllers = tabBarController.viewControllers,
              let toIndex = tabViewControllers.firstIndex(of: viewController)
        else { return false }
        
        animateToTab(toIndex: toIndex)
        return false
    }
    
    func animateToTab(toIndex: Int) {
        guard let tabViewControllers = viewControllers,
                    let selectedVC = selectedViewController else { return }

        guard let fromView = selectedVC.view,
            let toView = tabViewControllers[toIndex].view,
            let fromIndex = tabViewControllers.firstIndex(of: selectedVC),
            fromIndex != toIndex else { return }

        fromView.superview?.addSubview(toView)

        let screenWidth = UIScreen.main.bounds.size.width
        let scrollRight = toIndex > fromIndex
        let offset = (scrollRight ? screenWidth : -screenWidth)
        toView.center = CGPoint(x: fromView.center.x + offset, y: toView.center.y)

        view.isUserInteractionEnabled = false

        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                fromView.center = CGPoint(x: fromView.center.x - offset, y: fromView.center.y)
                toView.center = CGPoint(x: toView.center.x - offset, y: toView.center.y)
        }, completion: { _ in
            fromView.removeFromSuperview()
            self.selectedIndex = toIndex
            self.view.isUserInteractionEnabled = true
        })
    }
    
}
