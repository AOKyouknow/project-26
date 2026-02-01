//
//  TabController.swift
//  HZ
//
//  Created by Алик on 01.10.2025.
//

import UIKit

final class TabController: UITabBarController { //TODO: final class. ПОЩЕМУ????

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs() // можно без self, почему?!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    }
    
    private func setupTabs(){
                
        let oneTab = createNav(with: "One", and: UIImage(systemName: "check_circle"), vc: One()) //TODO: это точно должно тут инициализироваться? В ГДЕ ЕЩË?
        let twoTab = createNav(with: "Two", and: UIImage(systemName: "favorite"), vc: Two())
        self.setViewControllers([oneTab, twoTab], animated: true)
        
    }

    private func createNav(with title: String, and image: UIImage?, vc: UIViewController) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: vc)
        
        //TODO: 1 - данный метод отвечает за создание и настройку вьюшки, а не за настройку таббара. Во первых, метод выполняет не свою задачку, во вторых, он вызывается два раза и ты два раза задаешь тайтл и картинку таббару
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image //TODO: 1 - а картинки в итоге то где?
        nav.viewControllers.first?.navigationItem.title = title + " Controller"
        nav.viewControllers.first?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Button", style: .plain, target: nil, action: nil)
        return nav
    }

    
    
    
}
