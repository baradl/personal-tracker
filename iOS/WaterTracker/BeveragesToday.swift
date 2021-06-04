//
//  test.swift
//  personal_tracker (iOS)
//
//  Created by Bastian Radloff on 16.03.21.
//

import SwiftUI

struct TodaysBeveragesView: View {
    @Binding var hkManager: HKManager
    @ObservedObject var dataModel: DataModel
    var todaysBeverages: UserDefaults

    var body: some View {
        GeometryReader{ geometry in
            VStack{
                HStack{
                    BarplotTitleView(title: "Todays Beverages")
                    Spacer()
                    NavigationLink(destination: ChangeBeveragesView(hkManager: $hkManager,
                                                                    dataModel: dataModel,
                                                                    todaysBeverages: todaysBeverages),
                                   label:{
                                    Text("Change").padding(.horizontal, 10)
                            })
                }
                ScrollView(.horizontal){
                    HStack(spacing: 10){
                        ForEach(dataModel.todaysBeverages, id: \.id){beverage in
                            SelectedBeverageView(selectedBeverage: beverage)
                        }
                        .padding(.bottom, 10)
                        .padding(.horizontal, 10)
                    }
                }
                .padding()
            }
        }
    }
}

struct SelectedBeverageView: View {
    var selectedBeverage: SelectedBeverage
    let dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    var body: some View{
        VStack{
            Text(selectedBeverage.beverage.name)
                .font(.system(size: 12, weight: .light))
            Image(selectedBeverage.beverage.logopath)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            Text("\(selectedBeverage.portionsize)ml")
                .font(.system(size: 12, weight: .light))
                .frame(width: 48, height: 15)
            Text("\(dateFormatter.string(from: selectedBeverage.timestamp))")
                .font(.system(size: 12, weight: .light))
        }
    }
}
