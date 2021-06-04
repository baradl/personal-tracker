//
//  WorkoutLocation.swift
//  personal_tracker (iOS)
//
//  Created by Bastian Radloff on 31.03.21.
//

import SwiftUI
import MapKit
import CoreLocation
import HealthKit
import PartialSheet

struct SmallMapView : View {
    @Binding var hkManager: HKManager
    let workout: HKWorkout
    
    @Binding var startPointRegion: MKCoordinateRegion
    @Binding var points: Array<Location>
    @State var showLargeMap: Bool = false
//    @Binding var locations: [Location]
    
    var body: some View {
        GeometryReader { geometry in
            NavigationLink(
                destination: LargeMapView(startPoint: $startPointRegion, points: $points),
                label: {
                    Map(coordinateRegion: $startPointRegion)
                        .frame(width: geometry.size.width,
                               height: geometry.size.height)
                        .cornerRadius(20)
                })
//            VStack{
//                Button{
//                    showLargeMap.toggle()
//                }label: {
//                        Map(coordinateRegion: $startPointRegion)
//                            .frame(width: geometry.size.width,
//                                   height: geometry.size.height)
//                            .cornerRadius(20)
//                  }
//            }.fullScreenCover(isPresented: $showLargeMap, content: {
//                LargeMapView(startPoint: $startPointRegion,
//                                                         points: $points)
//            })
        }.padding(.all, 5)
    }
}

struct LargeMapView : View {
    @Binding var startPoint : MKCoordinateRegion
    @Binding var points: [Location]
    var body: some View {
        let speeds: Array<Double> = points.map{point in
            return point.location.speed
        }
        
        let averageSpeed = speeds.reduce(0.0){(sum, speed) in
            return sum + speed
        }/Double(speeds.count)
        let minSpeed = speeds.min()!
        let maxSpeed = speeds.max()!
        
        Map(coordinateRegion: $startPoint, annotationItems: points){point in
            MapAnnotation(coordinate: point.location.coordinate,
                          anchorPoint: CGPoint(x: 0.05, y: 0.05),
                          content: {MapViewAnnotation(point: point,
                                                      averageSpeed: averageSpeed,
                                                      minSpeed: minSpeed,
                                                      maxSpeed: maxSpeed)})
        }
    }
}


struct MapViewAnnotation : View {
    let point: Location
    let averageSpeed: Double
    let minSpeed: Double
    let maxSpeed: Double
    
    let sizeWaypoint: CGFloat = 5
    let sizePin: CGFloat = 20
    
    var body: some View {
        ZStack{
            if point.type == .start {
                Image(systemName: "mappin.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color.green)
                    .background(Circle()
                                    .fill(Color.white)
                                    .frame(width: sizePin, height: sizePin))
                    .frame(width: sizePin,
                           height: sizePin)
                    .offset(y: -sizePin * 0.5)
            } else if point.type == .end {
                Image(systemName: "mappin.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color.red)
                    .background(Circle()
                                    .fill(Color.white)
                                    .frame(width: sizePin, height: sizePin))
                    .frame(width: sizePin,
                           height: sizePin)
                    .offset(y: -sizePin * 0.5)
            }
            
            let color = getColor(speed: point.location.speed,
                                 averageSpeed: averageSpeed,
                                 maxSpeed: maxSpeed,
                                 minSpeed: minSpeed)
            Circle().fill(color).frame(width: sizeWaypoint, height: sizeWaypoint)
        }
    }
}

func getColor(speed: Double, averageSpeed: Double, maxSpeed: Double, minSpeed: Double) -> Color {
    if speed > (averageSpeed + 0.5 * (maxSpeed - averageSpeed)) {
        return Color.green
    } else if speed < (averageSpeed - 0.5 * (averageSpeed - minSpeed)) {
        return Color.red
    } else {
        return Color.yellow
    }
}


struct Location: Identifiable {
    let id: UUID = UUID()
    var location: CLLocation
    let color: Color
    var type: LocationType = .none
}

enum LocationType {
    case start
    case end
    case none
}

