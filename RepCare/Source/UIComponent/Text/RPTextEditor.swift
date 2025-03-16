//
//  RPTextEditor.swift
//  RepCare
//
//  Created by JunHwan Kim on 3/16/25.
//

import SwiftUI
struct RPTextEditor: View {
    @Binding
    var text: String
    
    let placeholder: String?
    
    var body: some View {
        TextEditor(text: $text)
            .overlay(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder ?? "")
                        .foregroundStyle(.gray)
                }
            }
    }
}

#Preview {
    RPTextEditor(text: .constant(""), placeholder: "고양이")
}
