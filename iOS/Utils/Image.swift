//
//  Image.swift
//  personal_tracker (iOS)
//
//  Created by Bastian Radloff on 24.03.21.
//

import SwiftUI


struct CornerImage: View {
    var body: some View {
        Image("flame")
            .renderingMode(.original)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 15, height: 15)
    }
}


struct WorkoutImage: View {
    let imageString: String
    let size: CGFloat
    var body: some View {
        ZStack{
            Circle()
                .fill(Color("BaseGreen").opacity(0.5))
                .frame(width: size, height: size)
            Image(imageString)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 0.65 * size, height: 0.65 * size)
        }
    }
}
