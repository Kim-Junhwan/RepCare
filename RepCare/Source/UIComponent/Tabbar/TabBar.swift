//
//  TabBar.swift
//  RepCare
//
//  Created by JunHwan Kim on 2/23/25.
//

import SwiftUI

struct TabBarItem: Identifiable {
    var id: String
    var title: String
    var onClick: () -> Void
}

struct TabBar: View {
    
    let buttonList: [TabBarItem]
    @Binding var selectItemId: String
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                ForEach(buttonList) { item in
                    Tab(title: item.title, onClick: item.onClick, isSelect: item.id == selectItemId)
                }
            }
        }
        .frame(maxWidth: .infinity)
        
    }
}

struct Tab: View {
    
    let title: String
    let onClick: () -> Void
    let isSelect: Bool
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Button(action: onClick) {
                Text(title)
                    .fontWeight(isSelect ? .bold : .regular)
                    .foregroundStyle(isSelect ? .deepGreen : .black)
                    .frame(maxWidth: .infinity)
            }
            .frame(height: 48)
            .frame(maxWidth: .infinity)
            
            if isSelect {
                Rectangle()
                    .fill(.deepGreen)
                    .frame(height: 3)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    VStack {
        TabBar(
            buttonList: [.init(id: "1", title: "Test1", onClick: {}),
                         .init(id: "2", title: "Test2", onClick: {})], selectItemId: .constant("2")
        )
    }
    .frame(maxWidth: .infinity, alignment: .top)
}
