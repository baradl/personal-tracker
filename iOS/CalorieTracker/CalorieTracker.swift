//
//  CalorieTracker.swift
//  personal_tracker (iOS)
//
//  Created by Bastian Radloff on 03.04.21.
//

import SwiftUI

struct CalorieTracker : View{
    var body: some View {
        ZStack{
            Color("BackgroundColor")
            GeometryReader{geometry in
                VStack{
                    HStack(alignment: .top, spacing: 65){
                        MacronutrientView(title: "Carbs", value: 0, unit: "g")
                        MacronutrientView(title: "Protein", value: 0, unit: "g")
                        MacronutrientView(title: "Fats", value: 0, unit: "g")
                        MacronutrientView(title: "Calories", value: 0, unit: "kcal")
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.1)
                    .background(ComponentBackgroundColor())
                    Divider()
                        .foregroundColor(Color(.lightGray))
                        .padding(.all, 10)
                    Spacer()
                    Text("Add Meal")
                        .font(.system(size: 25, weight: .light))
                        .frame(width: geometry.size.width * 0.7, height: geometry.size.height * 0.08)
                        .background(ComponentBackgroundColor())
                        .cornerRadius(15)
                        .padding(.horizontal, 50)
                        .padding(.vertical, 10)
                }
            }
        }
        .navigationBarTitle("Calorie Tracker")
    }
}


struct MacronutrientView : View {
    let title: String
    let value: Double
    let unit: String
    
    var body: some View {
        VStack(alignment: .leading){
            Text(title)
                .font(.system(size: 12, weight: .light))
                .padding(.vertical, 2)
            HStack{
                Text(String(format: "%.0f", value))
                    .font(.system(size: 14, weight: .bold))
                Text(unit)
                    .font(.system(size: 14, weight: .light))
            }
        }
    }
}
