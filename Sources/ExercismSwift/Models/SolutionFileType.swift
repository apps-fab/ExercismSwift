//
// Created by Kirk Agbenyegah on 04/02/2023.
//

import Foundation

public enum SolutionFileType: Encodable, Sendable {
    case exercise
    case solution
    case legacy
    case readonly
}
