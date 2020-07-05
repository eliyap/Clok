//
//  Clockhands.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 3/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI


struct Clockhands: View {
    
    @EnvironmentObject var zero: ZeroDate
    
    private let size = CGFloat(50)
    
    var body: some View {
        VStack(spacing: .zero) {
            HStack{
                Spacer()
                if zero.showTime {
                    Encircle(h2400())
                        .transition(.inAndOut(edge: .top))
                        .padding(.top, -size/3)
                }
                Spacer()
            }
            Spacer()
            HStack{
                if zero.showTime {
                    Encircle(h1800())
                        .transition(.inAndOut(edge: .leading))
                        .padding(.leading, -size/3)
                }
                Spacer()
                if zero.showTime {
                    Encircle(h0600())
                        .transition(.inAndOut(edge: .trailing))
                        .padding(.trailing, -size/3)
                }
            }
            Spacer()
            HStack{
                Spacer()
                if zero.showTime {
                    Encircle(h1200())
                        .transition(.inAndOut(edge: .bottom))
                        .padding(.bottom, -size/3)
                }
                Spacer()
            }
        }
    }
    func h2400() -> Text {
        if is24hour() {
            return Text("24")
        } else {
            return Text("12MN")
        }
    }
    func h0600() -> Text {
        if is24hour() {
            return Text("06")
        } else {
            return Text("6AM")
        }
    }
    func h1200() -> Text {
        if is24hour() {
            return Text("12")
        } else {
            return Text("12NN")
        }
    }
    func h1800() -> Text {
        if is24hour() {
            return Text("18")
        } else {
            return Text("6PM")
        }
    }
    
    func Encircle(_ text: Text) -> some View {
        text
            .font(.caption)
            .padding()
            .background(Circle().foregroundColor(Color(UIColor.systemBackground)))
    }

}
