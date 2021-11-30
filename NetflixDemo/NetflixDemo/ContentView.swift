//
//  ContentView.swift
//  NetflixDemo
//
//  Created by thoonk on 2021/11/30.
//

import SwiftUI

struct ContentView: View {
    let titles = ["Netflix Sample App"]
    var body: some View {
        NavigationView {
            List(titles, id: \.self) {
                let netflixVC = HomeVCRepresentable()
                    .navigationBarHidden(true)
                    .edgesIgnoringSafeArea(.all)
                NavigationLink($0, destination: netflixVC)
            }
            .navigationTitle("SwiftUI to UIkit")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
