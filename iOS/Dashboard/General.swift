//
//  General.swift
//  personal_tracker (iOS)
//
//  Created by Bastian Radloff on 28.03.21.
//

import SwiftUI

struct SingleMetricView : View {
    let title: String
    let valueString: String
    let unitString: String
    
    var body: some View {
        GeometryReader{geometry in
            VStack{
                Text(title)
                    .font(.system(size: 16, weight: .light))
                    .foregroundColor(Color("TextColor"))
                HStack{
                    Text(valueString)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color("TextColor"))
                    if unitString != "" {
                        Text(unitString)
                            .font(.system(size: 18, weight: .light))
                            .foregroundColor(Color(.lightGray))
                    }
                }
            }
            .frame(width: geometry.size.width,
                   height: geometry.size.height)
            .background(ComponentBackgroundColor())
            .cornerRadius(10.0)
        }.padding(.horizontal, 2)
    }
}
