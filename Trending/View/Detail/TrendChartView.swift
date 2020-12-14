//
//  TrendChartView.swift
//  Trending
//
//  Created by Alexander Skorulis on 5/12/20.
//

import Foundation
import SwiftUI
import Charts

struct TrendChartView: UIViewRepresentable {
    
    let data: [TwitterDataPoint]
    
    func makeUIView(context: Context) -> TrendChart {
        return TrendChart(frame: .zero)
    }
    
    func updateUIView(_ uiView: TrendChart, context: Context) {
        print("Update \(data.count)")
        uiView.dataPoints = data
    }
    
}

class TrendChart: LineChartView, ChartViewDelegate {
    
    var dataPoints:[TwitterDataPoint] = [] {
        didSet {
            redraw()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        rightAxis.enabled = false
        dragEnabled = false
        isUserInteractionEnabled = false
        
        xAxis.drawLabelsEnabled = false
        
    }
    
    private func redraw() {
        if dataPoints.count == 0 {
            return
        }
        
        let points = dataPoints.map { ChartDataEntry(x: $0.createdAt, y: Double($0.value)) }
        let line = LineChartDataSet(entries: points)
        line.circleRadius = 0
        line.colors = [NSUIColor.black]
        
        self.data = LineChartData(dataSet: line)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 200, height: 200)
    }
    
    //MARK: ChartViewDelegate
    
}
