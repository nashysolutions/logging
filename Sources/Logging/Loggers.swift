//
//  Loggers.swift
//  logging
//
//  Created by Robert Nash on 17/05/2025.
//

import Foundation
import Dependencies
import FoundationDependencies
import os.log

public extension Logger {
    
    init(category: String) {
        @Dependency(\.mainBundleClient) var mainBundleClient
        let subsystem = (try? mainBundleClient.extractIdentifier()) ?? "Unknown Bundle Identifier"
        self.init(subsystem: subsystem, category: category)
    }
}
