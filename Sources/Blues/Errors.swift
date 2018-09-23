enum BluesError: Error {
    case deviceNotFound(identifier: String)
    case connectionError(identifier: String)
}
