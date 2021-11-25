//
//  ModalAnimatorBase.swift
//  TabBarPlayground
//
//  Created by Павел Анохов on 21.11.2021.
//

import Foundation
import UIKit

class ModalAnimatorBase: NSObject, UIViewControllerAnimatedTransitioning {
    // MARK: Properties

    let configuration: AnimatorConfiguration

    weak var navigationController: UINavigationController?
    weak var tabBarController: UITabBarController?

    // MARK: init

    init(configuration: AnimatorConfiguration) {
        self.configuration = configuration
    }

    // MARK: UIViewControllerAnimatedTransitioning

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        configuration.animationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) { }
}
