import Apollo
import SwiftKeychainWrapper

class NetworkManager {
    static let shared = NetworkManager()
    
    let apollo: ApolloClient = {

        let accessToken: String = KeychainWrapper.standard.string(forKey: "token") ?? ""

        let graphEndpoint = "http://localhost:4000/"
        let authPayloads = ["Authorization": "Bearer \(accessToken)"]
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = authPayloads
        let endpointURL = URL(string: graphEndpoint)!
        
        return ApolloClient(
            networkTransport: HTTPNetworkTransport(
                url: endpointURL,
                session: URLSession(configuration: configuration))
        )
    }()
}
