//
//  ContentView.swift
//  Weather App
//
//  Created by Moideen Nazaif VM on 06/07/20.
//  Copyright © 2020 Moideen Nazaif VM. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var input: String = ""
    var body: some View {
        VStack {
            TextField("Enter the city", text: $input)
                .font(.title)
            Divider()
            Text(input)
                .font(.body)
        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
