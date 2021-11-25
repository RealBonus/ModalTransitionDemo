//
//  AnimatorConfiguration.swift
//  TabBarPlayground
//
//  Created by Павел Анохов on 19.11.2021.
//

import Foundation
import CoreGraphics

struct AnimatorConfiguration {
    let animationDuration: TimeInterval = 0.35
    let dimOverlayAlpha: CGFloat = 0.2
    let parallaxMultiplier: CGFloat = 0.3

    let snapshotTag: Int
    let dimOverlayTag: Int

    public init(snapshotTag: Int, dimOverlayTag: Int) {
        self.snapshotTag = snapshotTag
        self.dimOverlayTag = dimOverlayTag
    }
}
