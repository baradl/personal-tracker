//
//  Button.swift
//  personal_tracker
//
//  Created by Bastian Radloff on 19.02.21.
//

import SwiftUI

struct DistanceWorkoutButton: View {
    var body: some View {
        GeometryReader{ geometry in
            Text("")
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                .background(ComponentBackgroundColor())
                .cornerRadius(18)
        }
    }
}


struct AddButton: View {
    let offsetValue: CGFloat = 6
    let cornerRadius: CGFloat = 5
    let width: CGFloat = 50
    let height: CGFloat = 35
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Color("WaterColor"))
                .frame(width: width, height: height)
                .cornerRadius(cornerRadius)
                .offset(x: -offsetValue)
            Rectangle()
                .fill(Color("CaffeineColor"))
                .frame(width: width, height: height)
                .cornerRadius(cornerRadius)
                .offset(x: offsetValue)
            Rectangle()
                .fill(Color(.white))
                .frame(width: width, height: height)
                .cornerRadius(cornerRadius)
            Image(systemName: "plus")
                .renderingMode(.none)
                .resizable()
                .foregroundColor(Color("ComponentBackgroundColor"))
                .font(Font.title.weight(.bold))
                .frame(width: height * 0.5, height: height * 0.5, alignment: .center)
                .frame(width: width, height: height)
        }
    }
}

struct MainViewButton:  View {
    let imageString: String
    let title: String
    let dataLeft: String
    let dataMiddle: String
    let dataRight: String

    var body: some View {
        GeometryReader{ geometry in
            ZStack{
                VStack(alignment: .leading, spacing: 30){
                    Divider()
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
                    HStack(alignment: .bottom){
                        Text(dataLeft)
                            .font(.body)
                            .foregroundColor(Color(.white))
                        Spacer()
                        Text(dataMiddle)
                            .font(.body)
                            .foregroundColor(Color(.white))
                        Spacer()
                        Text(dataRight)
                            .font(.body)
                            .foregroundColor(Color(.white))
                    }
                }.padding(.horizontal, 20)
                .foregroundColor(Color("ComponentBackgroundColor"))
            }
            
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .topLeading)
        }
    }
}

struct PlusButton: View {
    var body: some View {
        Image(systemName: "plus.circle.fill")
            .font(.system(size: 30, weight: .bold))
            .foregroundColor(Color(.lightGray))
    }
}

struct MinusButton: View {
    var body: some View {
        Image(systemName: "minus.circle.fill")
            .font(.system(size: 30, weight: .bold))
            .foregroundColor(Color(.lightGray))
    }
}

struct TrackerButton: View {
    var imageString: String
    
    var body: some View {
        GeometryReader{geometry in
            Image(imageString)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: geometry.size.width * 0.3,
                       height: geometry.size.height * 0.3)
                .frame(width: geometry.size.width,
                       height: geometry.size.height)
                .background(ComponentBackgroundColor())
                .cornerRadius(18)
        }
    }
}

struct SettingsButton: View {   
    var body: some View {
        Image(systemName: "gearshape")
            .font(.system(size: 30, weight: .light))
            .foregroundColor(Color(.lightGray))
    }
}

struct BeverageButton: View {
    var beverage : Beverage
    
    var body: some View{
        VStack{
            Image(beverage.logopath)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .foregroundColor(Color(.white))
            Text(beverage.name)
                .font(.system(size:12, weight: .light))
                .foregroundColor(Color(.white))
        }
    }
}

struct PortionsizeButton:View {
    var portionsize:Int
    
    var body: some View {
        Text("\(portionsize)")
            .frame(width: 175, height: 40)
            .foregroundColor(.white)
            .background(ComponentBackgroundColor())
            .cornerRadius(10)
    }
}

struct ClosingButton: View {
    var body:some View{
        Image(systemName: "xmark.circle")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 20, height: 20)
    }
}

struct DeleteButton: View {
    var body: some View {
        Image(systemName: "trash")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .font(.system(size: 16, weight: .light))
            .foregroundColor(Color(.lightGray))
            .frame(width: 40, height: 40)
            .padding(.horizontal, 10)
    }
}


struct ConfirmationButton: View {
    let width: CGFloat
    let height: CGFloat
    var body: some View {
        Text("Add")
            .font(.title3)
            .foregroundColor(Color.white)
            .frame(width: width, height: height, alignment: .center)
            .background(Color.blue)
            .cornerRadius(10.0)
    }
}

struct CancelButton: View {
    let width: CGFloat
    let height: CGFloat
    var body: some View {
        Text("Cancel")
            .font(.title3)
            .foregroundColor(Color.white)
            .frame(width: width, height: height, alignment: .center)
            .background(Color.blue)
            .cornerRadius(10.0)
    }
}


struct DirectionView: View {
    let angle: Double
    let size: CGFloat
    var body: some View {
        Image(systemName: "triangle.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(Color(.lightGray))
            .rotationEffect(.degrees(angle))
            .frame(width: size, height: size)
    }
}


