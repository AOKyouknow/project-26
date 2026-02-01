//
//  SceneDelegate.swift
//  HZ
//
//  Created by Алик on 01.10.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
                
                let window = UIWindow(windowScene: windowScene)
                //let viewController = ViewController()
                window.rootViewController = TabController()
                
                self.window = window
                window.makeKeyAndVisible()
        //здесь что-то нужно написать. в видео чувак пользуется автозаполнением, у меня такого нет))) ЧТО-ТО С ОКНАМИ windiw
        // в итоге то, что добавлено я взял в чате, где он просто рассказывает что такое SceneDelegate (это совпадает с тем, что в видео). Видимо, так выглядит базовая настройка метода scene.
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }


}

