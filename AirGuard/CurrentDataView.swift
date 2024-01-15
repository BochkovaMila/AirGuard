//
//  CurrentDataView.swift
//  AirGuard
//
//  Created by Mila B on 11.01.2024.
//

import SwiftUI

struct CurrentDataView: View {
    var body: some View {
        VStack {
            Text("Моя локация")
                .padding(.bottom, 50)
            ZStack {
                CrescentProgressView(progress: 0.1)
                    .frame(width: 200, height: 200)
                VStack {
                    HStack {
                        Text("-1")
                            .font(Font.system(size: 28))
                            .bold()
                        Text("AQI")
                    }
                    HStack {
                        Text("😄")
                        Text("Отлично")
                    }
                }
                .padding(.top, -30)
            }
            
        }
    }
}

