//
//  Barplot.swift
//  personal_tracker (iOS)
//
//  Created by Bastian Radloff on 16.03.21.
//
import SwiftUI

struct Bar: Identifiable {
    let id: UUID
    let value: Double
    let label: String
    let color: Color
}

struct BarsView: View {
    @State var open = false
    let animationTime: Double = 0.2
    
    let bars: [Bar]
    let max: Double

    init(bars: [Bar]) {
        self.bars = bars
        self.max = bars.map { $0.value }.max() ?? 0
    }

    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .bottom, spacing: 0) {
                ForEach(self.bars) { bar in
                    VStack{
                        Text("\(bar.label)")
                            .foregroundColor(Color("TextColor"))
                            .font(.system(size: 8, weight: .light))
                            .padding(.vertical, 5)
                        Spacer()
                        BarchartItem(open: $open,
                                     value: self.max == 0.0 ? 0.0 : 0.6*(CGFloat(bar.value) / CGFloat(self.max) * geometry.size.height),
                                     label: String(Int(bar.value)),
                                     color: bar.color)
                            .animation(.easeInOut(duration: animationTime))
                    }
                }
            }.onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                open = true
                            }
            }
            .onDisappear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                open = false
                            }
            }
        }
    }
    
    struct BarchartItem: View {
        @Binding var open: Bool
        var value: CGFloat = 0
        var label: String = "-"
        var color: Color = Color.white
        
        var body: some View {
            Text(label)
                .font(.system(size: 8, weight: .light))
                .foregroundColor(Color("TextColor"))
            Rectangle()
                .fill(color)
                .frame(height: open ? value : 0.0)
                .cornerRadius(5.0)
                .padding(.horizontal, 15)
        }
    }
}


struct BarChartView: View {
    let bars: [Bar] //= Array(repeating: Bar(id: UUID(), value: 0.0, label: "-", color: Color.white), count: 7)

    var body: some View {
        GeometryReader{geometry in
            ZStack{
                BarsView(bars: bars)
                    .frame(width: geometry.size.width,
                           height: geometry.size.height)
                    .background(ComponentBackgroundColor())
                    .cornerRadius(12.0)
            }
        }
    }
}



struct BarplotTitleView : View {
    let title: String
    var body: some View {
        HStack{
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .padding(.horizontal,10)
                .padding(.bottom, -5.0)
            Spacer()
        }
    }
}
