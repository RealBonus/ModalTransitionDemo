//
//  Animator.swift
//  TabBarPlayground
//
//  Created by Павел Анохов on 18.11.2021.
//

import Foundation
import UIKit

final class PushAsModalAnimator: ModalAnimatorBase {
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let target = transitionContext.view(forKey: .to) else {
            return
        }

        let containerView = transitionContext.containerView

        /* 1.
         Добавляем снапшот и оверлей.
         После завершения перехода снапшот не удаляется, его надо будет удалить руками после ухода с экрана назад.
         */
        let snapshot = UIApplication.shared.windows.first!.snapshotView(afterScreenUpdates: false)!
        snapshot.tag = configuration.snapshotTag
        containerView.addSubview(snapshot)

        let overlay = UIView(frame: snapshot.frame)
        overlay.tag = configuration.dimOverlayTag
        overlay.backgroundColor = UIColor(white: 0.0, alpha: configuration.dimOverlayAlpha)
        overlay.alpha = 0.0
        containerView.addSubview(overlay)

        // 2. После создания снапшота скрываем таббар и навигатор
        navigationController?.setNavigationBarHidden(true, animated: false)
        tabBarController?.tabBar.isHidden = true

        containerView.addSubview(target)

        // 3. Запускаем анимацию
        let targetFrame = target.frame // Положение "на экране"
        target.frame = targetFrame.offsetBy(dx: 0, dy: target.frame.height) // Положение "Снизу за экраном"

        UIView.animate(
            withDuration: configuration.animationDuration,
            delay: 0,
            options: .curveEaseOut
        ) {
            target.frame = targetFrame
            overlay.alpha = 1.0
        } completion: { finished in
            transitionContext.completeTransition(finished)
        }
    }
}
