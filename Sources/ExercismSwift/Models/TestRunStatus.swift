//
// Created by Kirk Agbenyegah on 04/02/2023.
//

import Foundation

public enum TestRunStatus: String, Decodable {
    case pass
    case fail
    case error
    case ops_error
    case queued
    case timeout
    case cancelled
}






