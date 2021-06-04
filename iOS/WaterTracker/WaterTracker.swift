//
//  WaterTracker.swift
//  personal_tracker
//
//  Created by Bastian Radloff on 19.02.21.
//

import SwiftUI
import HealthKit
import PartialSheet

struct WaterTrackerView: View {
    @Binding var hkManager: HKManager
    @ObservedObject var dataModel: DataModel
    var todaysBeverages: UserDefaults
    
    @EnvironmentObject var sheetManager : PartialSheetManager
    let sheetStyle = PartialSheetStyle(background: .blur(.systemMaterialDark),
                                       handlerBarColor: Color(UIColor.systemGray2),
                                       enableCover: true,
                                       coverColor: Color.black.opacity(0.1),
                                       blurEffectStyle: nil,
                                       cornerRadius: 10,
                                       minTopDistance: UIScreen.main.bounds.height * 0.45)
    var body: some View{
        GeometryReader { geometry in
            VStack{                
                ValueTodayView(dataModel: dataModel)
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.24, alignment: .center)
                Divider()
                    .background(Color(.lightGray))
                    .padding(.horizontal, 10)
                TodaysBeveragesView(hkManager: $hkManager,
                                    dataModel: dataModel,
                                    todaysBeverages: todaysBeverages)
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.22)
                Divider()
                    .background(Color(.lightGray))
                    .padding(.horizontal, 10)
                ValuesLastDaysView(data: dataModel.dailySumData.days.water,
                                         key: "water",
                                         color: Color("WaterColor"))
                ValuesLastDaysView(data: dataModel.dailySumData.days.caffeine,
                                   key: "caffeine",
                                   color: Color("CaffeineColor"))
                Button(action: {
                                self.sheetManager.showPartialSheet({
                                     print("normal sheet dismissed")
                                }) {
                                    AddBeverageView(hkManager: $hkManager,
                                                    dataModel: dataModel,
                                                    todaysBeverages: todaysBeverages)
                                }
                            }, label: {
                                AddButton()
                            }).buttonStyle(PlainButtonStyle())
            }
            .navigationTitle("Water Tracker")
            .addPartialSheet(style: self.sheetStyle)
        }
    }
}


