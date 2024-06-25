//
//  HeaderView.swift
//  Daily-Wins
//
//  Created by Eric Kim on 6/24/24.
//

import SwiftUI

struct HeaderView: View {
    let title: String
    let backgroundColor: Color

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .foregroundColor(backgroundColor)
            VStack {
                Text(title)
                    .foregroundColor(Color.white)
                    .bold()
                    .font(.system(size:30))
                
            }
        }
        .frame(width: UIScreen.main.bounds.width * 3, height: 100)
    }
}

#Preview {
    HeaderView(title: "Title", backgroundColor: .blue)
}
