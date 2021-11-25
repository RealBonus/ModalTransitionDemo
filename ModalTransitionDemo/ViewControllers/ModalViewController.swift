//
//  ModalViewController.swift
//  TabBarPlayground
//
//  Created by Павел Анохов on 18.11.2021.
//

import Foundation
import UIKit

class ModalViewController: UIViewController {

    lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [goButton, backButton])
        stack.axis = .vertical
        return stack
    }()

    lazy var goButton: UIButton = {
        let button = UIButton()
        button.setTitle("Push next", for: .normal)
        button.addTarget(self, action: #selector(goPressed), for: .touchUpInside)
        return button
    }()

    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setTitle("Go back", for: .normal)
        button.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        return button
    }()

    override func loadView() {
        let view = UIView()
        view.addSubview(stack)

        stack.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        view.backgroundColor = .systemBackground

        self.view = view
    }

    override func viewDidLoad() {
        title = "Yo!"
    }

    @objc func goPressed() {
        let viewController = ModalViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc func backPressed() {
        navigationController?.popViewController(animated: true)
    }

    var interactionController: UIPercentDrivenInteractiveTransition?
}

extension ModalViewController: UINavigationControllerDelegate {
    private typealias Tags = (snapshot: Int, overlay: Int)

    private static let tagsIn: Tags = (9001, 9003)
    private static let tagsOut: Tags = (10001, 10002)

    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        let animator: ModalAnimatorBase

        switch operation {
        case .push:
            if toVC == self {
                animator = PushAsModalAnimator(configuration: AnimatorConfiguration(
                    snapshotTag: Self.tagsIn.snapshot,
                    dimOverlayTag: Self.tagsIn.overlay
                ))
            } else if fromVC == self {
                animator = PushOverModalAnimator(configuration: AnimatorConfiguration(
                    snapshotTag: Self.tagsOut.snapshot,
                    dimOverlayTag: Self.tagsOut.overlay
                ))
            } else {
                return nil
            }

        case .pop:
            if toVC == self {
                animator = PopOverModalAnimator(configuration: AnimatorConfiguration(
                    snapshotTag: Self.tagsOut.snapshot,
                    dimOverlayTag: Self.tagsOut.overlay
                ))
            } else if fromVC == self {
                animator = PopAsModalAnimator(configuration: AnimatorConfiguration(
                    snapshotTag: Self.tagsIn.snapshot,
                    dimOverlayTag: Self.tagsIn.overlay
                ))
            } else {
                return nil
            }

        case .none:
            return nil

        @unknown default:
            return nil
        }

        animator.navigationController = navigationController
        animator.tabBarController = tabBarController
        return animator
    }

    func navigationController(
        _ navigationController: UINavigationController,
        interactionControllerFor animationController: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
}
