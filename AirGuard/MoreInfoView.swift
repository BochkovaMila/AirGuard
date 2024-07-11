//
//  MoreInfoView.swift
//  AirGuard
//
//  Created by Mila B on 26.01.2024.
//

import SwiftUI

struct MoreInfoView: View {
    
    let data = [
        ["Good", "1", "[0; 20)", "[0; 40)", "[0; 20)", "[0; 10)", "[0; 60)", "[0; 4400)"],
        ["Fair", "2", "[20; 80)", "[40; 70)", "[20; 50)", "[10; 25)", "[60; 100)", "[4400;9400)"],
        ["Moderate", "3", "[80; 250)", "[70; 150)", "[50; 100)", "[25; 50)", "[100; 140)", "[9400-12400)"],
        ["Poor", "4", "[250; 350)", "[150; 200)", "[100; 200)", "[50; 75)", "[140; 180)", "[12400; 15400)"],
        ["Very Poor", "5", "⩾350", "⩾200", "⩾200", "⩾75", "⩾180", "⩾15400"]
      ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                
                Group {
                    Text("AirGuard provides current, forecast and statistical data on air pollution. In addition to the general Air Quality Index, data are provided on polluting gases such as carbon monoxide (CO), nitrogen oxide (NO), nitrogen dioxide (NO2), ozone (O3), sulfur dioxide (SO2), ammonia (NH3) and suspended particles (PM2.5 and PM10).")
                    Text("The air pollution forecast is available 4 days in advance. Statistical data is available starting from November 27, 2020.")
                    Text("AirGuard uses an open weather air quality scale with five levels: good (1), fair (2), moderate (3), poor (4) and very poor (5). For each level, the maximum concentrations of the main pollutants are indicated: sulfur dioxide, nitrogen oxides, suspended particles PM10 and PM2.5, ozone and carbon monoxide.")
                }
                .padding(.trailing)
                
                Grid(alignment: .leading, horizontalSpacing: 2, verticalSpacing: 2) {
                    GridRow {
                        Text("Name")
                            .bold()
                        Text("Index")
                            .bold()
                        Text("Pollutant concentration (μg/m3)")
                            .bold()
                            .gridCellColumns(3)
                    }
                    GridRow {
                        Text("")
                        Text("")
                        Group {
                            Text("SO2")
                            Text("NO2")
                            Text("PM10")
                            Text("PM2.5")
                            Text("O3")
                            Text("CO")
                        }
                        .bold()
                    }
                    Divider()
                    ForEach(data, id: \.self) { dt in
                        GridRow {
                            ForEach(dt, id: \.self) { item in
                                Text(item)
                            }
                        }
                        Divider()
                    }
                }
                .padding()
            }
            .padding()
        }
        .navigationBarTitle("More Information")
    }
}
