import Foundation
import Capacitor

@objc(SplashAnimatedPluginPlugin)
public class SplashAnimatedPluginPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "SplashAnimatedPluginPlugin"
    public let jsName = "SplashAnimatedPlugin"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "echo", returnType: CAPPluginReturnPromise)
    ]
    private let implementation = SplashAnimatedPlugin()

    @objc func echo(_ call: CAPPluginCall) {
        let value = call.getString("value") ?? ""

        call.resolve([
            "value": implementation.echo(value)
        ])
    }
}
