// Files for solution test submission.
//
// Created by Kirk Agbenyegah on 04/02/2023.
//

import Foundation

public struct SolutionTestFiles: Encodable {
    public let files: [SolutionFileData]

    init(files: [SolutionFileData]) {
        self.files = files
    }
}
