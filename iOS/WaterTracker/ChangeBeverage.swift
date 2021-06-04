//
//  ChangeBeverage.swift
//  personal_tracker (iOS)
//
//  Created by Bastian Radloff on 17.03.21.
//

import SwiftUI

struct ChangeBeveragesView: View {
    @Binding var hkManager: HKManager
    @ObservedObject var dataModel: DataModel
    var todaysBeverages: UserDefaults
    let dateFormatter: DateFormatter = getDateFormatter(format: "HH:mm")
    let listTextSize: CGFloat = 18
    
    var body: some View {
        List{
            ForEach(dataModel.todaysBeverages, id: \.id) { selectedBeverage in
                HStack{
                    Image(selectedBeverage.beverage.logopath)
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color(.white))
                        .padding(.horizontal, 10)
                    Text(selectedBeverage.beverage.name)
                        .font(.system(size: listTextSize, weight: .light))
                        .padding(.horizontal, 10)
                    Spacer()
                    Text("\(dateFormatter.string(from: selectedBeverage.timestamp))")
                        .font(.system(size: listTextSize, weight: .light))
                        .padding(.horizontal, 10)
                    HStack{
                        Text("\(selectedBeverage.portionsize)")
                            .font(.system(size: listTextSize, weight: .bold))
                            .padding(.leading, 10)
                        Text("ml")
                            .font(.system(size: listTextSize))
                            .padding(.trailing, 10)
                            .foregroundColor(Color(.lightGray))
                    }
                }.padding(.vertical, 5)
            }.onDelete(perform: self.deleteRow)
        }.navigationBarTitle("Delete Beverages")
    }
    
    func deleteRow(at indexSet: IndexSet){
        for index in indexSet{
            print("Water Before: \(dataModel.dailySumData.days.water)")
            let selectedBeverage = dataModel.todaysBeverages[index]
            dataModel.deleteFromTodaysBeverages(selectedBeverage: selectedBeverage,
                                                todaysBeverages: todaysBeverages)
            hkManager.deleteBeverage(selectedBeverage: selectedBeverage)
            print("Water After: \(dataModel.dailySumData.days.water)")
        }
    }
}
