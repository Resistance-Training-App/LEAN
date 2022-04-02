//
//  TwelveWeekGraph.swift
//  Workout Planner
//
//  A line graph representing the user's workout activity over the last 12 weeks.
//

import SwiftUI
import Charts

struct TwelveWeekGraph: UIViewRepresentable {
    
    var workoutHistories: [WorkoutHistory]

    let lineChart = LineChartView()

    func makeUIView(context: UIViewRepresentableContext<TwelveWeekGraph>) -> LineChartView {
        setUpChart()
        return lineChart
    }

    func updateUIView(_ uiView: LineChartView, context: UIViewRepresentableContext<TwelveWeekGraph>) {

    }

    func setUpChart() {
        lineChart.noDataText = "No Workouts Completed"
        let dataSets = [getLineChartDataSet()]
        let data = LineChartData(dataSets: dataSets)
        data.setValueFont(.systemFont(ofSize: 7, weight: .light))
        lineChart.data = data

        lineChart.xAxis.drawAxisLineEnabled = false
        lineChart.xAxis.drawGridLinesEnabled = false
        lineChart.xAxis.drawLabelsEnabled = false

        lineChart.leftAxis.drawAxisLineEnabled = false
        lineChart.leftAxis.drawGridLinesEnabled = false
        lineChart.leftAxis.axisMinimum = 0

        lineChart.rightAxis.drawAxisLineEnabled = false
        lineChart.rightAxis.drawGridLinesEnabled = false
        lineChart.rightAxis.axisMinimum = 0

        lineChart.legend.enabled = false
        lineChart.setScaleEnabled(false)
    }

    func getChartDataPoints(weeks: [Int], times: [Double]) -> [ChartDataEntry] {
        var dataPoints: [ChartDataEntry] = []
        for count in (0..<weeks.count) {
            dataPoints.append(ChartDataEntry.init(x: Double(weeks[count]), y: times[count]))
        }

        return dataPoints
    }
    
    func getGradient() -> CGGradient {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let startColor = UIColor(red: 1, green: 0.5, blue: 0, alpha: 0)
        let startColorComponents = startColor.cgColor.components
        let endColor = UIColor.orange
        let endColorComponents = endColor.cgColor.components
        let colorComponents: [CGFloat] = [startColorComponents![0], startColorComponents![1],
                                          startColorComponents![2], startColorComponents![3],
                                          endColorComponents![0], endColorComponents![1],
                                          endColorComponents![2], endColorComponents![3]]
        let locations:[CGFloat] = [0, 1.0]
        return CGGradient(colorSpace: colorSpace,
                          colorComponents: colorComponents,
                          locations: locations,
                          count: 2)!
    }

    func getLineChartDataSet() -> LineChartDataSet {
        let dataPoints = getChartDataPoints(weeks: [1,2,3,4,5,6,7,8,9,10,11,12],
                                            times: CalcTwelveWeekData(workoutHistories:
                                                                        Array(workoutHistories)))
        let set = LineChartDataSet(entries: dataPoints, label: "Workout Minutes")
        set.lineWidth = 2.5
        set.circleRadius = 4
        set.circleHoleRadius = 2
        set.setColor(UIColor.orange)
        set.setCircleColor(UIColor.orange)
        set.fill = LinearGradientFill(gradient: getGradient(), angle: 90.0)
        set.fillAlpha = 1.0
        set.drawFilledEnabled = true
        set.drawValuesEnabled = false
        set.drawCircleHoleEnabled = false
        set.drawHorizontalHighlightIndicatorEnabled = true
        set.highlightColor = UIColor.systemGray
        return set
    }
}
