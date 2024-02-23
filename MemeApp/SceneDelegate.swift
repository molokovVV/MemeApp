//
//  SceneDelegate.swift
//  MemeApp
//
//  Created by Виталик Молоков on 23.02.2024.
//

import UIKit
import SnapKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let viewController = MemViewController()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}

