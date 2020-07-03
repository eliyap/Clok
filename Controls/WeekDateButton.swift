//
//  WeekDateButton.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 2/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct WeekDateButton: View {
    
    @EnvironmentObject private var zero: ZeroDate
    
    private let df = DateFormatter()
    private let padding = CGFloat(7)
    
    /// use raw values so we can animate them
    @State var widthLimit: CGFloat? = .nearZero
    @State var scale: CGFloat = 1
    
    @State var dateStart = ""
    @State var dateEnd = ""
    
    init () {
        df.setLocalizedDateFormatFromTemplate("MMMdd")
    }
    
    var body: some View {
        Button(action: scaleWidth) {
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
                EmptyView()
            }
            
            .onReceive(zero.$date, perform: { date in
                /// set labels programatically so that ellipsis animation does NOT play when changing date
                dateStart = df.string(from: date)
                dateEnd = " – " + df.string(from: date + weekLength)
            })
        }
            .buttonStyle(PlainButtonStyle())
    }
    
    
    func scaleWidth() -> Void {
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
    }
}

struct WeekDateButton_Previews: PreviewProvider {
    static var previews: some View {
        WeekDateButton()
    }
}
