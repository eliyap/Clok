//
//  IconView.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 1/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

struct IconView: View {
    var body: some View {
        Image("Icon")
            .resizable()
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .frame(width: 100, height: 100)
            .padding()
    }
}
