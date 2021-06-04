//
//  WeightTracker.swift
//  personal_tracker
//
//  Created by Bastian Radloff on 19.02.21.
//

import SwiftUI
import PartialSheet

struct WeightTrackerView: View {
    @Binding var hkManager: HKManager
    @ObservedObject var dataModel: DataModel
    
    @EnvironmentObject var sheetManager : PartialSheetManager
    let sheetStyle = PartialSheetStyle(background: .blur(.systemMaterialDark),
                                       handlerBarColor: Color(UIColor.systemGray2),
                                       enableCover: true,
                                       coverColor: Color.black.opacity(0.1),
                                       blurEffectStyle: nil,
                                       cornerRadius: 10,
                                       minTopDistance: UIScreen.main.bounds.height * 0.4)
    
    let dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d"
        return formatter
    }()
    
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View{
        VStack{
            Button(action: {
                            self.sheetManager.showPartialSheet({
                                 print("normal sheet dismissed")
                            }) {
                                AddWeightView(weightValue: dataModel.currentWeight?.weight ?? 0.0,
                                                                          hkManager: $hkManager,
                                                                          dataModel: dataModel,
                                                                          dateFormatter: dateFormatter)
                            }
                        }, label: {
                            CurrentWeightView(weight: dataModel.currentWeight ?? Weight(weight: 0.0, timestamp: Date()),
                                              dateFormatter: dateFormatter)
                        })
            Divider()
            HistoryPlotView(dataModel: dataModel)
            Divider()
            HistoryWeightView(dataModel: dataModel,
                              hkManager: $hkManager,
                              dateFormatter: dateFormatter)
        }.addPartialSheet(style: sheetStyle)
        .navigationTitle("Weight Tracker")
        .onAppear{
            updateWeightTrackerData(hkManager: hkManager,
                                         dataModel: dataModel)
        }
    }
}
