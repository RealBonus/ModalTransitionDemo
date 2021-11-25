//
//  PopOverModalAnimator.swift
//  TabBarPlayground
//
//  Created by Павел Анохов on 22.11.2021.
//

import Foundation
import UIKit

final class PopOverModalAnimator: ModalAnimatorBase {
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let source = transitionContext.view(forKey: .from),
            let target = transitionContext.view(forKey: .to)
        else {
            return
        }

        let containerView = transitionContext.containerView
        containerView.insertSubview(target, belowSubview: source)

        // Определяем вью, которые будем анимировать
        let animatedView = tabBarController?.view ?? navigationController?.view ?? source

        guard
            let superview = animatedView.superview,
            let snapshot = superview.viewWithTag(configuration.snapshotTag),
            let overlay = superview.viewWithTag(configuration.dimOverlayTag)
        else {
            return
        }

        // Запускаем анимации
        let frame = source.frame
        let targetFrame = source.frame.offsetBy(dx: frame.width, dy: 0.0)

        UIView.animate(
            withDuration: configuration.animationDuration,
            delay: 0,
            options: .curveEaseOut
        ) {
            animatedView.frame = targetFrame
            snapshot.frame = frame
            overlay.alpha = 0.0
        } completion: { finished in
            defer {
                transitionContext.completeTransition(finished)
            }

            guard finished else {
                return
            }

            animatedView.frame = frame

            // Скрываем панели, если анимация была завершена
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            self.tabBarController?.tabBar.isHidden = true

            // Удаляем снапшоты
            snapshot.removeFromSuperview()
            overlay.removeFromSuperview()
        }
    }
}
