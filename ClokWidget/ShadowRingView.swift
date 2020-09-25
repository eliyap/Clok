//
//  ShadowRing.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 25/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct ShadowRing: View {
    
    @FetchRequest(entity: Project.entity(), sortDescriptors: []) var projects: FetchedResults<Project>
    
    let angle = Angle(degrees: 30)
    
    var body: some View {
        ForEach(projects, id: \.id) {
            Ring(project: $0)
        }
        
    }
    
    let colorAdjustment = CGFloat(0.17)
    let weight = CGFloat(15)
    
    func Ring(project: ProjectLike) -> some View {
        GeometryReader { geo in
            ZStack {
                SemiCircle()
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [
                                project.wrappedColor.darken(by: colorAdjustment),
                                project.wrappedColor.darken(by: colorAdjustment),
                                project.wrappedColor
                            ]),
                            center: .bottom
                        ),
                        lineWidth: weight
                    )
                    .frame(
                        width: geo.size.width,
                        height: geo.size.height / 2
                    )
                    .offset(y: geo.size.height / -4)
                Circle()
                    .frame(width: weight, height: weight)
                    .foregroundColor(project.wrappedColor.lighten(by: colorAdjustment))
                    .offset(x: geo.size.height / -2)
                SemiCircle()
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [
                                project.wrappedColor,
                                project.wrappedColor,
                                project.wrappedColor.lighten(by: colorAdjustment)
                            ]),
                            center: .bottom
                        ),
                        lineWidth: weight
                    )
                    .offset(y: geo.size.height / -4)
                    .rotationEffect(.tau / 2)
                    .frame(
                        width: geo.size.width,
                        height: geo.size.height / 2
                    )
            }
            .rotationEffect(angle + .tau / 4)
        }
        .frame(width: 60, height: 60)
        .padding()
    }
}

extension Color {
    func darken(by percentage: CGFloat = 0.05) -> Color {
        let (r,g,b,a) = components
        let (red, green, blue, alpha) = (
            Double(max(0, r * (1 - percentage))),
            Double(max(0, g * (1 - percentage))),
            Double(max(0, b * (1 - percentage))),
            Double(a)
        )
        return Color(
            .sRGB,
            red: red,
            green: green,
            blue: blue,
            opacity: alpha
        )
    }
    
    func lighten(by percentage: CGFloat = 0.05) -> Color {
        let (r,g,b,a) = components
        let (red, green, blue, alpha) = (
            Double(min(1, r * (1 + percentage))),
            Double(min(1, g * (1 + percentage))),
            Double(min(1, b * (1 + percentage))),
            Double(a)
        )
        return Color(
            .sRGB,
            red: red,
            green: green,
            blue: blue,
            opacity: alpha
        )
    }
}
