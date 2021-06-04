//
//  RunningHistory.swift
//  personal_tracker (iOS)
//
//  Created by Bastian Radloff on 26.03.21.
//

import SwiftUI
import HealthKit
import CoreLocation
import MapKit



struct RunningHistoryView : View {
    @ObservedObject var dataModel : DataModel
    @Binding var hkManager: HKManager
    
    @State private var monthIndex = 0
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                HStack{
                    SingleMetricView(title: "Distance",
                                     valueString: String(format: "%.2f", dataModel.workoutData.getRunningDistance(index: monthIndex)),
                                     unitString: "km")
                    SingleMetricView(title: "Runs",
                                     valueString: String(dataModel.workoutData.getRunningWorkouts(index: monthIndex).count),
                                      unitString: "")
                    
                    SingleMetricView(title: "Pace",
                                     valueString: dataModel.workoutData.getPace(index: monthIndex),
                                      unitString: "/km")
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 0.08)
                .padding(.vertical, 10)
                
                Divider().padding(.horizontal, 10)
                
                RunsView(workoutData: dataModel.workoutData,
                         hkManager: $hkManager,
                         monthIndex: $monthIndex)
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.35)
                
                Divider().padding(.horizontal, 10)
                
                BarplotTitleView(title: "Weeks")
                BarplotView(data: dataModel.workoutData.runningDistanceWeeks, color: Color("LightRed"))
                
                BarplotTitleView(title: "Months")
                BarplotView(data: dataModel.workoutData.runningDistanceMonths, color: Color("LightRed"))
            }
            .navigationBarTitle("Running History")
            .onAppear{
                updateWorkouts(dataModel: dataModel, hkManager: hkManager)
            }
        }
    }
}


struct RunsView : View {
    var workoutData: WorkoutData
    @Binding var hkManager: HKManager
    @Binding var monthIndex: Int
    
    let dateFormatter: DateFormatter = getDateFormatter(format: "MMMM yyyy")
    
    var body: some View {
        VStack{
            HStack{
                BarplotTitleView(title: dateFormatter.string(from: workoutData.getRunningWorkouts(index: monthIndex).last?.startDate ?? Date()))
                Menu(content: {
                    ForEach(0 ..< workoutData.workoutsPerMonth.count, id: \.self){index in
                        let workoutsMonth = workoutData.getRunningWorkouts(index: index)
                        if !workoutsMonth.isEmpty{
                            Button{
                                monthIndex = index
                            }label: {
                                Text(dateFormatter.string(from: workoutsMonth.last!.startDate))
                            }
                        } else if index == 0 {
                            Button{
                                monthIndex = index
                            }label: {
                                Text(dateFormatter.string(from: Date()))
                            }
                        }
                    }
                }, label: {
                    Image(systemName: "line.horizontal.3.circle")
                        .resizable()
                        .foregroundColor(Color(.lightGray))
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .padding(.trailing, 20)
                })
            }
            
            ScrollView{
                VStack{
                    ForEach(workoutData.getRunningWorkouts(index: monthIndex), id: \.self){workout in
                        NavigationLink(destination: DistanceWorkoutView(workout: workout,
                                                                       hkManager: $hkManager,
                                                                       imageString: "running"),
                                       label: {
                                        WorkoutCardView(workout: workout,
                                                        imageString: "running",
                                                        value: String(format: "%.2f", workout.totalDistance!.doubleValue(for: HKUnit(from: "km"))),
                                                        unit: "km")
                                       })
                    }
                }
            }
        }
    }
}

