//
//  Workout.swift
//  personal_tracker (iOS)
//
//  Created by Bastian Radloff on 31.03.21.
//

import SwiftUI
import HealthKit
import MapKit

struct StationaryWorkoutView : View {
    let workout : HKWorkout
    @Binding var hkManager : HKManager
    let imageString: String
    
    @State var startPointRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 53, longitude: 9),
                                               span: MKCoordinateSpan(latitudeDelta: 15, longitudeDelta: 15))
    @State var points: Array<Location> = []
    @State var setStartPoint: Bool = false
    @State var startPointString: String = "Location"
    
    var body: some View {
        GeometryReader {geometry in
            let _ = print(workout)
            VStack{
                WorkoutTitleView(workout: workout,
                                 imageString: imageString,
                                 startPointString: $startPointString)
                    .frame(width: geometry.size.width, height: 0.2 * geometry.size.height)
                    
                Divider()
                    .padding(.horizontal, 10)
                    .foregroundColor(Color(.lightGray))
                HStack{
                    SingleMetricView(title: "Duration",
                                      valueString: timeDoubleToString(time: workout.duration/60),
                                      unitString: timeDoubleToString(time: workout.duration/60).count > 5 ? "Std." : "Min")
                    SingleMetricView(title: "Calories",
                                      valueString: String(format: "%.0f", workout.totalEnergyBurned!.doubleValue(for: HKUnit(from: "kcal"))),
                                      unitString: "kcal")
                    SingleMetricView(title: "Temperature",
                                      valueString: String(format: "%.1f", getTemperatureCelcius(workout: workout)),
                                      unitString: "°C")
                    
                }
                .frame(maxWidth: .infinity, maxHeight: 70)
                .padding(.vertical, 10)
                
                Divider()
                    .padding(.horizontal, 10)
                    .foregroundColor(Color(.lightGray))
                
                SmallMapView(hkManager: $hkManager,
                             workout: workout,
                             startPointRegion: $startPointRegion,
                             points: $points)
                
                Rectangle()
                    .fill(Color("BackgroundColor"))
                    .frame(width: geometry.size.width, height: 0.3 * geometry.size.height)
            }
            .navigationBarTitle("Workout Summary")
        }
    }
}

struct WorkoutTitleView : View {
    let workout: HKWorkout
    let imageString: String
    @Binding var startPointString: String
    
    let dateFormatterDay : DateFormatter = getDateFormatter(format: "EEEE dd.MM.yy")
    let dateFormatterTime : DateFormatter = getDateFormatter(format: "HH:mm")
    
    var body: some View {
        GeometryReader{geometry in
            HStack{
                WorkoutImage(imageString: imageString, size: 120)
                .frame(width: geometry.size.width * 0.4,
                       height: geometry.size.height)
                Spacer()
                VStack{
                    Text(dateFormatterDay.string(from: workout.startDate))
                        .font(.system(size: 20, weight: .bold))
                    Text("\(dateFormatterTime.string(from: workout.startDate)) - \(dateFormatterTime.string(from: workout.startDate + workout.duration))")
                        .font(.system(size: 15, weight: .light))
                        .padding(.bottom, 6)
                    Text(startPointString)
                        .font(.system(size: 15, weight: .light))
                        .padding(.bottom, 6)
                }
                .frame(width: geometry.size.width * 0.6,
                       height: geometry.size.height)
            }
        }.padding()
    }
}

func getTemperatureCelcius(workout: HKWorkout) -> Double {
    if let metadata = workout.metadata {
        if let temperature = metadata["HKWeatherTemperature"] {
            let temperature_ = temperature as! HKQuantity
            return temperature_.doubleValue(for: HKUnit(from: "degC"))
        } else {
            return Double.nan
        }
        
    } else {
        return 0
    }
}
