import FirebaseCore
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        // Set the app to always use light mode
        setLightMode()
        
        return true
    }
    
    func setLightMode() {
        if #available(iOS 15.0, *) {
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            windowScene?.windows.first?.overrideUserInterfaceStyle = .light
        } else {
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
        }
    }
}

@main
struct Daily_WinsApp: App {
    @StateObject var viewModel = NewItemViewViewModel()
    @StateObject private var sharedData = SharedData()

    init() {
        NotificationManager.shared.requestAuthorization()
    }
    
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .environmentObject(viewModel)
                PetView()
                    .environmentObject(sharedData)
            }
            .onAppear {
                // Ensure light mode is set when the app appears
                setLightMode()
            }
        }
    }
    
    func setLightMode() {
        if #available(iOS 15.0, *) {
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            windowScene?.windows.first?.overrideUserInterfaceStyle = .light
        } else {
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
        }
    }
}
