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
}
