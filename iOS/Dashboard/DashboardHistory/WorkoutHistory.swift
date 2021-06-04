//
//  WorkoutHistory.swift
//  personal_tracker (iOS)
//
//  Created by Bastian Radloff on 26.03.21.
//

import SwiftUI
import HealthKit

struct WorkoutHistoryView : View {
    @ObservedObject var dataModel : DataModel
    @Binding var hkManager: HKManager
    
    @State private var monthIndex = 0
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                HStack{
                    SingleMetricView(title: "Strength",
                                     valueString: String(dataModel.workoutData.getNumberWorkoutTypes(index: monthIndex).strength),
                                      unitString: "")
                    SingleMetricView(title: "Runs",
                                     valueString: String(dataModel.workoutData.getNumberWorkoutTypes(index: monthIndex).runs),
                                      unitString: "")
                    SingleMetricView(title: "Cardio",
                                     valueString: String(dataModel.workoutData.getNumberWorkoutTypes(index: monthIndex).cardio),
                                      unitString: "")
                    SingleMetricView(title: "Long Walks",
                                     valueString: String(dataModel.workoutData.getNumberWorkoutTypes(index: monthIndex).walks),
                                      unitString: "")
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 0.08)
                .padding(.vertical, 10)
                
                Divider()
                
                WorkoutsView(workoutData: dataModel.workoutData,
                             hkManager: $hkManager,
                             monthIndex: $monthIndex)
                    .frame(width: geometry.size.width,
                           height: geometry.size.height * 0.35)
                
                Divider()
                BarplotTitleView(title: "Weeks")
                BarplotView(data: dataModel.workoutData.numberWorkoutsPerWeek,
                            color: Color("BaseRed"))
                
                BarplotTitleView(title: "Months")
                BarplotView(data: dataModel.workoutData.numberWorkoutsPerMonth,
                            color: Color("BaseRed"))
            }
            .navigationBarTitle("Workout History")
            .onAppear{
                updateWorkouts(dataModel: dataModel, hkManager: hkManager)
            }
        }
    }
}

struct NumberWorkoutsView : View {
    let title: String
    let number: Int
    
    var body: some View {
//        GeometryReader{ geometry in
//
//        }
        VStack{
            Text(title)
                .font(.system(size: 16, weight: .light))
                .foregroundColor(Color("TextColor"))
            Text(String(number))
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color("TextColor"))
        }
        .frame(width: 90, height: 65)
        .background(ComponentBackgroundColor())
        .cornerRadius(10.0)
        .padding(.top, 10)
        .padding(.vertical, 5)
    }
}


struct WorkoutCardView:View {
    let workout : HKWorkout
    
    let imageString: String
    let value: String
    let unit: String
    
    let dateFormatter : DateFormatter = getDateFormatter(format: "EEEE dd.MM.yy")
    
    var body: some View{
        HStack(alignment: .bottom){
            WorkoutImage(imageString: imageString, size: 50)
                .padding(.horizontal, 10)
            Spacer()
            Text(value)
                .font(.system(size: 25, weight: .bold))
                .foregroundColor(Color("TextColor"))
            Text(unit)
                .font(.system(size: 20, weight: .light))
                .foregroundColor(Color(.lightGray))
            Spacer()
            Text(dateFormatter.string(from: workout.startDate))
                .font(.system(size: 14, weight: .light))
                .foregroundColor(Color(.lightGray))
                .padding(.horizontal, 10)
        }
        .frame(width: 390, height: 60)
        .background(ComponentBackgroundColor())
        .cornerRadius(10.0)
        .padding(.vertical, 2)
        .padding(.horizontal, 10)
    }
}

struct WorkoutsView : View {
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
                    ForEach(workoutData.getWorkouts(index: monthIndex), id: \.self){workout in
                        switch workout.workoutActivityType {
                        case .functionalStrengthTraining:
                            NavigationLink(destination: StationaryWorkoutView(workout: workout,
                                                                           hkManager: $hkManager,
                                                                           imageString: "barbell"),
                                           label: {
                                            WorkoutCardView(workout: workout,
                                                            imageString: "barbell",
                                                            value: String(format: "%.0f", workout.totalEnergyBurned!.doubleValue(for: HKUnit(from: "kcal"))),
                                                            unit: "kcal")
                                           })
                        case .mixedCardio:
                            NavigationLink(destination: StationaryWorkoutView(workout: workout,
                                                                           hkManager: $hkManager,
                                                                           imageString: "jumping-rope"),
                                           label: {
                                            WorkoutCardView(workout: workout,
                                                            imageString: "jumping-rope",
                                                            value: String(format: "%.0f", workout.totalEnergyBurned!.doubleValue(for: HKUnit(from: "kcal"))),
                                                            unit: "kcal")
                                           })
                        case .running:
                            NavigationLink(destination: DistanceWorkoutView(workout: workout,
                                                                           hkManager: $hkManager,
                                                                           imageString: "running"),
                                           label: {
                                            WorkoutCardView(workout: workout,
                                                            imageString: "running",
                                                            value: String(format: "%.2f", workout.totalDistance!.doubleValue(for: HKUnit(from: "km"))),
                                                            unit: "km")
                                           })
                        case .walking:
                            NavigationLink(destination: DistanceWorkoutView(workout: workout,
                                                                           hkManager: $hkManager,
                                                                           imageString: "walk"),
                                           label: {
                                            WorkoutCardView(workout: workout,
                                                            imageString: "walk",
                                                            value: String(format: "%.2f", workout.totalDistance!.doubleValue(for: HKUnit(from: "km"))),
                                                            unit: "km")
                                           })
                        case .cycling:
                            NavigationLink(destination: DistanceWorkoutView(workout: workout,
                                                                           hkManager: $hkManager,
                                                                           imageString: "bicycle"),
                                           label: {
                                            WorkoutCardView(workout: workout,
                                                            imageString: "bicycle",
                                                            value: String(format: "%.2f", workout.totalDistance!.doubleValue(for: HKUnit(from: "km"))),
                                                            unit: "km")
                                           })
                        default:
                            fatalError("Workout Type not recognized by Application! \(workout.workoutActivityType)")
                        }
                    }
                }
            }
        }
    }
}
