//
//  RateFluctuationDetailView.swift
//  ExchangeRates
//
//  Created by Davi Martinelli de Lira on 10/8/23.
//

import SwiftUI
import Charts

struct ChartComparation: Identifiable {
    let id = UUID()
    var symbol: String
    var period: Date
    var endRate: Double
}



class RateFluctuationViewModel: ObservableObject {
    @Published var fluctuations: [Fluctuation] = [
        Fluctuation(symbol: "USD", change: 0.0008, changePct: 0.4175, endRate: 0.18857),
        Fluctuation(symbol: "EUR", change: 0.00348, changePct: 0.41535, endRate: 0.18257),
        Fluctuation(symbol: "GBP", change: -0.0108, changePct: -0.41345, endRate: 0.19897)
    ]
    @Published var chartComparation: [ChartComparation] = [
        ChartComparation(symbol: "USD", period: "2022-11-13".toDate(), endRate: 0.4352),
        ChartComparation(symbol: "USD", period: "2022-11-12".toDate(), endRate: 0.2345),
        ChartComparation(symbol: "USD", period: "2022-11-11".toDate(), endRate: 0.1234),
        ChartComparation(symbol: "USD", period: "2022-11-10".toDate(), endRate: 0.2351)
    ]
    
    @Published var timeRange = TimeRangeEnum.today

    var hasRates: Bool {
        return chartComparation.filter { $0.endRate > 0 }.count > 0
    }
    
    var yAxisMin: Double {
        let min = chartComparation.map { $0.endRate }.min() ?? 0.0
        return (min - (min * 0.02))
    }
    
    var yAxisMax: Double {
        let max = chartComparation.map { $0.endRate }.max() ?? 0.0
        return (max + (max * 0.02))
    }
    
    func xAxisLabelFormatStyle(for date: Date) -> String {
        switch timeRange {
        case .today:
            return date.formatter(to: "HH:mm")
        case .thisWeek, .thisMonth:
            return date.formatter(to: "dd, MMM")
        case .thisSemester:
            return date.formatter(to: "MMM")
        case .thisYear:
            return date.formatter(to: "MMM, YYYY")
        }
    }
}





struct RateFluctuationDetailView: View {
    @StateObject var viewModel = RateFluctuationViewModel()
    
    @State var baseCurrency: String
    @State var rateFluctuation: Fluctuation
    @State private var isPresentedBaseCurrencyFilter = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            valuesView
            graphicChartView
            comparationView
        }
        .padding(.leading, 8)
        .padding(.trailing, 8)
        .navigationTitle("BRL a EUR")
    }
    
    private var valuesView: some View {
        HStack(alignment: .center, spacing: 8) {
            Text(rateFluctuation.endRate.formatter(decimalPlaces: 4))
                .font(.system(size: 28, weight: .bold))
            Text(rateFluctuation.changePct.toPercentage(with: true))
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(rateFluctuation.change.color)
                .background(rateFluctuation.changePct.color.opacity(0.2))
            Text(rateFluctuation.change.formatter(decimalPlaces: 4, with: true))
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(rateFluctuation.change.color)
            Spacer()
        }
        .padding(.init(top: 8, leading: 8, bottom: 8, trailing: 8))
    }
    
    private var graphicChartView: some View {
        VStack {
            periodFilterView
            lineCharView
        }
        .padding(.top, 8)
        .padding(.bottom, 8)
    }
    
    private var periodFilterView: some View {
        HStack(spacing: 16) {
            Button {
                print("1 dia")
            } label: {
                Text("1 dia")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.blue)
                    .underline()
            }
            
            Button {
                print("7 dias")
            } label: {
                Text("7 dias")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.gray)
            }
            
            Button {
                print("1 mes")
            } label: {
                Text("1 mês")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.gray)
            }
            
            Button {
                print("6 meses")
            } label: {
                Text("6 meses")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.gray)
            }
            
            Button {
                print("1 ano")
            } label: {
                Text("1 ano")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.gray)
            }
        }
    }
    
    private var lineCharView: some View {
        Chart(viewModel.chartComparation) { item in
            LineMark(
                x: .value("Period", item.period),
                y: .value("Rates", item.endRate)
            )
            .interpolationMethod(.catmullRom
            )
            
            if !viewModel.hasRates {
                RuleMark(
                    y: .value("Conversao Zero", 0)
                )
                .annotation(position: .overlay, alignment: .center) {
                    Text("Sem valores neste período")
                        .font(.footnote)
                        .padding()
                        .background(Color(UIColor.systemBackground))
                }
            }
            
        }
        .chartXAxis{
            AxisMarks(preset: .aligned) { date in
                AxisGridLine()
                AxisValueLabel(viewModel.xAxisLabelFormatStyle(for: date.as(Date.self) ?? Date()))
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading) { rate in
                AxisGridLine()
                AxisValueLabel(rate.as(Double.self)?.formatter(decimalPlaces: 3) ?? 0.0.formatter(decimalPlaces: 3))
            }
        }
        .chartYScale(domain: viewModel.yAxisMin...viewModel.yAxisMax)
        .frame(height: 260)
        .padding(.trailing, 20)
    }
    
    private var comparationView: some View {
        VStack(spacing: 8) {
            buttonComparationView
            comparationScrollView
            Spacer()
        }
        .padding(.top, 8)
        .padding(.bottom, 8)
    }
    
    private var buttonComparationView: some View {
        Button {
            isPresentedBaseCurrencyFilter.toggle()
        } label: {
            Image(systemName: "magnifyingglass")
            Text("Comparar com")
                .font(.system(size: 16))
        }
        .fullScreenCover(isPresented: $isPresentedBaseCurrencyFilter, content: {
            BaseCurrencyFilterView()
        })
    }
    
    private var comparationScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false){
            LazyHGrid(rows: [GridItem(.flexible())], alignment: .center) {
                ForEach(viewModel.fluctuations) {
                    fluctuation in
                    Button {
                        print("Comparacao")
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(fluctuation.symbol) / \(baseCurrency)")
                                .font(.system(size: 14))
                                .foregroundColor(.black)
                            Text(fluctuation.endRate.formatter(decimalPlaces: 4))
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.black)
                            HStack(alignment: .bottom, spacing: 60) {
                                Text(fluctuation.symbol)
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.black)
                                Text(fluctuation.changePct.toPercentage())
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(fluctuation.changePct.color)
                                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .trailing)
                            }
                        }
                        .padding(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.gray, lineWidth: 1)
                        )
                    }
                }
            }
        }
    }
}

#Preview {
    RateFluctuationDetailView(baseCurrency: "BRL", rateFluctuation: Fluctuation(symbol: "EUR", change: 0.00348, changePct: 0.41535, endRate: 0.18257))
}
