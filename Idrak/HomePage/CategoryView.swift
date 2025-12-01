//
//  CategoryView.swift
//  Idrak2
//
//  Created by Noura Alsbuayt on 09/06/1447 AH.
//

import SwiftUI


struct CategoryView: View {
    @Binding var hyperSelected: Bool
    @Binding var focusSelected: Bool
    @Binding var distractionSelected: Bool
    
    var body: some View {
        
        ZStack {
            BubbleView(
                color: Color("IdrakBlue"),
                title: "Hyperactivity",
                systemIcone: "dumbbell",
                isSelected: hyperSelected
            ) {
                hyperSelected = true
                focusSelected = false
                distractionSelected = false
            }
            .offset(x: -80, y: 10)
            
            BubbleView(
                color: Color("IdrakYellow"),
                title: "Focus",
                systemIcone: "puzzlepiece.fill",
                isSelected: focusSelected
            ) {
                hyperSelected = false
                focusSelected = true
                distractionSelected = false
            }
            .offset(x: 80, y: 10)
            
            BubbleView(
                color: Color("IdrakTeal"),
                title: "Distraction",
                systemIcone: "leaf.fill",
                isSelected: distractionSelected
            ) {
                hyperSelected = false
                focusSelected = false
                distractionSelected = true
            }
            .offset(x: 0, y: 110)
        }
        .frame(height: 260)
    }
}

