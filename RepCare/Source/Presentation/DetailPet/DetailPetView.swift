//
//  DetailPetView.swift
//  RepCare
//
//  Created by JunHwan Kim on 2/23/25.
//

import SwiftUI

struct DetailPetView: View {
    
    var body: some View {
        RPBaseView {
            GeometryReader { proxy in
                ScrollView {
                    VStack(spacing: 2) {
                        Top()
                            .frame(width: proxy.size.width)
                        Contents(selectTabBarType: .constant(.calendar_timeLine))
                            .frame(width: proxy.size.width)
                    }
                }
                .ignoresSafeArea(edges: .top)
                .background(.whiteGray)
            }
        }
    }
}

struct Top: View {
    
    @State
    var text: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            Color.clear
                .aspectRatio(1, contentMode: .fill)
                .overlay(alignment:.center, content: {
                    Image(.testCat)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                })
                .clipped()
            
            VStack(alignment:.leading) {
                Text("고양이")
                    .font(.system(size: 20, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer(minLength: 9)
                HStack(spacing: 5) {
                    Text("포유류")
                        .underline()
                        .foregroundStyle(.gray)
                        .font(.system(size: 16, weight: .medium))
                    
                    Text("·")
                    
                    Text("암컷")
                        .foregroundStyle(.gray)
                        .font(.system(size: 16, weight: .medium))
                    
                    Text("·")
                    
                    Text("D+9")
                        .foregroundStyle(.gray)
                        .font(.system(size: 16, weight: .medium))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            .padding(.vertical, 5)
            
            Spacer(minLength: 7)
            
            Rectangle()
                .foregroundStyle(.whiteGray)
                .frame(height: 1)
            
            Spacer(minLength: 7)
            
            ZStack {
                RPTextEditor(text: $text, placeholder: "메모")
            }
            .frame(minHeight: 50, maxHeight: .infinity)
            .padding(.horizontal, 16)
            .padding(.vertical, 5)
        }
        .frame(maxWidth: .infinity)
        .background(.white)
    }
}

struct Contents: View {
    
    @Binding
    var selectTabBarType: DetailPetViewModel.DetailPetTabBarType
    
    var body: some View {
        VStack {
            TabBar(buttonList:
                    DetailPetViewModel.DetailPetTabBarType.allCases.map { tabBarItem in
                TabBarItem(id: tabBarItem.title, title: tabBarItem.title, onClick: {
                    selectTabBarType = tabBarItem
                })
            }, selectItemId: .constant(DetailPetViewModel.DetailPetTabBarType.calendar_timeLine.title))
            
            switch selectTabBarType {
            case .calendar_timeLine:
                DetailPetCalendarView()
            case .weight:
                DetailPetWeightView()
            case .petPhoto:
                VStack{}
            }
        }
        .background(.white)
    }
}



#Preview {
    DetailPetView()
}
