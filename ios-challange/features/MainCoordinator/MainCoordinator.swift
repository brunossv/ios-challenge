//
//  MainCoordinator.swift
//  ios-challange
//
//  Created by Bruno Soares on 16/01/25.
//
import UIKit

class MainCoordinator: Coordinator {
    
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
        
        self.tabController?.setViewControllers([liveNavigationController, favoritesNavigationController], animated: true)
    }
    
    func back() {
        
    }
    
    func dismiss(_ handler: (() -> Void)?) {
        
    }
}
