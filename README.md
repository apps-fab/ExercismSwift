# ExercismSwift
Swift API for exercism

### Init Client 
#### Without Token
```swift
 let client = ExercismClient()
```
#### With Token
```swift
 let client = ExercismClient(apiToken: <api token>)
```

### Validate Token
```swift
client.validateToken {}

// Example 
client.validateToken {
    switch $0 {
        case .success(let response):
            print(response.status)
        case .failure(let error):
            print(error)
    }
}
```
