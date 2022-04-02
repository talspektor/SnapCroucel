//
//  post.swift
//  SnapCroucel
//
//  Created by Tal talspektor on 01/04/2022.
//

import SwiftUI

// Post Model And Sample Data
struct Post: Identifiable {
    var id = UUID().uuidString
    var postImage: String
}
