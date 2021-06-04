//
//  ActivityRing.swift
//  personal_tracker (iOS)
//
//  Created by Bastian Radloff on 25.03.21.
//

import SwiftUI
import HealthKit
import HealthKitUI

struct ActivityRingView: View {
    var activitySummary: HKActivitySummary?
    let size: CGFloat
    
    var body: some View{
        ActivityRings(activitySummary: activitySummary)
            .frame(width: size, height: size)
    }
}

struct ActivityRings: UIViewRepresentable {
    var activitySummary: HKActivitySummary?
    
    func makeUIView(context: Context) -> HKActivityRingView {
        HKActivityRingView()
    }

    func updateUIView(_ uiView: HKActivityRingView, context: Context) {
        uiView.setActivitySummary(self.activitySummary, animated: true)
    }
}
