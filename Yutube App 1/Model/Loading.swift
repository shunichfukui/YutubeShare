//
//  Loading.swift
//  Yutube App 1
//
//  Created by USER on 2021/08/28.
//

import Foundation
import Lottie


class Loading {
    // Lottiefiles.com
    let animationView = AnimationView()
    func startAnimation(view: UIView) {
        let animation = Animation.named("loading")
        animationView.frame = CGRect(x: 0, y: 50, width: view.frame.size.width, height: view.frame.size.height/1.5)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        view.addSubview(animationView)
    }
    
    func stepAnimation() {
        animationView.removeFromSuperview()
    }
}
