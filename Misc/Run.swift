//
//  Run.swift
//  Clok
//  Taken from: 
//  https://zacwhite.com/2019/scrollview-content-offsets-swiftui/

import SwiftUI

struct Run: View {
    let block: () -> Void

    var body: some View {
        DispatchQueue.main.async(execute: block)
        return AnyView(EmptyView())
    }
}

