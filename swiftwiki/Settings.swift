import Foundation

/**
 Contains static settings constants for swiftwiki.
 - author: Fastily
*/
public class Settings
{
    /**
     The communication protocol.  The default *is* and should *only* be https
    */
    public static let comPro = "https://"
    
    /**
     The useragent which will be supplied with every https request
    */
    public static let useragent = "swiftwiki framework v0.1a - contact -> User:Fastily"
    
    /**
     Toggles debug mode, which will print more details to console
    */
    public static var debug = false
    
    /**
     No initalizers allowed.
    */
    private init()
    {
    
    }
    
}