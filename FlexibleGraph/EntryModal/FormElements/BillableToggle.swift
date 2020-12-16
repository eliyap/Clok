//
//  BillableToggle.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 11/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct BillableToggle: View {
    
    @Binding var billable: Bool
    
    var body: some View {
        HStack {
            Label {
                if billable {
                    Text("Billable")
                } else {
                    Text("Not Billable")
                }
            } icon: {
                SlashedView(condition: billable, color: billable ? .primary : .secondary) {
                    Text("$").font(Font.system(.title3, design: .rounded))
                }
            }
                .labelStyle(AlignedLabelStyle())
            Toggle("", isOn: $billable)
                /// prevent toggle (only) from being tapped
                .allowsHitTesting(false)
        }
            /// make whole area tappable to toggle
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation {
                    billable.toggle()
                }
            }
    }
}
