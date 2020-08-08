//
//  BarStack.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 10/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

final class GraphModel: ObservableObject {
    @Published var mode: Mode = .calendar
    
    /// what form this view is adopting
    enum Mode {
        case calendar
        case graph
        
        mutating func toggle() -> Void {
            switch self {
            case .calendar: self = .graph
            case .graph: self = .calendar
            }
        }
    }
    
    /// how far back to look
    var castBack: TimeInterval {
        switch mode {
        case .calendar: return dayLength * 0.5
        case .graph: return dayLength * 0
        }
    }
    
    /// how far forwards to look
    var castFwrd: TimeInterval {
        switch mode {
        case .calendar: return dayLength * 1.5
        case .graph: return dayLength * 1
        }
    }
    
    var days: Double {
        (castBack + castFwrd) / dayLength
    }
}

struct BarStack: View {
    
    @EnvironmentObject private var bounds: Bounds
    @EnvironmentObject private var zero: ZeroDate
    @EnvironmentObject var model: GraphModel
    @State private var filtering = false
    
    /// make a meaningless update to zero Date so it will load data from disk
    func jumpCoreDate() {
        zero.start += .leastNonzeroMagnitude
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottomLeading) {
                DayScroll(size: geo.size)
            
                HStack {
                    Image(systemName: "line.horizontal.3.decrease.circle")
                        .modifier(ButtonGlyph())
                        .onTapGesture {
                            filtering.toggle()
                        }
                        .fullScreenCover(isPresented: $filtering) {
                            FilterModal()
                        }
                    Image(systemName: "chevron.left")
                        .modifier(ButtonGlyph())
                        .onTapGesture {
                            zero.dateChange = .back
                            withAnimation {
                                zero.start -= weekLength
                            }
                        }
                    Image(systemName: "chevron.right")
                        .modifier(ButtonGlyph())
                        .onTapGesture {
                            zero.dateChange = .fwrd
                            withAnimation {
                                zero.start += weekLength
                            }
                        }
                    Image(systemName: "star")
                        .modifier(ButtonGlyph())
                        .onTapGesture {
                            withAnimation(.linear(duration: 0.4)) {
                                model.mode.toggle()
                            }
                        }
                }
                .padding(buttonPadding)
            }
        }
        /// keep it square
        .aspectRatio(1, contentMode: bounds.notch ? .fit : .fill)
        .onAppear(perform: jumpCoreDate)
    }
    
    func DayScroll(size: CGSize) -> some View {
        let dayHeight = size.height * zero.zoom
        return SafetyWrapper {
            ScrollView(.vertical, showsIndicators: false) {
                ScrollViewReader { proxy in
                    /// scroll anchor allows view to appear in the right position
                    EmptyView()
                        .id(0)
                        .offset(y: size.height)
                    HStack(spacing: .zero) {
                        TimeIndicator(divisions: evenDivisions(for: dayHeight))
                        LineGraph(dayHeight: dayHeight)
                    }
                        .frame(width: size.width, height: dayHeight * CGFloat(model.days))
                        /// block off part of the extended day strip
                        /// keeps focus on the white day area
                        .padding([.top, .bottom], model.mode == .graph ? -.zero : -dayHeight / 2)
                        .drawingGroup()
                        /// immediately center on white day area
                        .onAppear{ proxy.scrollTo(0, anchor: .center) }
                }
            }
        }
    }
}
