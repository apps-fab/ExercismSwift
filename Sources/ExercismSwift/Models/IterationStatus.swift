//
// Created by Kirk Agbenyegah on 08/04/2023.
//

import Foundation

public enum IterationStatus: String, Codable, Sendable {
    case deleted = "deleted"
    case untested = "untested"
    case testing = "testing"
    case testsFailed = "tests_failed"
    case analyzing = "analyzing"
    case essentialAutomatedFeedback = "essential_automated_feedback"
    case actionableAutomatedFeedback = "actionable_automated_feedback"
    case nonActionableAutomatedFeedback = "non_actionable_automated_feedback"
    case noAutomatedFeedback = "no_automated_feedback"
    case celebratoryAutomatedFeedback = "celebratory_automated_feedback"
}
