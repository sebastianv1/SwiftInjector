//
//  File.swift
//  
//
//  Created by Sebastian Shanus on 7/1/21.
//

import Foundation

extension String {
    static func indent(tabs: Int) -> String {
        String(repeating: " ", count: tabs * 4)
    }
}
