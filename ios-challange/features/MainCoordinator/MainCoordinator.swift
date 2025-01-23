//
//  MainCoordinator.swift
//  ios-challange
//
//  Created by Bruno Soares on 16/01/25.
//
import UIKit

protocol MainCoordinatorProtocol: Coordinator {
    func authorized()
}

class MainCoordinator {
    
    enum Tabs: String, CaseIterable {
        case live
        case favorites
        case people
        case settings
        
        var title: String {
            switch self {
            case .live:
                return "Live"
            case .favorites:
                return "Favorites"
            case .people:
                return "Stars"
            case .settings:
                return "Settings"
            }
        }
        
        var image: String {
            switch self {
            case .live:
                return "livephoto"
            case .favorites:
                return "bookmark.circle.fill"
            case .people:
                return "star.circle.fill"
            case .settings:
                return "gear"
            }
        }
    }
    
    var childCoordinator: [Coordinator]
    
    var navigationController: UINavigationController?
    
    var tabController: UITabBarController?
    
    var updatesRootViewController: ((UIViewController?) -> Void)?
    
    var window: UIWindow?
    
    weak var coordinator: Coordinator?
    
    init() {
        self.tabController = UITabBarController()
        self.childCoordinator = []
    }
    
    func start() {
        self.setupCoordinator()
    }
    
    func setupCoordinator() {
        let liveNavigationController = UINavigationController()
        liveNavigationController.tabBarItem.image = UIImage(systemName: Tabs.live.image)
        liveNavigationController.tabBarItem.title = Tabs.live.title
        let liveCoordinator = SeriesListCoordinator(navigationController: liveNavigationController)
        liveCoordinator.start()
        self.childCoordinator.append(liveCoordinator)
        
        let favoritesNavigationController = UINavigationController()
        favoritesNavigationController.tabBarItem.image = UIImage(systemName: Tabs.favorites.image)
        favoritesNavigationController.tabBarItem.title = Tabs.favorites.title
        let favoritesCoordinator = FavoriteSeriesCoordinator(navigationController: favoritesNavigationController)
        favoritesCoordinator.start()
        self.childCoordinator.append(favoritesCoordinator)
        
        let starsNavigationController = UINavigationController()
        starsNavigationController.tabBarItem.image = UIImage(systemName: Tabs.people.image)
        starsNavigationController.tabBarItem.title = Tabs.people.title
        let starsCoordinator = StarSearchCoordinator(navigationController: starsNavigationController)
        starsCoordinator.start()
        self.childCoordinator.append(starsCoordinator)
        
        let settingsNavigationController = UINavigationController()
        settingsNavigationController.tabBarItem.image = UIImage(systemName: Tabs.settings.image)
        settingsNavigationController.tabBarItem.title = Tabs.settings.title
        let settingsCoordinator = SettingsCoordinator(navigationController: settingsNavigationController)
        settingsCoordinator.start()
        self.childCoordinator.append(settingsCoordinator)
        
        self.tabController?.setViewControllers([
            liveNavigationController,
            favoritesNavigationController,
            starsNavigationController,
            settingsNavigationController], animated: true)
    }
    
    func setupLockScreen() {
        let keyID = SettingsViewModel.Settings.faceID.id
        if UserDefaults.standard.bool(forKey: keyID) && !(self.window?.rootViewController is BlockScreenViewController) {
            let viewController = BlockScreenViewController(coordinator: self)
            viewController.modalPresentationStyle = .fullScreen
            self.updatesRootViewController?(viewController)
        } else {
            self.authorized()
        }
    }
}

extension MainCoordinator: MainCoordinatorProtocol {
    func authorized() {
        self.updatesRootViewController?(self.tabController)
    }
}
