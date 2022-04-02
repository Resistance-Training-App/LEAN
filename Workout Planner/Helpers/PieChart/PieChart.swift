//
//  PieChart.swift
//  MyPieChart
//
//  Modified solution from https://blckbirds.com/post/charts-in-swiftui-part-2-pie-chart/
//

import SwiftUI

struct PieChart: View {
    
    var data: [ChartData]
    var separatorColor: Color
    var accentColors: [Color]
    
    @State private var currentValue = ""
    @State private var currentLabel = ""
    @State private var touchLocation: CGPoint = .init(x: -1, y: -1)
    
    var pieSlices: [PieSlice] {
        var slices = [PieSlice]()
        data.enumerated().forEach {(index, data) in
            let value = normalizedValue(index: index, data: self.data)
            if slices.isEmpty    {
                slices.append((.init(startDegree: 0, endDegree: value * 360)))
            } else {
                slices.append(.init(startDegree: slices.last!.endDegree,
                                    endDegree: (value * 360 + slices.last!.endDegree)))
            }
        }
        return slices
    }
    
    var body: some View {
        VStack {
            ZStack {
                GeometryReader { geometry in
                    ZStack  {
                        ForEach(0..<self.data.count, id: \.self) { i in
                            PieChartSlice(center: CGPoint(x: geometry.frame(in: .local).midX,
                                                          y: geometry.frame(in:  .local).midY),
                                          radius: geometry.frame(in: .local).width/2,
                                          startDegree: pieSlices[exist: i]?.startDegree ?? 0,
                                          endDegree: pieSlices[exist: i]?.endDegree ?? 0,
                                          isTouched: sliceIsTouched(index: i,
                                                                    inPie: geometry.frame(in:  .local)),
                                          accentColor: accentColors[i],
                                          separatorColor: separatorColor)
                        }
                    }
                        .gesture(DragGesture(minimumDistance: 0)
                                .onChanged({ position in
                                    let pieSize = geometry.frame(in: .local)
                                    touchLocation = position.location
                                    updateCurrentValue(inPie: pieSize)
                                })
                                .onEnded({ _ in
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        withAnimation(Animation.easeOut) {
                                            resetValues()
                                        }
                                    }
                                })
                        )
                }
                    .aspectRatio(contentMode: .fit)
                VStack  {
                    if !currentLabel.isEmpty {
                        Text("\(currentLabel)\n\(String(currentValue.dropLast(2))) reps")
                            .font(.caption)
                            .bold()
                            .foregroundColor(.black)
                            .padding(5)
                            .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.white).shadow(radius: 3))
                            .multilineTextAlignment(.center)
                    }

                }
                .padding()
            }
            VStack(alignment: .leading) {
                ForEach(0..<data.count, id: \.self) { i in
                    HStack {
                        accentColors[i]
                            .frame(width: 20, height: 20)
                            .padding([.top, .bottom], 5)
                        Text(data[i].label)
                            .bold()
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }
                    
                }
            }
            Spacer()
        }
        .padding()
    }
    
    
    func updateCurrentValue(inPie pieSize: CGRect)  {
        guard let angle = angleAtTouchLocation(inPie: pieSize, touchLocation: touchLocation) else { return }
        let currentIndex = pieSlices.firstIndex(where: { $0.startDegree < angle && $0.endDegree > angle }) ?? -1
        
        currentLabel = data[currentIndex].label
        currentValue = "\(data[currentIndex].value)"
    }
    
    func resetValues() {
        currentValue = ""
        currentLabel = ""
        touchLocation = .init(x: -1, y: -1)
    }
    
    func sliceIsTouched(index: Int, inPie pieSize: CGRect) -> Bool {
        guard let angle = angleAtTouchLocation(inPie: pieSize, touchLocation: touchLocation) else { return false }
        return pieSlices.firstIndex(where: { $0.startDegree < angle && $0.endDegree > angle }) == index
    }
    
}
