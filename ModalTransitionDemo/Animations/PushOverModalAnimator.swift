//
//  PushOverModalAnimator.swift
//  TabBarPlayground
//
//  Created by Павел Анохов on 21.11.2021.
//

import Foundation
import UIKit

final class PushOverModalAnimator: ModalAnimatorBase {
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let source = transitionContext.view(forKey: .from),
            let target = transitionContext.view(forKey: .to)
        else {
            return
        }

        let containerView = transitionContext.containerView

        // 1. Определяем вью, на которую будем переходить, и которую будем анимировать
        let animatedView = tabBarController?.view ?? navigationController?.view ?? target

        // 2. Снапшот и оверлей источника
        let snapshot = animatedView.snapshotView(afterScreenUpdates: false)!
        snapshot.tag = configuration.snapshotTag

        let overlay = UIView(frame: snapshot.frame)
        overlay.tag = configuration.dimOverlayTag
        overlay.backgroundColor = UIColor(white: 0.0, alpha: configuration.dimOverlayAlpha)
        overlay.alpha = 0.0
        containerView.addSubview(overlay)

        /*
         3. Добавляем снапшот под анимируемые вьюхи.
         В случае с таббаром - снапшот подкладывается под вью таббар контроллера.
         ⚠️ Это не будет работать, если использовать этот аниматор на разных табах таббара.
         Для фикса необходимо будет доработать шареный стор, который будет подкладывать нужный снапшот,
         подбирая его к странице, на которой находится таббар
         */
        if let superview = animatedView.superview {
            superview.insertSubview(snapshot, belowSubview: animatedView)
            superview.insertSubview(overlay, belowSubview: animatedView)
        }

        containerView.addSubview(target)

        // 4. Отображаем панели навигатора и таббара
        navigationController?.setNavigationBarHidden(false, animated: false)
        tabBarController?.tabBar.isHidden = false

        // 5. Запускаем анимацию
        let targetFrame = animatedView.frame // Положение "на экране"
        animatedView.frame = targetFrame.offsetBy(dx: target.frame.width, dy: 0) // Положение "за экраном справа"

        // Положение "предыдущий VC смещается немного влево"
        let parallaxFrame = source.frame.offsetBy(dx: -source.frame.width * configuration.parallaxMultiplier, dy: 0)

        UIView.animate(
            withDuration: configuration.animationDuration,
            delay: 0,
            options: .curveEaseOut
        ) {
            animatedView.frame = targetFrame
            snapshot.frame = parallaxFrame
            overlay.alpha = 1.0
        } completion: { _ in
            transitionContext.completeTransition(true)
        }
    }
}
