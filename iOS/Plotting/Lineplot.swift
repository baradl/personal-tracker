//
//  Lineplot.swift
//  personal_tracker (iOS)
//
//  Created by Bastian Radloff on 28.03.21.
//

import SwiftUI

struct LineChartView: View {
    @State var show: Bool = false
    let animationTime: Double = 1
    let dateFormatter: DateFormatter = getDateFormatter(format: "MMMM yy")
    
    let data: Array<(Date, Double)>
    
    var body: some View {
        GeometryReader{ geometry in
            HStack(alignment: .top){
                let maxValue : Double = data.map{(date, value) in
                    return value
                }.max() ?? 0
                let minValue : Double = data.map{(date, value) in
                    return value
                }.min() ?? 0
                VStack(alignment: .trailing){
                    Text(String(format: "%.1f", maxValue))
                        .font(.system(size: 8, weight: .light))
                    Spacer()
                    Text(String(format: "%.1f", minValue + (maxValue - minValue)*0.75))
                        .font(.system(size: 8, weight: .light))
                    Spacer()
                    Text(String(format: "%.1f", (maxValue + minValue)*0.5))
                        .font(.system(size: 8, weight: .light))
                    Spacer()
                    Text(String(format: "%.1f", minValue + (maxValue - minValue)*0.25))
                        .font(.system(size: 8, weight: .light))
                    Spacer()
                    Text(String(format: "%.1f", minValue))
                        .font(.system(size: 8, weight: .light))
                }
                .frame(width: geometry.size.width * 0.05, height: 0.91 * geometry.size.height)
                Divider().padding(.all, -1)
                VStack{
                    Line(data: data)
                        .trim(to: show ? 1 : 0)
                        .stroke(LinearGradient(
                                    gradient: Gradient(colors: [Color.red, Color.orange]),
                                    startPoint:.top,
                                    endPoint: .bottom) ,lineWidth: 2)
                        .animation(.linear(duration: animationTime))
                    Divider()
                    HStack(alignment: .top){
                        Text(dateFormatter.string(from: data.first?.0 ?? Date()))
                            .font(.system(size:10, weight: .light))
                            .padding(.horizontal, 1)
                        Spacer()
                        Text(dateFormatter.string(from: data.last?.0 ?? Date()))
                            .font(.system(size:10, weight: .light))
                            .padding(.horizontal, 1)
                    }
                }
            }
            
        }.onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            show = true
                        }
        }
    }
}

struct Line: Shape {
    let data: Array<(Date, Double)>

    func path(in rect: CGRect) -> Path {
        Path{path in
            let maxValue : Double = data.map{(date, value) in
                return value
            }.max() ?? 0
            let minValue : Double = data.map{(date, value) in
                return value
            }.min() ?? 0
            
            let dateDifference: Double = DateInterval(start: data.first?.0 ?? Date(),
                                                      end: data.last?.0 ?? Date()).duration

            var previousDate = data.first?.0 ?? Date()
            var previousX: Double = 0
            if let first = data.first{
                let startY: Double = (1 - ((first.1 - minValue)/(maxValue-minValue))) * Double(rect.height)
                
                path.move(to: CGPoint(x:0, y:CGFloat(startY)))
                for (date, value) in data{
                    let y = Double(rect.height) * (1 - ((value - minValue)/(maxValue-minValue)))
                    let x = previousX + Double(rect.width) * (DateInterval(start: previousDate,
                                                                           end: date).duration/dateDifference)
                    path.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
                    
                    previousX = x
                    previousDate = date
                }
            }
        }
    }
}
