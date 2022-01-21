//
//  WeightHistoryView.swift
//  personal_tracker (iOS)
//
//  Created by Bastian Radloff on 21.03.21.
//

import SwiftUI

struct HistoryWeightView: View {
    @ObservedObject var dataModel: DataModel
    @Binding var hkManager: HKManager
    let dateFormatter: DateFormatter
    
    @State var currentYear: Int = Calendar.current.dateComponents([.year], from: Date()).year!
    let listTextSize: CGFloat = 18
    
    var body: some View {
        let weightsByYear = splitWeightsIntoYears(weights: dataModel.weights)
        List{
            ForEach(weightsByYear, id: \.self){weightsYear in
                if weightsYear.count != 0 {
                    let currentYear = Calendar.current.dateComponents([.year], from: weightsYear[0].timestamp).year!
//                    if currentYear == 2022 {
//                        let _ = print(
//                    }
                    if currentYear == 2022 {
                        Section(header: YearBreakView(year: currentYear,
                                                      textSize: listTextSize)){
                            ForEach(weightsYear, id: \.id) {weight in
                                HStack{
                                    Text("\(dateFormatter.string(from: weight.timestamp))")
                                        .font(.system(size: listTextSize, weight: .light))
                                        .padding(.horizontal, 5)
                                    Spacer()
                                    Text("\("\(String(format: "%.1f", weight.weight))kg")")
                                        .font(.system(size: listTextSize, weight: .bold))
                                        .padding(.horizontal, 5)
                                }.padding(.vertical, 5)
                            }.onDelete(perform: self.deleteRow)
                        }
                    } else {
                        Section(header: YearBreakView(year: currentYear,
                                                      textSize: listTextSize)){
                            ForEach(weightsYear, id: \.id) {weight in
                                HStack{
                                    Text("\(dateFormatter.string(from: weight.timestamp))")
                                        .font(.system(size: listTextSize, weight: .light))
                                        .padding(.horizontal, 5)
                                    Spacer()
                                    Text("\("\(String(format: "%.1f", weight.weight))kg")")
                                        .font(.system(size: listTextSize, weight: .bold))
                                        .padding(.horizontal, 5)
                                }.padding(.vertical, 5)
                            }
                        }
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
    }
    
    func deleteRow(at indexSet: IndexSet){
        for index in indexSet{
            let weight: Weight = dataModel.weights[index]
            dataModel.weights.remove(at: index)
            hkManager.deleteWeight(weight: weight)
            updateWeightTrackerData(hkManager: hkManager,
                                    dataModel: dataModel)
        }
    }
}

struct YearBreakView : View {
    let year: Int
    let textSize: CGFloat
    var body: some View {
        HStack{
            Text(String(year))
                .font(.system(size: textSize))
                .padding(.horizontal, 5)
            Spacer()
        }
        .padding(.all, 5)
    }
}

func splitWeightsIntoYears(weights: Array<Weight>) -> Array<Array<Weight>> {
    let years = [2022, 2021, 2020, 2019, 2018, 2017, 2016, 2015]
    var weightsByYear: Array<Array<Weight>> = []
    for year in years {
        let weightsYear = weights.filter{weight in
            return weightYear(weight: weight) == year
        }
        weightsByYear.append(weightsYear)
    }
    return weightsByYear
}

func weightYear(weight: Weight) -> Int {
    return Calendar.current.dateComponents([.year], from: weight.timestamp).year!
}
