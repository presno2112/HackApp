//
//  ContentView.swift
//  HackApp
//
//  Created by Sebastian Presno Alvarado on 10/04/24.
//

import SwiftUI
import Charts

struct Product: Identifiable {
    let id = UUID()
    let title: String
    let revenue: Double
}
    

struct ContentView: View {
    @State private var timeRemaining : TimeInterval = 10
    @State private var timer : Timer?
    @State private var isRunning: Bool = false
    
    @State private var products: [Product] = [
        .init(title: "Annual", revenue: 0.7),
        .init(title: "Monthly", revenue: 0.2),
        .init(title: "Lifetime", revenue: 0.1)
    ]
    
    let dummyData = ["Equipo 1", "Equipo 2", "Equipo 3", "Equipo 4", "Equipo 5", "Equipo 6","Equipo 7", "Equipo 8", "Equipo 9" ]
    var body: some View {
        NavigationStack{
            GeometryReader{ geo in
                HStack(spacing: 0) {
                    // Right Part
                    VStack {
                        List{
                            ForEach(dummyData, id: \.self){data in
                                NavigationLink(destination: TeamAdminView()){
                                    Text(data)
                                        .font(.title2)
                                        .padding()
                                }

                            }
                            .padding()
                        }
                        .frame(width: geo.size.width / 2)
                        //.background(Color.red)
                    }
                    Divider()
                    VStack {
                        Chart(products) { product in
                            SectorMark(
                                angle: .value(
                                    Text(verbatim: product.title),
                                    product.revenue
                                )
                            )
                            .foregroundStyle(
                                by: .value(
                                    Text(verbatim: product.title),
                                    product.title
                                )
                            )
                        }
                        .padding()
                        Divider()
                        //.background(Color.blue)
                        ZStack{
                            Circle()
                                .stroke(lineWidth: 20)
                                .opacity(0.3)
                                .padding()
                            Circle()
                                .trim(from: 0, to: CGFloat(1-(timeRemaining/10)))
                                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                                .rotationEffect(.degrees(-90))
                                .padding()
                            Text(formattedTime())
                                .font(.largeTitle)
                                .bold()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        //.background(Color.green)
                        HStack{
                            Button{
                                isRunning.toggle()
                                if(isRunning){
                                    startTimer()
                                }
                                else{
                                    stopTimer()
                                }
                            }label: {
                                Image(systemName: isRunning ? "stop.fill": "play.fill")
                                    .frame(width: 50, height: 50)
                                    .font(.largeTitle)
                            }
                        }
                    }
                    .frame(width: geo.size.width / 2)
                }
            }
        }
    }
    private func formattedTime() -> String{
        let minutes = Int(timeRemaining)/60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func startTimer(){
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ _ in
            if timeRemaining > 0{
                timeRemaining -= 1
            }
            else{
                stopTimer()
            }
        }
    }
    
    private func stopTimer(){
        isRunning = false
        timer?.invalidate()
        timeRemaining = 10
    }
}

#Preview {
    ContentView()
}
