//
//  Badge.swift
//  Landwarks
//
//  Created by Secret Asian Man 3 on 20.04.16.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.

import SwiftUI



struct Badge: View {
    var body: some View {
        
        ZStack {
            //            ForEach(entries, id: \.id){ entry in
            //                Spiral(
            //                    theta1: entry.startTheta,
            //                    theta2: entry.endTheta
            //                ).fill(Color.red)
            //
            //            }
            
            Spiral(
                theta1: entry[0].startTheta,
                theta2: entry[0].endTheta
            ).fill(Color.red)
        }
        .frame(width: frame_size, height: frame_size)
        .scaleEffect(CGFloat(3.5), anchor: .center)
        .onAppear{
            toggl_request(token: myToken)
        }
    }
}


struct Badge_Previews: PreviewProvider {
    static var previews: some View {
        Badge()
    }
}
