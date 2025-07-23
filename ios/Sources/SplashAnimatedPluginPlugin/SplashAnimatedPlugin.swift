import Foundation
import Capacitor
import UIKit
import ImageIO

@objc(SplashAnimatedPlugin)
public class SplashAnimatedPlugin: CAPPlugin {
    var splashView: UIView?
    var imageView: UIImageView?

    @objc func showSplash(_ call: CAPPluginCall) {
        DispatchQueue.main.async {

            guard let window = UIApplication.shared.windows.first else {
                call.reject("No window available")
                return
            }

            guard let base64String = call.getString("base64") else {
                call.reject("Base64 image is required")
                return
            }

            let cleanBase64 = base64String.components(separatedBy: ",").last ?? base64String
            
            guard let imageData = Data(base64Encoded: cleanBase64) else {
                call.reject("Failed to decode base64 image")
                return
            }

            let image = self.animatedImageFromData(data: imageData) ?? UIImage(data: imageData)

            guard let finalImage = image else {
                call.reject("Failed to create image from data")
                return
            }

            let splashView = UIView(frame: window.bounds)
            splashView.backgroundColor = UIColor.white

            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.image = finalImage

            splashView.addSubview(imageView)
            window.addSubview(splashView)
            window.bringSubviewToFront(splashView)

            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: splashView.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: splashView.bottomAnchor),
                imageView.leadingAnchor.constraint(equalTo: splashView.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: splashView.trailingAnchor)
            ])

            self.splashView = splashView
            self.imageView = imageView

            call.resolve()
        }
    }

    func animatedImageFromData(data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            return nil
        }

        let count = CGImageSourceGetCount(source)

        if count <= 1 {
            return nil
        }

        var images = [UIImage]()
        var duration = 0.0

        for i in 0..<count {
            guard let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) else {
                continue
            }
            images.append(UIImage(cgImage: cgImage))

            let properties = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as Dictionary?
            let gifProperties = properties?[kCGImagePropertyGIFDictionary] as? NSDictionary
            let delay = gifProperties?[kCGImagePropertyGIFUnclampedDelayTime] as? Double ??
                        gifProperties?[kCGImagePropertyGIFDelayTime] as? Double ?? 0.1
            duration += delay
        }

        if duration == 0 {
            duration = Double(count) * 0.1
        }

        return UIImage.animatedImage(with: images, duration: duration)
    }

    @objc func hideSplash(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, animations: {
                self.splashView?.alpha = 0
            }, completion: { _ in
                self.imageView?.stopAnimating()
                self.splashView?.removeFromSuperview()
                self.imageView = nil
                self.splashView = nil
                call.resolve()
            })
        }
    }

    @objc public func echo(_ value: String) -> String {
        return value
    }
}
