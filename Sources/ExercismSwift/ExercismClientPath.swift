//
//  ExercismClientPath.swift
//  
//
//  Created by Angie Mugo on 26/09/2022.
//

public enum ExercismClientPath:  String {
    case exercises = "/v2/tracks/%@/exercises"
    case tracks = "/v2/tracks"
    case validateToken = "/v2/validate_token"
    case solutions = "/v2/solutions"
    case solutionsFile = "/v1/solutions/%@"
    case badges = "/v1/badges"
    case testSubmission = "/v2/solutions/%@/submissions"
    case completeSolution = "/v2/solutions/%@/complete"
}
