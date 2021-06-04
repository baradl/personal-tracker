//
//  Gestures.swift
//  personal_tracker (iOS)
//
//  Created by Bastian Radloff on 30.03.21.
//

import SwiftUI

//DRAG LEFT GESTURE FOR NAVIGATION

//@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
//let navigatBackDragGesture = DragGesture(minimumDistance: 25, coordinateSpace: .local)
//                                .onEnded { value in
//                                    if abs(value.translation.height) < abs(value.translation.width) {
//                                        if abs(value.translation.width) > 50.0 && value.translation.width > 0{
//                                            print("GO BACK")
//                                            withAnimation(.easeInOut){
//                                                sheetManager.closePartialSheet()
//                                            }
//                                            presentationMode.wrappedValue.dismiss()
//                                        }
//                                    }
//                                }
//func navigateBackGesture(perform: (() -> Void)){
//    DragGesture(minimumDistance: 25, coordinateSpace: .local).onEnded { value in
//                    if abs(value.translation.height) < abs(value.translation.width) {
//                        if abs(value.translation.width) > 50.0 && value.translation.width > 0{
//                            print("GO BACK")
//                            perform()
//                        }
//                    }
//                }
//}


// DRAG DOWN GESTURE FOR REFRESH

//            .gesture(DragGesture(minimumDistance: 25, coordinateSpace: .local)
//                        .onChanged{value in
//                            if abs(value.translation.height) > abs(value.translation.width) {
//                                offsetValue = value.translation.height
//                            }
//                        }
//                        .onEnded{value in
//                            withAnimation(.linear){
//                                offsetValue = 0
//                            }
//                            if abs(value.translation.height) > abs(value.translation.width) {
//                                if abs(value.translation.height) > 50.0 && value.translation.height > 0{
//                                    print("Update")
//                                    updateUI(dataModel: dataModel, hkManager: hkManager)
//                                    updateActivitySummary(hkManager: hkManager, dataModel: dataModel, timeframe: "today")
//                                }
//                            }
//                        }
//            )
