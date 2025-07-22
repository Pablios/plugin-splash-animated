import Foundation
import Capacitor
import UIKit

@objc(PluginSplashAnimated)
public class PluginSplashAnimated: CAPPlugin {

    var splashView: UIView?
    var imageView: UIImageView?

    @objc func showSplash(_ call: CAPPluginCall) {
        DispatchQueue.main.async {

            guard let window = UIApplication.shared.windows.first else {
                call.reject("No window available")
                return
            }

            let splashView = UIView(frame: window.bounds)
            splashView.backgroundColor = UIColor.white

            let imageView = UIImageView(frame: splashView.bounds)
            imageView.contentMode = .scaleAspectFit
            imageView.center = splashView.center

            // Configura imagens para animar basicamente um sequencial
            let images = (1...10).compactMap { UIImage(named: "splash_\($0)") }
            imageView.animationImages = images
            imageView.animationDuration = 2.0
            imageView.animationRepeatCount = 0
            imageView.startAnimating()

            splashView.addSubview(imageView)

            window.addSubview(splashView)
            window.bringSubviewToFront(splashView)

            self.splashView = splashView
            self.imageView = imageView

            call.resolve()
        }
    }

    @objc func hideSplash(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            self.imageView?.stopAnimating()
            self.splashView?.removeFromSuperview()
            self.imageView = nil
            self.splashView = nil
            call.resolve()
        }
    }
}
