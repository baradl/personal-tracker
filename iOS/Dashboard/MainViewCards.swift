//
//  MainViewCars.swift
//  personal_tracker (iOS)
//
//  Created by Bastian Radloff on 06.08.21.
//
import SwiftUI

struct TrackerViewCard: View {
    @Binding var hkManager: HKManager
    @ObservedObject var dataModel: DataModel
    var todaysBeverages: UserDefaults
    var dateFormatter = getDateFormatter(format: "dd.MM.yy")

    var body: some View {
        GeometryReader{ geometry in
            ZStack{
                let currentWeight = dataModel.currentWeight ?? Weight(weight: 0.0, timestamp: Date())
                HStack{
                    NavigationLink(
                        destination: WeightTrackerView(hkManager: $hkManager, dataModel: dataModel),
                        label: {
                            VStack(alignment: .leading, spacing: 30){
                                
                                HStack(alignment: .center){
                                    Image("body-scale")
                                        .renderingMode(.original)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 30)
                                    Text("Bodyweight")
                                        .font(.headline)
                                        .foregroundColor(Color(.white))
                                }
                                HStack(alignment: .bottom){
                                    MetricView(name: dateFormatter.string(from: currentWeight.timestamp), value: currentWeight.weight, color: Color("LightRed"), unit: "kg", format: "%.1f")
                                }
                            }
                        })
                    NavigationLink(
                        destination: WaterTrackerView(hkManager: $hkManager, dataModel: dataModel, todaysBeverages: todaysBeverages),
                        label: {
                            VStack(alignment: .trailing, spacing: 30){
                                HStack(alignment: .center){
                                    Image("drop")
                                        .renderingMode(.original)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 30)
                                    Text("Water & Caffeine")
                                        .font(.headline)
                                        .foregroundColor(Color(.white))
                                }
                                HStack(alignment: .bottom){
                                    MetricView(name: "water", value: dataModel.dailySumData.today.water, color: Color("WaterColor"), unit: "ml")
                                    Spacer()
                                    MetricView(name: "Caffeine", value: dataModel.dailySumData.today.caffeine, color: Color("CaffeineColor"), unit: "mg")
                                }
                            }
                        })
                }
                .padding(.horizontal, 20)
                .frame(width: geometry.size.width, height: geometry.size.height)
                .background(ComponentBackgroundColor())
                .cornerRadius(8)
            }
        }
    }
}

struct CalorieMainViewCard:  View {
    @Binding var hkManager: HKManager
    @ObservedObject var dataModel: DataModel
    var body: some View {
        GeometryReader{ geometry in
            ZStack{
                VStack(alignment: .leading, spacing: 20){
                    MetricGroupTitleView(imageString: "flame", title: "Calories")
                    HStack(alignment: .bottom){
                        MetricView(name: "basal", value: dataModel.dailySumData.today.basalEnergy, color: Color("BrightOrange"), unit: "kcal")
                        
                        Spacer()
                        MetricView(name: "active", value: dataModel.dailySumData.today.activeEnergy, color: Color("BrightOrange"), unit: "kcal")
                        Spacer()
                        MetricView(name: "total", value: dataModel.dailySumData.today.basalEnergy + dataModel.dailySumData.today.activeEnergy, color: Color("BrightOrange"), unit: "kcal")
                        
                    }
                }
                .padding(.horizontal, 20)
                .frame(width: geometry.size.width, height: geometry.size.height)
                .background(ComponentBackgroundColor())
                .cornerRadius(8)
            }
        }
    }
}

struct WorkoutsCardView : View {
    @Binding var hkManager: HKManager
    @ObservedObject var dataModel: DataModel
    var body: some View {
        GeometryReader{ geometry in
            ZStack{
                VStack(alignment: .leading, spacing: 10){
                    MetricGroupTitleView(imageString: "barbell", title: "Workouts")
                    HStack(alignment: .bottom){
                        MetricView(name: "strength", value: Double(dataModel.workoutData.getNumberWorkoutTypes(index: 0).strength), color: Color("BaseRed"), unit: "")
                        Spacer()
                        MetricView(name: "runs", value: Double(dataModel.workoutData.getNumberWorkoutTypes(index: 0).runs), color: Color("BaseRed"), unit: "")
                        Spacer()
                        MetricView(name: "running", value: dataModel.workoutData.runningDistanceThisMonth, color: Color("BaseRed"), unit: "km", format: "%.1f")
                        Spacer()
                        MetricView(name: "cardio", value: Double(dataModel.workoutData.getNumberWorkoutTypes(index: 0).cardio), color: Color("BaseRed"), unit: "")
                        
                    }
                }
                .padding(.horizontal, 20)
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .background(ComponentBackgroundColor())
                .cornerRadius(8)
            }
        }
    }
}

struct MovementMainViewCard:  View {
    @Binding var hkManager: HKManager
    @ObservedObject var dataModel: DataModel
    var body: some View {
        GeometryReader{ geometry in
            ZStack{
                VStack(alignment: .leading, spacing: 10){
                    MetricGroupTitleView(imageString: "footstep", title: "Movement")
                    HStack(alignment: .bottom){
                        NavigationLink(destination:
                                        DailySumHistoryView(metricName: "Steps", metricColor: Color("BaseBlue"), metricUnit: "", maxString: String(format: "%.0f", dataModel.dailySumData.historyMetrics.steps.max), avgString: String(format: "%.0f", dataModel.dailySumData.historyMetrics.steps.avg), days: dataModel.dailySumData.days.steps, weeks: dataModel.dailySumData.weeks.steps, months: dataModel.dailySumData.months.steps),
                                       label: {
                                        MetricView(name: "steps", value: dataModel.dailySumData.today.steps, color: Color("BaseBlue"), unit: "")
                                       })
                        Spacer()
                        NavigationLink(destination: MovementHistoryView(hkManager: $hkManager, dataModel: dataModel),
                                       label: {
                                        MetricView(name: "walking", value: dataModel.workoutData.walkingDistanceThisMonth, color: Color("BaseGreen"), unit: "km", format: "%.1f")
                                        })
                        Spacer()
                        NavigationLink(destination: MovementHistoryView(hkManager: $hkManager, dataModel: dataModel),
                                       label: {
                                        MetricView(name: "biking", value: dataModel.workoutData.bikingDistanceThisMonth, color: Color("BaseGreen"), unit: "km", format: "%.1f")})
                        Spacer()
                        NavigationLink(destination:
                                        FlexibilityHistoryView(flexibilityWorkouts: dataModel.workoutData.getAllFlexibilityWorkouts()),
                                       label: {
                                        MetricView(name: "flex", value: Double(dataModel.workoutData.getFlexibilityWorkouts(index: 0).count), color: Color("LightRed"), unit: "", format: "%.0f")
                                       })
                    }
                }
                .padding(.horizontal, 20)
                .frame(width: geometry.size.width, height: geometry.size.height)
                .background(ComponentBackgroundColor())
                .cornerRadius(8)
            }
        }
    }
}




struct MetricGroupTitleView: View {
    let imageString: String
    let title: String
    var body: some View {
        HStack(alignment: .center){
            Image(imageString)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
            Text(title)
                .font(.headline)
                .foregroundColor(Color(.white))
                .padding(.leading, 30)
        }
    }
}
struct MetricView: View {
    let name: String
    let value: Double
    let color: Color
    let unit: String
    var format: String?
    
    var body: some View{
        VStack(alignment: .leading){
            Text(name)
                .font(.callout)
                .foregroundColor(Color("TextColor"))
            HStack{
                Text(String(format:format ?? "%.0f", value))
                    .font(Font.body.weight(.bold))
                    .foregroundColor(color)
                Text(unit)
                    .font(.callout)
                    .foregroundColor(Color(.lightGray))
            }
        }
    }
}
