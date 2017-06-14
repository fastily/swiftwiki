import Foundation

/**
 Contains static settings constants for swiftwiki.
 - author: Fastily
*/
open class Settings
{
    /**
     The communication protocol.  The default *is* and should *only* be https
    */
    open static let comPro = "https://"
    
    /**
     The useragent which will be supplied with every https request
    */
    open static let useragent = "swiftwiki framework v0.1a - contact -> User:Fastily"
    
    /**
     Toggles debug mode, which will print more details to console
    */
    open static var debug = false
    
    /**
     No initalizers allowed.
    */
    fileprivate init()
    {
    
    }
}
