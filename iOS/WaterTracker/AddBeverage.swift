//
//  BeverageMenuView.swift
//  personal_tracker
//
//  Created by Bastian Radloff on 20.02.21.
//

import SwiftUI
import HealthKit
import PartialSheet

struct AddBeverageView: View {
    var beverages: [Beverage] = createBeverages()
    
    @Binding var hkManager: HKManager
    @ObservedObject var dataModel: DataModel
    var todaysBeverages: UserDefaults
    
    @State var index: Int = -1
    
    @EnvironmentObject var sheetManager : PartialSheetManager
    
    var body: some View {
        BeverageOptionsView(hkManager: $hkManager,
                            dataModel: dataModel,
                            todaysBeverages: todaysBeverages,
                            beverages: beverages,
                            index: $index).environmentObject(sheetManager)
            .navigationTitle("Select Beverage")
    }
}


struct BeverageOptionsView: View {
    @Binding var hkManager: HKManager
    @ObservedObject var dataModel: DataModel
    var todaysBeverages: UserDefaults
    
    var beverages: [Beverage]
    @Binding var index: Int
    
    @EnvironmentObject var sheetManager : PartialSheetManager
    
    var body: some View{
        VStack{
            HStack{
                ForEach(0..<3){i in
                    Button(action: {
                                    self.sheetManager.showPartialSheet({
                                         print("normal sheet dismissed")
                                    }) {
                                        ConfirmBeverageView(hkManager: $hkManager,
                                                            dataModel: dataModel,
                                                            todaysBeverages: todaysBeverages,
                                                            beverage: beverages[i])
                                    }
                                }, label: {
                                    BeverageButton(beverage: beverages[i])
                                        .padding(.horizontal, 15)
                                })
                    if i != 2 {
                        Spacer()
                    }
                }
            }.padding()
            HStack{
                ForEach(3..<6){i in
                    Button(action: {
                                    self.sheetManager.showPartialSheet({
                                         print("normal sheet dismissed")
                                    }) {
                                        ConfirmBeverageView(hkManager: $hkManager,
                                                            dataModel: dataModel,
                                                            todaysBeverages: todaysBeverages,
                                                            beverage: beverages[i])
                                    }
                                }, label: {
                                    BeverageButton(beverage: beverages[i])
                                        .padding(.horizontal, 15)
                                })
                    if i != 5 {
                        Spacer()
                    }
                }
            }.padding()
            HStack{
                ForEach(6..<9){i in
                    Button(action: {self.sheetManager.showPartialSheet({
                                         print("normal sheet dismissed")
                                    }) {
                                        ConfirmBeverageView(hkManager: $hkManager,
                                                            dataModel: dataModel,
                                                            todaysBeverages: todaysBeverages,
                                                            beverage: beverages[i])
                                    }
                                }, label: {
                                    BeverageButton(beverage: beverages[i])
                                        .padding(.horizontal, 15)
                                })
                    if i != 8 {
                        Spacer()
                    }
                }
            }.padding()
        }
    }
}

struct ConfirmBeverageView : View {
    @Binding var hkManager: HKManager
    @ObservedObject var dataModel: DataModel
    var todaysBeverages: UserDefaults
    let beverage: Beverage
    
    @State var selectedPortionsize: Int = 0
    let dateFormatter: DateFormatter = getDateFormatter(format: "dd.MM.yy, HH:mm")
    @EnvironmentObject var sheetManager : PartialSheetManager
    
    var body: some View {
        VStack{
            PortionOptionsView(beverage: beverage,
                               selectedPortionsize: $selectedPortionsize)
                .offset(y: -20)
            let water = Int(Float(selectedPortionsize) * beverage.water)
            let caffeine = Int(Float(selectedPortionsize) * beverage.caffeine)
            let timestamp = Date()
            GeometryReader{geometry in
                VStack(alignment: .center){
                    Text("\(selectedPortionsize)ml of \(beverage.name)")
                        .font(.title3)
                    Text("Water: \(water)ml, Caffeine: \(caffeine)mg")
                        .font(.footnote)
                    Text("Timestamp: \(dateFormatter.string(from: timestamp))")
                        .font(.footnote)
                    HStack{
                        Button(action: {
                            withAnimation(.easeInOut){
                                sheetManager.closePartialSheet()
                            }
                        }){
                            CancelButton(width: geometry.size.width * 0.4, height: 40)
                                .padding(.horizontal, 10)
                        }
                        Button(action: {
                            let selectedBeverage = SelectedBeverage(beverage: beverage,
                                                                    portionsize: selectedPortionsize,
                                                                    timestamp: timestamp)
                            hkManager.saveBeverage(selectedBeverage: selectedBeverage)
                            dataModel.addToTodaysBeverages(selectedBeverage: selectedBeverage,
                                                            todaysBeverages: todaysBeverages)
                            dataModel.updateWaterTrackerData(water: Double(selectedBeverage.beverage.water) * Double(selectedBeverage.portionsize),
                                                             caffeine: Double(selectedBeverage.beverage.caffeine) * Double(selectedBeverage.portionsize))
                            withAnimation(.easeInOut){
                                sheetManager.closePartialSheet()
                            }
                        }){
                            ConfirmationButton(width: geometry.size.width * 0.4, height: 40)
                                .padding(.horizontal, 10)
                        }
                    }
                    .frame(width: geometry.size.width, height: 40, alignment: .center)
                    .padding(.vertical, 10)
                }
                .offset(y: -30)
            }
            Spacer()
            
            
        }
    }
}

struct PortionOptionsView : View {
    let beverage: Beverage
    @Binding var selectedPortionsize: Int
    
    var body: some View {
        HStack{
            VStack{
                Picker(selection: $selectedPortionsize, label: Text("")){
                    ForEach(Array(stride(from:10, through: 2000, by: 10)), id: \.self){i in
                        Text("\(i)ml")
                            .frame(width: 100, height: 50)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 175, height: 300)
                .cornerRadius(10.0)
                .padding(.horizontal, 5)
            }
            Divider().frame(maxHeight: 200)
            VStack {
                ForEach(beverage.portionsizes, id: \.self){portionsize in
                    Button {
                        selectedPortionsize = portionsize
                    }label:{
                        PortionsizeButton(portionsize: portionsize)
                            .padding(.all, 5)
                    }
                }
            }
        }
    }
}

//struct PickerLabelView: View {
//    var body: some View {
//        Text("Portionsizes")
//            .frame(width: 175, height: 40)
//            .foregroundColor(Color(.lightGray))
//    }
//}


