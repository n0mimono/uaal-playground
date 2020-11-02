//
//  Unity.swift
//  uaal
//
//  Created by Ryota Yokote on 2020/11/02.
//

import Foundation
import UnityFramework

protocol Unity {}

extension Unity {
    var unityCanvasSize: CGSize {
        return CGSize(width: 1125, height: 2436)
    }

    func canvasScalerReferenceResolution(width: CGFloat, height: CGFloat) {
        // 1125,2436
        sendMessage("CanvasScalerReferenceResolution", args: "\(width),\(height)")
    }

    func canvasScalerReferenceMatch(match: CGFloat) {
        // 1.0
        sendMessage("CanvasScalerReferenceMatch", args: "\(match)")
    }

    func panelSquareWidthAndHeight(width: CGFloat, height: CGFloat) {
        // 2436,2436
        sendMessage("PanelSquareWidthAndHeight", args: "\(width),\(height)")
    }

    func panelXWidthAndHeight(width: CGFloat, height: CGFloat) {
        // 1126,2436
        sendMessage("PanelXWidthAndHeight", args: "\(width),\(height)")
    }

    func sendMessage(_ method: String, args: String = "") {
        guard let ufw = UnityFramework.getInstance() else { return }

        ufw.sendMessageToGO(withName: "Cube", functionName: method, message: args)
    }

    func addUnityView(to parentView: UIView) {
        guard let ufw = UnityFramework.getInstance() else { return }
        guard let unityView = ufw.appController()?.rootView else { return }

        parentView.addSubview(unityView)
        unityView.translatesAutoresizingMaskIntoConstraints = false
        unityView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor).isActive = true
        unityView.centerYAnchor.constraint(equalTo: parentView.centerYAnchor).isActive = true
        unityView.widthAnchor.constraint(equalTo: parentView.widthAnchor, multiplier: 1.0).isActive = true
        unityView.heightAnchor.constraint(equalTo: parentView.heightAnchor, multiplier: 1.0).isActive = true
    }
}
