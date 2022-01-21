//
//  Workout.swift
//  personal_tracker (iOS)
//
//  Created by Bastian Radloff on 30.03.21.
//

import SwiftUI
import HealthKit
import MapKit
import PartialSheet

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LinearGradient(gradient: Gradient(colors: [Color.red, Color.yellow, Color.green]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.vertical)
    }
}

struct DistanceWorkoutView : View {
    let workout: HKWorkout
    @Binding var hkManager: HKManager
    let imageString: String
    
    let dateFormatterDay : DateFormatter = getDateFormatter(format: "EEEE dd.MM.yy")
    let dateFormatterTime : DateFormatter = getDateFormatter(format: "HH:mm")
    
    @State var startPointRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 53, longitude: 9),
                                               span: MKCoordinateSpan(latitudeDelta: 15, longitudeDelta: 15))
    @State var points: Array<Location> = []
    @State var setStartPoint: Bool = false
    @State var geocodeReversed: Bool = false
    @State var startPointString: String = "Location"
    
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                WorkoutTitleView(workout: workout,
                                 imageString: imageString,
                                 startPointString: $startPointString)
                    .frame(width: geometry.size.width, height: 0.2 * geometry.size.height)
                    
                Divider()
                    .padding(.horizontal, 10)
                    .foregroundColor(Color(.lightGray))
                
                PacesView(paces: getPacePerKM(workout: workout))
                
                Divider()
                    .padding(.horizontal, 10)
                    .foregroundColor(Color(.lightGray))
                
                KeyMetricsView(workout: workout)
                
                Divider()
                    .padding(.horizontal, 10)
                    .foregroundColor(Color(.lightGray))
                
                SmallMapView(hkManager: $hkManager,
                             workout: workout,
                             startPointRegion: $startPointRegion,
                             points: $points)
            }
            .navigationBarTitle(workout.workoutActivityType == .running ? "Run Summary" :
                                    workout.workoutActivityType == .cycling ? "Cycle Summary" : "Walk Summary")
        }
        .onAppear{
            self.getWorkoutLocations(hkManager: hkManager,
                                     workout: workout)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                self.reverseGeocodeLocation(location: CLLocation(latitude: self.startPointRegion.center.latitude,
                                                                 longitude: self.startPointRegion.center.longitude))
            }
        }
    }
    
    private func reverseGeocodeLocation(location: CLLocation){
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location){ (placemarks, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            
            if let placemarks = placemarks {
                print("City: \(placemarks.first!.locality!)")
                self.startPointString = placemarks.first!.locality!
                self.geocodeReversed = true
            }
        }
    }
    
    private func getWorkoutLocations(hkManager: HKManager, workout: HKWorkout){
        let modulo: Int = 7
        
        hkManager.getWorkoutRoute(workout: workout, completion: {samples in
            if let routes = samples {
                if let route = routes.first{
                    let route_ = route as! HKWorkoutRoute
                    hkManager.queryWorkoutRoute(route: route_, completion:{locations in
                        if let locations = locations {
                            withAnimation(.easeInOut(duration: 0.1)){
                                if locations.count == 100 {
                                    if !self.setStartPoint{
                                        self.points.append(Location(location: locations.first!, color: Color.green, type: .start))
                                        for index in 1 ..< locations.count {
                                            if index % modulo == 0 {
                                                self.points.append(Location(location: locations[index], color: Color("BrightOrange")))
                                            }
                                        }
                                        self.setStartPoint.toggle()
                                    } else {
                                        for index in 0 ..< locations.count {
                                            if index % modulo == 0 {
                                                self.points.append(Location(location: locations[index], color: Color("BrightOrange")))
                                            }
                                        }
                                    }
                                } else {
                                    for index in 0 ..< locations.count {
                                        
                                        if locations.count>=4 && index % Int(locations.count/4) == 0 {
                                            self.points.append(Location(location: locations[index], color: Color("BrightOrange")))
                                        }
                                    }
                                    self.points.append(Location(location: locations.last!, color: Color.red, type: .end))
                                }
                                
                                
                                self.startPointRegion.center = getCenter(coordinates: self.points.map{$0.location.coordinate})
                                self.startPointRegion.span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                            }
                        }
                    })
                }
            }
        })
    }
}

func getCenter(coordinates: Array<CLLocationCoordinate2D>) -> CLLocationCoordinate2D {
    let numberCoordinates = Double(coordinates.count)
    let sumLatitude = coordinates.map{$0.latitude}.reduce(0.0){(sum, latitude) in
        return sum + latitude
    }
    let sumLongitude = coordinates.map{$0.longitude}.reduce(0.0){(sum, longitude) in
        return sum + longitude
    }
    
    return CLLocationCoordinate2D(latitude: sumLatitude/numberCoordinates,
                                  longitude: sumLongitude/numberCoordinates)
}


struct PacesView : View {
    
    let paces: Array<Double>
    let textSize: CGFloat = 17
    
    var body: some View {
        BarplotTitleView(title: "Paces")
        ScrollView {
            VStack{
                ForEach(0 ..< paces.count, id: \.self){km in
                    HStack{
                        Text("Kilometer \(km+1)")
                            .foregroundColor(Color("TextColor"))
                            .font(.system(size: textSize, weight: .light))
                        Spacer()
                        Text(timeDoubleToString(time: paces[km]))
                            .foregroundColor(Color("TextColor"))
                            .font(.system(size: textSize, weight: .bold))
                        Text("min")
                            .foregroundColor(Color(.lightGray))
                            .font(.system(size: textSize, weight: .light))
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 20)
                }
            }
        }
    }
}


struct KeyMetricsView : View {
    let workout: HKWorkout
    
    var body: some View {
        HStack{
            SingleMetricView(title: "Duration",
                              valueString: timeDoubleToString(time: workout.duration/60),
                              unitString: timeDoubleToString(time: workout.duration/60).count > 5 ? "Std." : "Min")
            
            SingleMetricView(title: "Distance",
                              valueString: String(format: "%.2f", workout.totalDistance!.doubleValue(for: HKUnit(from: "km"))),
                              unitString: "km")
            SingleMetricView(title: "Pace",
                             valueString: getPace(workout: workout),
                              unitString: "/km")
        }
        .frame(maxWidth: .infinity, maxHeight: 70)
        .padding(.vertical, 5)
        
        HStack{
            SingleMetricView(title: "Calories",
                              valueString: String(format: "%.0f", workout.totalEnergyBurned!.doubleValue(for: HKUnit(from: "kcal"))),
                              unitString: "kcal")
            SingleMetricView(title: "Elevation",
                              valueString: String(format: "%.0f", getElevationMeter(workout: workout)),
                              unitString: "m")
            SingleMetricView(title: "Temperature",
                              valueString: String(format: "%.1f", getTemperatureCelcius(workout: workout)),
                              unitString: "°C")
//                SingleMetricView(title: "Humidity",
//                                  valueString: String(format: "%.0f", getHumidity(workout: workout)),
//                                  unitString: "%")
        }
        .frame(maxWidth: .infinity, maxHeight: 70)
        .padding(.vertical, 5)
    }
}


func getPacePerKM(workout: HKWorkout) -> Array<Double> {
    let events: [HKWorkoutEvent] = workout.workoutEvents ?? []
    var paces: Array<Double> = []
    var distanceOverlapAfterLastEvent: Double = 0.0
    var durationOverlapAfterLastEvent: Double = 0.0
    var durationAfterLastEvent: Double = 0.0
    var distanceAfterLastEvent: Double = 0.0

    for event in events{
        if event.type.rawValue == 7 {
            if let metadata = event.metadata {
                if metadata["_HKPrivateMetadataSplitMeasuringSystem"] as! NSNumber == 1 {
                    let eventDistance = metadata["_HKPrivateMetadataSplitDistanceQuantity"] as! HKQuantity
                    let eventDuration = metadata["_HKPrivateMetadataSplitActiveDurationQuantity"] as! HKQuantity
                    
                    let eventDistanceMeters = eventDistance.doubleValue(for: HKUnit(from: "m"))
                    let eventDurationSeconds = eventDuration.doubleValue(for: HKUnit(from: "s"))
                    
                    let speedInverted = eventDurationSeconds/eventDistanceMeters
                    let overlapTime = speedInverted*(eventDistanceMeters-1000)
                    
                    durationOverlapAfterLastEvent += overlapTime
                    distanceOverlapAfterLastEvent += (eventDistanceMeters-1000)
                    
                    durationAfterLastEvent += (eventDurationSeconds-overlapTime)
                    distanceAfterLastEvent += 1000
                    
                    paces.append((eventDurationSeconds-overlapTime)/60)
                }
            } else {
                print("Did not cast metadata!")
            }
        }
    }
    
    let leftDistance = workout.totalDistance!.doubleValue(for: HKUnit(from: "m")) - distanceAfterLastEvent +  distanceOverlapAfterLastEvent
    if leftDistance >= 1000{
        let leftTime = workout.duration - durationAfterLastEvent + durationOverlapAfterLastEvent
        let speedInverted = leftTime/leftDistance
        let overlapTime = speedInverted*(leftDistance-1000)
        paces.append((leftTime-overlapTime)/60)
    } else if leftDistance >= 100 {
        let leftTime = workout.duration - durationAfterLastEvent + durationOverlapAfterLastEvent
        let pace = (1000/leftDistance) * leftTime
//        let overlapTime = speedInverted*(leftDistance-1000)
        paces.append(pace/60)
    }
    
    return paces
}


func getPace(workout: HKWorkout) -> String {
    let durationMin = workout.duration/60
    let distanceKM = workout.totalDistance!.doubleValue(for: HKUnit(from: "km"))
    
    return timeDoubleToString(time: durationMin/distanceKM)
}


func getElevationMeter(workout: HKWorkout) -> Double {
    if let metadata = workout.metadata {
        if let elevation = metadata["HKElevationAscended"] {
            let elevationCast = elevation as! HKQuantity
            return elevationCast.doubleValue(for: HKUnit(from: "m"))
        } else {
            return 0
        }
    } else {
        return 0
    }
}

func getHumidity(workout: HKWorkout) -> Double {
    if let metadata = workout.metadata {
        let humidity = metadata["HKWeatherHumidity"] as! HKQuantity
        return humidity.doubleValue(for: HKUnit(from: "%"))
    } else {
        return 0
    }
}
