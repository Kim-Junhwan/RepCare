//
//  DetailPetView.swift
//  RepCare
//
//  Created by JunHwan Kim on 2/23/25.
//

import SwiftUI

struct DetailPetView: View {
    
    var body: some View {
        VStack(spacing: 0) {
            Top()
            Contents()
                .layoutPriority(1)
        }
        .ignoresSafeArea(edges: .top)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

struct Top: View {
    
    var body: some View {
        VStack {
            GeometryReader { geo in
                Image(.testCat)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.width)
            }
            .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
            .frame(maxWidth: .infinity)
            VStack(alignment:.leading) {
                HStack {
                    Text("고양이")
                    Spacer()
                    Text("입양한지 13일째")
                }
                Text("치즈냥이")
            }
            .frame(maxWidth: .infinity)
        }
        
        
    }
}

struct Contents: View {
    
    var body: some View {
        VStack {
            TabBar(buttonList: [
                TabBarItem(
                    id: DetailPetViewModel.DetailPetTabBarType.calendar_timeLine.title,
                    title: DetailPetViewModel.DetailPetTabBarType.calendar_timeLine.title,
                    onClick: {}),
                TabBarItem(
                    id: DetailPetViewModel.DetailPetTabBarType.weight.title,
                    title: DetailPetViewModel.DetailPetTabBarType.weight.title,
                    onClick: {})
            ], selectItemId: .constant(DetailPetViewModel.DetailPetTabBarType.calendar_timeLine.title))
            
            
        }
    }
}



#Preview {
    DetailPetView()
}
