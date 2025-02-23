//
//  DetailPetView.swift
//  RepCare
//
//  Created by JunHwan Kim on 2/23/25.
//

import SwiftUI

struct DetailPetView: View {
    var body: some View {
        LazyVStack {
            Top()
            
//            Contents()
//                .layoutPriority(1)
        }
        .ignoresSafeArea(edges: .top)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

struct Top: View {
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image(.testCat)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.width)
            }
            .background(.red)
        }
        
    }
}

struct Contents: View {
    
    var body: some View {
        VStack {
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
}



#Preview {
    
}
