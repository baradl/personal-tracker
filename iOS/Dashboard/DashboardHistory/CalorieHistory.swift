//
//  CalorieHistory.swift
//  personal_tracker (iOS)
//
//  Created by Bastian Radloff on 26.03.21.
//

import SwiftUI

struct CalorieHistoryView: View {
    @ObservedObject var dataModel: DataModel
    
    var body: some View {
        GeometryReader{geometry in
            VStack{
                VStack{
                    HStack{
                        LegendView(title: "Activity Energy", color: Color("BrightOrange"))
                        LegendView(title: "Basal Energy", color: Color("BaseBlue"))
                    }
                    
                    HStack{
                        SingleMetricView(title: "Max Active",
                                         valueString: String(format: "%.0f", dataModel.dailySumData.historyMetrics.activeEnergy.max),
                                         unitString: "kcal")
                        SingleMetricView(title: "Avg Active",
                                         valueString: String(format: "%.0f", dataModel.dailySumData.historyMetrics.activeEnergy.avg),
                                         unitString: "kcal")
                    }
                }
                .frame(width: geometry.size.width,
                       height: geometry.size.height * 0.15)
                
                Divider()
                    .foregroundColor(Color(.lightGray))
                    .padding(.horizontal, 10)

                VStack{
                    BarplotTitleView(title: "Days")
                    MultiBarplotView(activeEnergy: dataModel.dailySumData.days.activeEnergy,
                                     basalEnergy:  dataModel.dailySumData.days.basalEnergy)
                }
                .padding(.all, 5)
                
                VStack{
                    BarplotTitleView(title: "Weeks")
                    MultiBarplotView(activeEnergy: dataModel.dailySumData.weeks.activeEnergy,
                                     basalEnergy: dataModel.dailySumData.weeks.basalEnergy)
                }
                .padding(.all, 5)

                VStack{
                    BarplotTitleView(title: "Months")
                    MultiBarplotView(activeEnergy: dataModel.dailySumData.months.activeEnergy,
                                     basalEnergy: dataModel.dailySumData.months.basalEnergy)
                }
                .padding(.all, 5)
            }
            .navigationBarTitle("Calorie History")
        }
    }
}



struct LegendView : View {
    let title: String
    let color: Color
    
    var body: some View {
        HStack{
            Text("")
                .frame(width: 50, height: 20)
                .background(color)
                .cornerRadius(5)
                .padding(.leading, 10)
                .padding(.vertical, 10)
            Text(title)
                .font(.system(size: 14, weight: .light))
                .padding(.horizontal, 5)
                .padding(.vertical, 10)
        }.padding(.horizontal, 8)
    }
}
