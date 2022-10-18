//
//  Pie.swift
//  SUI
//
//  Created by F1xTeoNtTsS on 11.10.2022.
//

import SwiftUI

struct Pie: Shape {
    var startAngle: Angle
    var endAngle: Angle
    let clockwise: Bool = true
    
    var animatableData: AnimatablePair<Double, Double> {
        get {
            AnimatablePair(startAngle.radians, endAngle.radians)
        }
        set {
            startAngle = Angle.radians(newValue.first)
            endAngle = Angle.radians(newValue.second)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let start = CGPoint(
            x: center.x + radius * CGFloat(cos(self.startAngle.radians)),
            y: center.y + radius * CGFloat(sin(self.startAngle.radians))
        )
        
        var path = Path()
        path.move(to: center)
        path.addLine(to: start)
        path.addArc(center: center,
                    radius: radius,
                    startAngle: self.startAngle,
                    endAngle: self.endAngle,
                    clockwise: self.clockwise)
        path.addLine(to: center)
        return path
    }
}
