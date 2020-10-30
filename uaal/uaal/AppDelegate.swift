//
//  AppDelegate.swift
//  uaal
//
//  Created by Ryota Yokote on 2020/10/30.
//

import UIKit
import UnityFramework

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        func unityFramewokLoad() -> UnityFramework? {
            let bundlePath = "\(Bundle.main.bundlePath)/Frameworks/UnityFramework.framework"
            let bundle = Bundle(path: bundlePath)
            if let bundle = bundle, !bundle.isLoaded {
                bundle.load()
            }

            let ufw = bundle?.principalClass?.getInstance()
            if ufw?.appController() == nil {
                var header = _mh_execute_header
                ufw?.setExecuteHeader(&header)
            }
            return ufw
        }

        let ufw = unityFramewokLoad()
        ufw?.setDataBundleId("com.unity3d.framework")
        ufw?.runEmbedded(withArgc: CommandLine.argc, argv: CommandLine.unsafeArgv, appLaunchOpts: launchOptions)

        return true
    }
}
