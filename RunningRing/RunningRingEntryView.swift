//
//  RunningRingEntryView.swift
//  RunningRingExtension
//
//  Created by Secret Asian Man 3 on 20.09.26.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct RunningRingEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        RunningSquare()
//        RunningEntryRing(entry: entry)
    }
}

