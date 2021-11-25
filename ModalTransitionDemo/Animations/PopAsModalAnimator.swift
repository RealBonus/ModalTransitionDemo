//
//  Animator.swift
//  TabBarPlayground
//
//  Created by Павел Анохов on 18.11.2021.
//

import Foundation
import UIKit

final class PopAsModalAnimator: ModalAnimatorBase {
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let source = transitionContext.view(forKey: .from),
            let target = transitionContext.view(forKey: .to)
        else {
            return
        }

        let containerView = transitionContext.containerView

        /* 1.
         Добавляем таргет в контейнер.
         Если находим снапшот по тэгу - подкладываем таргет под снапшот.
         В конце анимации будут отображены панели навигации и табов, после чего
         можно будет удалить снапшот - пользователь ничего не заметит.
         */
        if let overlay = containerView.viewWithTag(configuration.snapshotTag) {
            containerView.insertSubview(target, belowSubview: overlay)
        } else {
            containerView.insertSubview(target, belowSubview: source)
        }

        // 2. Запускаем анимацию.
        UIView.animate(
            withDuration: configuration.animationDuration,
            delay: 0,
            options: .curveEaseIn
        ) { [configuration] in
            source.frame = source.frame.offsetBy(dx: 0, dy: target.frame.height)
            containerView.viewWithTag(configuration.dimOverlayTag)?.alpha = 0.0
        } completion: { [configuration] finished in
            defer {
                transitionContext.completeTransition(finished)
            }

            guard finished else {
                return
            }

            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.tabBarController?.tabBar.isHidden = false

            // Удаляем снапшот
            containerView.viewWithTag(configuration.snapshotTag)?.removeFromSuperview()
            containerView.viewWithTag(configuration.dimOverlayTag)?.removeFromSuperview()
        }
    }
}

