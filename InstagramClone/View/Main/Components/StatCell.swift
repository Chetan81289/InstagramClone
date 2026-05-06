//
//  StatCell.swift
//  InstagramClone
//
//  Created by Chetan purohit on 05/05/26.
//

import SwiftUI

struct StatCell: View {
    let number: Int
    let label: String

    var body: some View {
        VStack(spacing: 2) {
            Text("\(number)")
                .font(.headline.weight(.bold))
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct StatCell_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            StatCell(number: 42, label: "Posts")
            StatCell(number: 128, label: "Followers")
            StatCell(number: 256, label: "Following")
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
