import UIKit
import CorePlot

class BarPlotViewController : UIViewController {
    
    private lazy var hostView: CPTGraphHostingView = {
        let view = CPTGraphHostingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var barGraph : CPTXYGraph? = nil
    private var barPlot1: CPTBarPlot!
    private var barPlot2: CPTBarPlot!
    private var steps = [16800, 1524, 1305, 3015, 1002, 1200, 1000]
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        view.addSubview(hostView)
        NSLayoutConstraint.activate([
            hostView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            hostView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            hostView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            hostView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        
        // 更新資料
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//            self.steps = self.steps.map { $0 / 2}
//
//
//            let plotSpace = self.hostView.hostedGraph?.defaultPlotSpace as! CPTXYPlotSpace
//            let maxValue = self.steps.max()! + 100
//            plotSpace.yRange = CPTPlotRange(location:0, length:maxValue as NSNumber)
//            plotSpace.xRange = CPTPlotRange(location:0.5, length:7) // 從 0.5 開始，可用來調整 X 起始值
//
//
//            let temp = self.hostView.hostedGraph?.allPlots()
//
//            temp?.forEach {
//                self.hostView.hostedGraph?.remove($0)
//            }
//
//
//            temp?.forEach{
//                self.hostView.hostedGraph?.add($0)
//
//            }
//        }
        
    }

    override func viewDidAppear(_ animated : Bool)
    {
        super.viewDidAppear(animated)

        // Create graph from theme
        let newGraph = CPTXYGraph(frame: hostView.bounds)
        
        
//        newGraph.apply(CPTTheme(named: .plainWhiteTheme))
        
//        newGraph.fill = CPTFill(color: CPTColor.gray()) // 設定背景色
        

        let hostingView = self.hostView
        hostingView.hostedGraph = newGraph
        

        if let frameLayer = newGraph.plotAreaFrame {
            // Border
            frameLayer.borderLineStyle = nil
            frameLayer.cornerRadius    = 0.0
            frameLayer.masksToBorder   = false

            // Paddings
            newGraph.paddingLeft   = 0.0
            newGraph.paddingRight  = 0.0
            newGraph.paddingTop    = 0.0
            newGraph.paddingBottom = 0.0

            frameLayer.paddingLeft   = 70.0
            frameLayer.paddingTop    = 20.0
            frameLayer.paddingRight  = 20.0
            frameLayer.paddingBottom = 80.0
            
        }

        // Graph title
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center

        let lineOne = "Graph Title"
        let lineTwo = "Line 2"

        let line1Font = UIFont(name: "Helvetica-Bold", size:16.0)
        let line2Font = UIFont(name: "Helvetica", size:12.0)

        let graphTitle = NSMutableAttributedString(string: lineOne + "\n" + lineTwo)

        let titleRange1 = NSRange(location: 0, length: lineOne.utf16.count)
        let titleRange2 = NSRange(location: lineOne.utf16.count + 1, length: lineTwo.utf16.count)

        graphTitle.addAttribute(.foregroundColor, value:UIColor.gray, range:titleRange1)
        graphTitle.addAttribute(.foregroundColor, value:UIColor.gray, range:titleRange2)
        graphTitle.addAttribute(.paragraphStyle, value:paragraphStyle, range:NSRange(location: 0, length: graphTitle.length))
        graphTitle.addAttribute(.font, value:line1Font!, range:titleRange1)
        graphTitle.addAttribute(.font, value:line2Font!, range:titleRange2)

//        newGraph.attributedTitle = graphTitle

        newGraph.titleDisplacement        = CGPoint(x: 0.0, y:20.0)
        newGraph.titlePlotAreaFrameAnchor = .top
        

        // Plot space
        // 設定顯示資料範圍
        let plotSpace = newGraph.defaultPlotSpace as! CPTXYPlotSpace
        let maxValue = ((steps.max()! / 100) + 1) * 100
        plotSpace.yRange = CPTPlotRange(location:0, length:maxValue as NSNumber)
        plotSpace.xRange = CPTPlotRange(location:0.5, length:7) // 從 0.5 開始，可用來調整 X 起始值

        let axisSet = newGraph.axisSet as! CPTXYAxisSet

        if let x = axisSet.xAxis {
            x.labelingPolicy = .none
            x.majorIntervalLength = 1
            
            var majorTickLocations = Set<NSNumber>()
            var axisLabels = Set<CPTAxisLabel>()
            for idx in 1...7 {
                majorTickLocations.insert(NSNumber(value: idx - 1))
                let label = CPTAxisLabel(text: "D\(idx)", textStyle: CPTTextStyle())
                label.tickLocation = NSNumber(value: idx)
                label.offset = 5.0 // label 與 X 軸間距
                label.alignment = .center
                axisLabels.insert(label)
            }
            x.majorTickLocations = majorTickLocations
            x.axisLabels = axisLabels
            
            let axisLineStyle = CPTMutableLineStyle()
            axisLineStyle.lineWidth = 1.0
            axisLineStyle.lineColor = CPTColor.blue()
            x.axisLineStyle = axisLineStyle
                        
//            x.majorTickLineStyle  = nil // 移除標記
//            x.minorTickLineStyle  = nil
//            x.majorIntervalLength = 5.0
            x.orthogonalPosition  = 0.0
            x.title               = "X Axis"
//            x.titleLocation       = 7.5
//            x.titleOffset         = 15.0
//
            // Custom labels
//            let customTickLocations = [1, 3, 5, 7]
//            let xAxisLabels         = ["Label A", "Label B", "Label C", "Label D"]
//
//            var labelLocation = 0
//            var customLabels = Set<CPTAxisLabel>()
//            for tickLocation in customTickLocations {
//                let newLabel = CPTAxisLabel(text:xAxisLabels[labelLocation], textStyle:x.labelTextStyle)
//                labelLocation += 1
//                newLabel.tickLocation = tickLocation as NSNumber
//                newLabel.offset       = x.labelOffset + x.majorTickLength
//                newLabel.rotation     = CGFloat(.pi / 4.0)
//                customLabels.insert(newLabel)
//            }
//
//            x.axisLabels = customLabels
        }

        if let y = axisSet.yAxis {
            
            let axisLineStyle = CPTMutableLineStyle()
            axisLineStyle.lineWidth = 2.0
            axisLineStyle.lineColor = CPTColor.green()

            y.labelingPolicy = .equalDivisions
            y.preferredNumberOfMajorTicks = 5 // 分幾個 tick
//            y.majorIntervalLength = 4200 // 主 間距
//            y.alternatingBandAnchor = 100
            
//            y.labelOffset = -10.0
            y.minorTicksPerInterval = 2 // 次要 間距中，再分幾格
            y.majorTickLength = 0
            let majorTickLineStyle = CPTMutableLineStyle()
            majorTickLineStyle.lineColor = CPTColor.black().withAlphaComponent(0.1)
            y.majorTickLineStyle = majorTickLineStyle
            y.axisLineStyle = axisLineStyle
            
            // 格式化，為千分位
            let formatter = NumberFormatter()
            formatter.locale = Locale(identifier: "en_US")
            formatter.numberStyle = .decimal
            y.labelFormatter = formatter
            
            
            
//            y.axisLineStyle       = nil
//            y.majorTickLineStyle  = nil
//
//
            let majorGridLineStyle = CPTMutableLineStyle()
            majorGridLineStyle.lineColor = .lightGray()
            majorGridLineStyle.lineWidth = 1
            y.majorGridLineStyle = majorGridLineStyle
            
            let minorGridLineStyle = CPTMutableLineStyle()
            minorGridLineStyle.lineColor = .lightGray()
            minorGridLineStyle.lineWidth = 0.5
            minorGridLineStyle.dashPattern = [5, 1]
            y.minorGridLineStyle = minorGridLineStyle
            
//            y.orthogonalPosition  = 0.0
//            y.title               = "步數"
            y.titleOffset         = 0.0
//            y.titleLocation       = 0
//            y.titleDirection = .positive
//            y.titleRotation = 0

            
            y.axisTitle = CPTAxisTitle(text: "步數", textStyle: CPTTextStyle())
//            y.titleLocation = 4200
            
            
            y.axisConstraints = CPTConstraints(lowerOffset: 0)
            
            
        
        }

        // First bar plot
        barPlot1 = CPTBarPlot()//.tubularBarPlot(with: .green(), horizontalBars:false)
        barPlot1.fill = CPTFill.init(color: .orange())// CPTFill(color: CPTColor(componentRed:0.92, green:0.28, blue:0.25, alpha:1.00))
        barPlot1.barCornerRadius = 2.0 // 圓角
        barPlot1.baseValue  = 0.0
        barPlot1.dataSource = self
        barPlot1.barOffset  = 1 // 調整偏移值
        barPlot1.barWidth = 0.3 // 寬度
        barPlot1.identifier = "Bar Plot 1" as NSString
        
        
        
        // 設定 bar border 外框樣式
        let style = CPTMutableLineStyle()
        style.lineColor = .blue()
        style.lineWidth = 1
        style.lineWidth = 0.0 // 移除 bar 的 border 顏色
        barPlot1.lineStyle = style
        newGraph.add(barPlot1, to:plotSpace)
        
        

        // Second bar plot
//        barPlot2                 = CPTBarPlot.tubularBarPlot(with: .blue(), horizontalBars:false)
//        barPlot2.dataSource      = self
//        barPlot2.baseValue       = 0.0
//        barPlot2.barOffset       = 1.4
//        barPlot2.barCornerRadius = 2.0
//        barPlot2.barWidth = 0.3
//        barPlot2.identifier      = "Bar Plot 2" as NSString
//        newGraph.add(barPlot2, to:plotSpace)
        
          
        // 平均線
        let dataSourceLinePlot = CPTScatterPlot()
        let lineStyle = CPTMutableLineStyle()
        lineStyle.lineWidth = 1
        lineStyle.lineColor = CPTColor.red()
        lineStyle.dashPattern = [5, 1]
        dataSourceLinePlot.dataLineStyle = lineStyle
        dataSourceLinePlot.identifier = "horizontalLineForAverage" as NSString
        dataSourceLinePlot.dataSource = self
        dataSourceLinePlot.interpolation = .linear
        dataSourceLinePlot.plotSymbol = nil
        newGraph.add(dataSourceLinePlot, to: plotSpace)
        

        self.barGraph = newGraph
    }

    
}

// MARK: CPTBarPlotDataSource
extension BarPlotViewController: CPTBarPlotDataSource {
    
    func numberOfRecords(for plot: CPTPlot) -> UInt {
        return 7
    }
    
    func number(for plot: CPTPlot, field fieldEnum: UInt, record idx: UInt) -> Any? {
        if plot.identifier as! String == "horizontalLineForAverage" {

            if CPTScatterPlotField(rawValue: Int(fieldEnum)) == CPTScatterPlotField.Y {
                return 4000 //* idx as NSNumber
            } else {
                return Double(idx) * 1.5
            }

        } else if plot == barPlot1 {
            switch CPTBarPlotField(rawValue: Int(fieldEnum))! {
            case .barLocation:
                return Double(idx) as NSNumber
                
            case .barTip:
                return steps[Int(idx)]
                
            default:
                return nil
            }
        } else if plot == barPlot2 {
            switch CPTBarPlotField(rawValue: Int(fieldEnum))! {
            case .barLocation:
                return Double(idx) as NSNumber
                
            case .barTip:
                return steps[Int(idx)]
                
            default:
                return nil
            }
        }
        
        return nil
    }
}