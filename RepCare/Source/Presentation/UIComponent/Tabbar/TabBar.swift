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
    
    var body: some View {
        ZStack {
            HStack {
                ForEach(buttonList) { item in
                    Tab(title: item.title, onClick: item.onClick, isSelect: true)
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
            }
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            
            if isSelect {
                Rectangle()
                    .fill(.red)
                    .frame(height: 3)
            }
        }
    }
}

#Preview {
    VStack {
        TabBar(
            buttonList: [.init(id: "1", title: "Test1", onClick: {}),
                         .init(id: "2", title: "Test2", onClick: {})]
        )
    }
    .frame(maxWidth: .infinity, alignment: .top)
}
