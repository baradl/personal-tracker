//
//  MovementHistory.swift
//  personal_tracker (iOS)
//
//  Created by Bastian Radloff on 21.08.21.
//

import SwiftUI
import HealthKit

struct MovementHistoryView: View {
    @Binding var hkManager: HKManager
    @ObservedObject var dataModel : DataModel
    
    @State private var monthIndex = 0
    let kmUnit = "km"
    let format = "%.1f"
    var body: some View {
        GeometryReader {geometry in
            VStack{
                HStack{
                    SingleMetricView(title: "Walking Average", valueString: String(format: format, dataModel.workoutData.walkingDistanceMonths.reduce(0.0){(sum, distance) in
                    return sum + distance.1
                    }/Double(dataModel.workoutData.walkingDistanceMonths.count)), unitString: kmUnit)
                    SingleMetricView(title: "Biking Average", valueString: String(format: format, dataModel.workoutData.bikingDistanceMonths.reduce(0.0){(sum, distance) in
                    return sum + distance.1
                    }/Double(dataModel.workoutData.bikingDistanceMonths.count)), unitString: kmUnit)
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 0.08)
                .padding(.vertical, 10)
                Divider()
                
                MovementView(workoutData: dataModel.workoutData,
                             hkManager: $hkManager,
                             monthIndex: $monthIndex)
                    .frame(width: geometry.size.width,
                           height: geometry.size.height * 0.35)
                
                Divider()
                BarplotTitleView(title: "Walking")
                BarplotView(data: dataModel.workoutData.walkingDistanceMonths, color: Color("BaseBlue"))
                BarplotTitleView(title: "Biking")
                BarplotView(data: dataModel.workoutData.bikingDistanceMonths, color: Color("BaseGreen"))
            }.navigationBarTitle("Movement History")
        }
    }
}

struct MovementView : View {
    var workoutData: WorkoutData
    @Binding var hkManager: HKManager
    @Binding var monthIndex: Int
    
    let dateFormatter: DateFormatter = getDateFormatter(format: "MMMM yyyy")
    
    var body: some View {
        VStack{
            HStack{
                BarplotTitleView(title: dateFormatter.string(from: workoutData.getWorkouts(index: monthIndex).last?.startDate ?? Date()))
                Menu(content: {
                    ForEach(0 ..< workoutData.workoutsPerMonth.count, id: \.self){index in
                        let workoutsMonth = workoutData.getWorkouts(index: index)
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
                    ForEach(workoutData.getMovementWorkouts(index: monthIndex), id: \.self){workout in
                        switch workout.workoutActivityType {
                        case .walking:
                            NavigationLink(destination: DistanceWorkoutView(workout: workout,
                                                                           hkManager: $hkManager,
                                                                           imageString: "walk"),
                                           label: {
                                            WorkoutCardView(workout: workout,
                                                            imageString: "walk",
                                                            value: String(format: "%.2f", workout.totalDistance?.doubleValue(for: HKUnit(from: "km")) ?? 0),
                                                            unit: "km")
                                           })
                        case .cycling:
                            NavigationLink(destination: DistanceWorkoutView(workout: workout,
                                                                           hkManager: $hkManager,
                                                                           imageString: "bicycle"),
                                           label: {
                                            WorkoutCardView(workout: workout,
                                                            imageString: "bicycle",
                                                            value: String(format: "%.2f", workout.totalDistance?.doubleValue(for: HKUnit(from: "km")) ?? 0),
                                                            unit: "km")
                                           })
                        default:
                            Text("Workout Type not recognized by Application! \(workout.workoutActivityType.rawValue)")
                        }
                    }
                }
            }
        }
    }
}
