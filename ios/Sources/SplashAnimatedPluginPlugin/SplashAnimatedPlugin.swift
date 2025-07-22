import Foundation

@objc public class SplashAnimatedPlugin: NSObject {
    @objc public func echo(_ value: String) -> String {
        print(value)
        return value
    }
}
