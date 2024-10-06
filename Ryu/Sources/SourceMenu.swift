//
//  SourceMenu.swift
//  Ryu
//
//  Created by Francesco on 05/07/24.
//

import UIKit

class SourceMenu {
    static weak var delegate: SourceSelectionDelegate?
    
    static func showSourceSelector(from viewController: UIViewController, sourceView: UIView?, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let sources: [(title: String, source: MediaSource, language: String)] = [
                ("AnimeWorld", .animeWorld, "🇮🇹"),
                ("GoGoAnime", .gogoanime, "🇺🇸"),
                ("AnimeHeaven", .animeheaven, "🇺🇸"),
                ("AnimeFire", .animefire, "🇵🇹"),
                ("Kuramanime", .kuramanime, "🇮🇩"),
                ("JKanime", .jkanime, "🇪🇸"),
                ("Anime3rb", .anime3rb, "🇸🇦"),
                ("HiAnime", .hianime, "🇺🇸"),
                ("Hanashi", .hanashi, "🇩🇪"),
                ("Anilibria", .anilibria, "🇷🇺")
            ]
            
            let alertController = UIAlertController(title: "Select Source", message: "Choose your preferred source.", preferredStyle: .actionSheet)
            
            for (title, source, language) in sources {
                let actionTitle = "\(title) \(language)"
                let action = UIAlertAction(title: actionTitle, style: .default) { _ in
                    UserDefaults.standard.selectedMediaSource = source
                    completion?()
                    delegate?.didSelectNewSource()
                }
                setSourceImage(for: action, named: title)
                alertController.addAction(action)
            }
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            if let popoverController = alertController.popoverPresentationController {
                if let sourceView = sourceView, sourceView.window != nil {
                    popoverController.sourceView = sourceView
                    popoverController.sourceRect = sourceView.bounds
                } else {
                    popoverController.sourceView = viewController.view
                    popoverController.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.midY, width: 0, height: 0)
                }
                popoverController.permittedArrowDirections = [.up, .down, .left, .right]
            }
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                alertController.modalPresentationStyle = .popover
            }
            
            viewController.present(alertController, animated: true)
        }
    }
    
    private static func setSourceImage(for action: UIAlertAction, named imageName: String) {
        guard let originalImage = UIImage(named: imageName) else { return }
        let resizedImage = originalImage.resized(to: CGSize(width: 35, height: 35))
        action.setValue(resizedImage.withRenderingMode(.alwaysOriginal), forKey: "image")
    }
}

protocol SourceSelectionDelegate: AnyObject {
    func didSelectNewSource()
}
