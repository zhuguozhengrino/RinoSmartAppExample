//
//  RinoBasicPanelAnimationView.swift
//  Rino
//
//  Created by zhangstar on 2024/1/17.
//

import UIKit
import RinoAppConfigModule
import Foundation
import Lottie

@objcMembers public class RinoBasicPanelAnimationView: UIView {
    let loadingView = AnimationView();
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        let containerBundle = Bundle(for: type(of: self))
        
        guard let bundlePath = containerBundle.path(forResource: "RinoPanelContainerModule", ofType: "bundle") else {
            fatalError("Could not get bundle path for RinoPanelContainerModule.bundle")
        }
        guard let bundle = Bundle(path: bundlePath) else {
            fatalError("Could not get bundle for RinoPanelContainerModule.bundle")
        }
        var imagePathFile = String()
        if Theme().styleMode == RinoStyleModeDark {
            imagePathFile = "rino_panel_loading_dark"
        } else {
            imagePathFile = "rino_panel_loading_light"
        }
        guard let filePath = bundle.path(forResource: imagePathFile, ofType: "json") else {
            fatalError("Could not get path for rino_panel_loading.json in RinoPanelContainerModule.bundle")
        }
        
        let filePathStr = filePath as NSString
        if filePathStr.length > 0 {
            loadingView.animation = Animation.filepath(filePath)
        } else {
            loadingView.animation = Animation.named("rino_panel_loading_light")
        }

        loadingView.loopMode = .loop
        loadingView.contentMode = .scaleAspectFit
        loadingView.backgroundBehavior = .pauseAndRestore
        self.addSubview(loadingView)
    }
    
    required init?(coder: NSCoder) {
        super .init(coder: coder)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        loadingView.frame = self.bounds;
    }
    
    public func beginAnimation() {
        loadingView.play()
    }
}
