//
//  StackedBarplot.swift
//  personal_tracker (iOS)
//
//  Created by Bastian Radloff on 27.03.21.
//

import SwiftUI

struct MultiBarsView: View {
    @State var open: Bool = false
    let animationTime: Double = 0.2
    
    let barsTop: [Bar]
    let barsBottom: [Bar]
    let max: Double

    init(barsTop: [Bar], barsBottom: [Bar]) {
        self.barsTop = barsTop
        self.barsBottom = barsBottom
        let maxBottom = barsBottom.map { $0.value }.max() ?? 0
        let maxTop = barsTop.map {$0.value}.max() ?? 0
        self.max = maxBottom + maxTop
    }

    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .bottom, spacing: 0) {
                ForEach(0..<barsTop.count) { index in
                    let barTop = barsTop[index]
                    let barBottom = barsBottom[index]
                    VStack{
                        Text("\(barTop.label)")
                            .font(.system(size: 10, weight: .bold))
                            .padding(.vertical, 5)
                        Spacer()
                        StackBarchartItem(open: $open,
                                          label: String(Int(barTop.value) + Int(barBottom.value)),
                                          labelTop: barTop.value < 550 ? "" : String(Int(barTop.value)),
                                          labelBottom: barBottom.value < 550 ? "" : String(Int(barBottom.value)),
                                          valueTop: self.max == 0.0 ? 0.0 : 0.6*(CGFloat(barTop.value + barBottom.value) / CGFloat(self.max) * geometry.size.height),
                                          valueBottom: self.max == 0.0 ? 0.0 : 0.6*(CGFloat(barBottom.value) / CGFloat(self.max) * geometry.size.height),
                                          colorTop: barTop.color,
                                          colorBottom: barBottom.color)
                            .animation(.easeInOut(duration: animationTime))
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    open = true
                }
            }
        }
    }
    
    struct StackBarchartItem: View {
        @Binding var open: Bool
        
        let label: String
        let labelTop: String
        let labelBottom: String
        
        let valueTop: CGFloat
        let valueBottom: CGFloat
        
        let colorTop: Color
        let colorBottom: Color
        
        var body: some View {
            Text(open ? label : "")
                .font(.system(size: 10, weight: .light))
            ZStack(alignment: .bottom){
                ZStack(alignment: .top){
                    Rectangle()
                        .foregroundColor(colorTop)
                        .frame(height: open ? valueTop : 0.0)
                        .cornerRadius(5.0)
                        .padding(.horizontal, 8)
                    Text(open ? labelTop : "")
                        .font(.system(size: 8, weight: .light))
                        .foregroundColor(Color(.darkGray))
                        .padding(.vertical, 4)
                }
                ZStack(alignment: .top){
                    Rectangle()
                        .foregroundColor(colorBottom)
                        .frame(height: open ? valueBottom : 0.0)
                        .cornerRadius(5.0)
                        .padding(.horizontal, 8)
                    Text(open ? labelBottom : "")
                        .font(.system(size: 8, weight: .light))
                        .foregroundColor(Color(.white))
                        .padding(.vertical, 4)
                }
            }
        }
    }
}

struct MultiBarplotView: View {
    var activeEnergy: Array<(String, Double)>
    var basalEnergy: Array<(String, Double)>
    
    let basalColor: Color = Color("BaseBlue")
    let activeColor: Color = Color("BrightOrange")

    var body: some View {
        let bars = createCalorieBars(activeEnergy: activeEnergy,
                                     basalEnergy: basalEnergy,
                                     activeColor: activeColor,
                                     basalColor: basalColor)
        GeometryReader{geometry in
            MultiBarsView(barsTop: bars.barsActive, barsBottom: bars.barsBasal)
                .frame(width: geometry.size.width, height: geometry.size.height)
                .background(ComponentBackgroundColor())
                .cornerRadius(12.0)
                .animation(.easeInOut)
        }
    }
    
    private func createCalorieBars(activeEnergy: Array<(String, Double)>,
                                   basalEnergy: Array<(String, Double)>,
                                   activeColor: Color,
                                   basalColor: Color) -> (barsActive: Array<Bar>, barsBasal: Array<Bar>) {
        
        var barsActive: Array<Bar> = []
        var barsBasal: Array<Bar> = []

        for (calsActive, calsBasal) in zip(activeEnergy, basalEnergy) {
            barsActive.append(Bar(id: UUID(),
                             value: calsActive.1,
                             label: calsActive.0,
                             color: activeColor))
            barsBasal.append(Bar(id: UUID(),
                             value: calsBasal.1,
                             label: calsBasal.0,
                             color: basalColor))
        }
        return (barsActive, barsBasal)
    }
}
