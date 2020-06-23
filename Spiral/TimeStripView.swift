//
//  TimeStripView.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.21.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct TimeStripView: View {
    @EnvironmentObject private var zero: ZeroDate
    
    private let df = DateFormatter()
    private let tf = DateFormatter()
    
    /// use raw values so we can animate them
    @State var widthLimit: CGFloat? = .nearZero
    @State var scale: CGFloat = 1
    
    @State var dateStart = ""
    @State var dateEnd = ""
    
    private let padding = CGFloat(7)
    
    var body: some View {
        HStack {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.25)) {
                    if self.widthLimit != nil {
                        self.widthLimit = nil
                        /// scaling to .zero causes `CGAffineTransformInvert: singular matrix.` warning
                        self.scale = .nearZero
                    } else {
                        self.widthLimit = .nearZero
                        self.scale = 1
                    }
                }
            }) {
                HStack(spacing: 0) {
                    /// scale animates disappearance
                    /// frame prevents it bloating stack width
                    Image(systemName: "chevron.left")
                        .scaleEffect(1 - scale + .nearZero)
                        .padding([.trailing], padding)
                        .frame(maxWidth: widthLimit)
                    
                    Text(dateStart)
                    Text(dateEnd)
                        .frame(maxWidth: widthLimit)
                        /// forces text to truncate, instead of expanding to infinite height
                        .lineLimit(1)
                    
                    /// scale animates disappearance
                    /// frame prevents it bloating the stack
                    Image(systemName: "chevron.right")
                        .padding([.leading], padding)
                        .scaleEffect(scale)
                        .frame(maxWidth: widthLimit == nil ? .nearZero : nil)
                }
                .onReceive(self.zero.$date, perform: { date in
                    /// set labels programatically so that ellipsis animation does NOT play when changing date
                    self.dateStart = self.df.string(from: self.zero.date)
                    self.dateEnd = " – " + self.df.string(from: self.zero.date + weekLength)
                })
            }
                .buttonStyle(PlainButtonStyle())
                .modifier(cornerLabelStyle(round: .right))
            
            Spacer()
            Text(self.tf.string(from: self.zero.date))
                .modifier(cornerLabelStyle(round: .left))
        }
        /// send to the bottom
    }
    
    init () {
        df.setLocalizedDateFormatFromTemplate("MMMdd")
        tf.timeStyle = .short
    }
    
}

struct cornerLabelStyle : ViewModifier {
    var round: IceCreamStick.rounded
    private let padding = CGFloat(10)
    
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(
                IceCreamStick(round: round)
                    .fill(Color(UIColor.systemBackground))
                    .opacity(0.8)
            )
            .padding([.top], padding / 2)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
