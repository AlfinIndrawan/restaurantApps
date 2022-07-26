import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initialize()
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {

    }
}

extension CoreDataManager {
    static var shared = CoreDataManager()
  }

private extension AppDelegate {
  func initialize() {
    setupDefaultColors()
  }
  func setupDefaultColors() {
    UIBarButtonItem.appearance().tintColor = .systemRed
    UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemRed], for: UIControl.State.selected)
    UINavigationBar.appearance().tintColor = .systemRed
  }
}
