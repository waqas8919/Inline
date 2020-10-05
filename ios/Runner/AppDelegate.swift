import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
     GeneratedPluginRegistrant.register(with: self)
            channel = FlutterMethodChannel.init(name: "dressme.lofesdev.com/geo",
                                            binaryMessenger: controller);
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    [FIRApp configure];
        [GeneratedPluginRegistrant registerWithRegistry:self];
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
