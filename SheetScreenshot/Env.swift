import Foundation

public enum Env {

    public static var isUnitTest: Bool = {
        #if DEBUG
            ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
        #else
            false
        #endif
    }()


}
