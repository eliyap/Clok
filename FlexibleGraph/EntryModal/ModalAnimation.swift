//
//  ModalAnimation.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 8/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

extension FlexibleGraph {
    func showModal(for entry: TimeEntry, at idx: Int) -> Void {
        
        let geometry = NamespaceModel(entryID: entry.id, dayIndex: idx)
        
        withAnimation(.easeInOut(duration: GraphConstants.modalOpacityDuration)) {
            passthroughGeometry = geometry
            passthroughSelected = entry
        }
        withAnimation(.easeInOut(duration: GraphConstants.heroAnimationDuration)) {
            model.selected = entry
            model.geometry = geometry
        }
    }
    
    
    /// Close modal view, discarding any changes made
    /// - Returns: `Void`
    func dismissModal() -> Void {
        /// delay animation such that opacity happens at the end
        withAnimation(Animation
            .easeInOut(duration: GraphConstants.modalOpacityDuration)
            .delay(GraphConstants.heroAnimationDuration - GraphConstants.modalOpacityDuration)
        ) {
            passthroughGeometry = nil
            passthroughSelected = nil
        }
        withAnimation(.easeInOut(duration: GraphConstants.heroAnimationDuration)) {
            model.selected = nil
            model.geometry = nil
        }
    }
    
    
    /// Close modal view, saving changes made to the `TimeEntry`
    /// - Parameter changed: EntryModel containing updated modified information
    /// - Returns: `Void`
    func saveChanges(_ changed: EntryModel) -> Void {
        model.selected?.update(from: changed, tags: tags)
        model.selected?.upload(with: cred.user!.token) { updated in
            model.selected?.update(from: <#T##EntryModel#>, tags: <#T##FetchedResults<Tag>#>)
        }
        dismissModal()
    }
}
