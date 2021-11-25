//
//  SceneDelegate.swift
//  TabBarPlayground
//
//  Created by Павел Анохов on 18.11.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        if #available(iOS 15, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithOpaqueBackground()
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance

            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
        }

        let page1Root = ViewController()
        page1Root.title = "One"
        let page1 = UINavigationController(rootViewController: page1Root)

        let page2Root = UIViewController()
        page2Root.title = "Two"
        page2Root.view.backgroundColor = .systemBackground
        let page2 = UINavigationController(rootViewController: page2Root)

        UIButton.appearance().setTitleColor(.systemBlue, for: .normal)

        let tabBar = UITabBarController()
        tabBar.viewControllers = [page1, page2]
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = tabBar
        self.window = window
        window.makeKeyAndVisible()
    }
}

