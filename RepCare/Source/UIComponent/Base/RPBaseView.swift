//
//  RPBaseView.swift
//  RepCare
//
//  Created by JunHwan Kim on 3/16/25.
//

import SwiftUI

struct RPBaseView<Content: View>: View {
    
    @ViewBuilder
    var content: () -> Content
    
    
    var body: some View {
        ZStack {
            content()
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
