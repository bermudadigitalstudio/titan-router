import TitanCore

extension Titan {
  /// Core routing handler for Titan Routing.
  /// Passing `nil` for the method results in matching all methods for a given path
  /// Path matching is defined in `matchRoute` method, documented in `docs/Routes.md`
  public func route(method: String? = nil, path: String, handler: @escaping Middleware) {
    let routeWare: Middleware = { (req, res) in
      if let m = method, m.uppercased() != req.method.uppercased() {
        return (req, res)
      }
      guard matchRoute(path: req.path, route: path) else {
        return (req, res)
      }
      return handler(req, res)
    }
    middleware(middleware: routeWare)
  }

  /// Synonym for `route`
  public func middleware(path: String, handler: @escaping Middleware) {
    route(path: path, handler: handler)
  }

}

private func matchRoute(path: String, route: String) -> Bool {
  guard route != "*" else { return true }
  return path == route
}