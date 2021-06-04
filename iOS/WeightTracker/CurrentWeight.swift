//
//  CurrentWeightView.swift
//  personal_tracker (iOS)
//
//  Created by Bastian Radloff on 21.03.21.
//

import SwiftUI

struct CurrentWeightView: View {
    let weight: Weight
    let dateFormatter: DateFormatter
    
    var body: some View {
        VStack{
            HStack(alignment: .top){
                Text("\(dateFormatter.string(from: weight.timestamp))")
                    .font(.footnote)
                    .foregroundColor(Color("TextColor"))
                    .padding(.top, 5)
            }
            HStack{
                Text("\(String(format: "%.1f", weight.weight))")
                    .foregroundColor(Color("TextColor"))
                    .font(.largeTitle)
                Text("kg")
                    .font(.largeTitle)
                    .foregroundColor(Color(.lightGray))
                    .padding(.vertical, 10)
            }
            let days = Calendar.current.numberOfDaysBetween(weight.timestamp, and: Date())-1
            Text("\(days) \(days == 1 ? "day" : "days") ago")
                .font(.footnote)
                .foregroundColor(Color("TextColor"))
                .padding(.bottom, 5)
            
        }
        .frame(width: 200, height: 120)
        .background(ComponentBackgroundColor())
        .cornerRadius(10.0)
        .padding(.all, 10)
    }
}
