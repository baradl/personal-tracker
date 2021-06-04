//
//  AddWeightView.swift
//  personal_tracker (iOS)
//
//  Created by Bastian Radloff on 21.03.21.
//

import SwiftUI
import PartialSheet

struct AddWeightView: View {
    @State var weightValue: Double
    @Binding var hkManager: HKManager
    @ObservedObject var dataModel: DataModel
    let dateFormatter: DateFormatter
    
    @State var selectedDate: Date = Date()
    @EnvironmentObject var sheetManager : PartialSheetManager
    
    var body: some View {
        VStack{
            HStack{
                Button{
                    weightValue -= 0.1
                }label:{
                    MinusButton()
                        .padding()
                }
                CurrentWeightView(weight: Weight(weight: weightValue,
                                                timestamp: selectedDate),
                                  dateFormatter: dateFormatter)
                Button{
                    weightValue += 0.1
                }label:{
                    PlusButton()
                        .padding()
                }
            }
            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                .labelsHidden()
                .datePickerStyle(WheelDatePickerStyle())
            GeometryReader{geometry in
                HStack(alignment: .center){
                    Button(action: {
                        withAnimation(.easeInOut){
                            sheetManager.closePartialSheet()
                        }
                    }){
                        CancelButton(width: geometry.size.width * 0.4, height: 45)
                            .padding(.horizontal, 10)
                    }
                    Button(action: {
                        hkManager.saveWeight(weight: Weight(weight: weightValue, timestamp: selectedDate))
                        updateWeightTrackerData(hkManager: hkManager,
                                                dataModel: dataModel)
                        withAnimation(.easeInOut){
                            sheetManager.closePartialSheet()
                        }
                    }){
                        ConfirmationButton(width: geometry.size.width * 0.4, height: 45)
                            .padding(.horizontal, 10)
                    }
                }
                .frame(width: geometry.size.width, height: 40, alignment: .center)
            }
            Spacer()
        }
    }
}
