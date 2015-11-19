import Foundation

/**
 CookieManager which manages cookies for each Wiki instance
 - author: Fastily
*/
public class CookieManager
{
    /**
     The backing data structure for the cookie manager.  Scheme: [domain : [name : value]]
    */
    internal var base = [String : [String : String]]()
    
    /**
     Initialization restricted to internal
    */
    internal init()
    {
        
    }
    
    /**
     Adds cookies to the CookieManager.  If the specified domain does not yet exist in the CookieManager, then it will be created.
     - parameters: 
        - domain: The domain (in shorthand: e.g. 'commons.wikimedia.org') where these cookies were returned from
        - cookies: The list of cookies to add to this cookiejar.  Note that `domain` will be ignored
    */
    internal func add(domain : String, cookies : [NSHTTPCookie])
    {
        if !self.hasDomain(domain)
        {
            base[domain] = [String : String]()
        }
        
        for cookie in cookies
        {
            base[domain]![cookie.name] = cookie.value
        }
    }
    
    /**
     Checks if the specified domain exists for this CookieManager
     - parameters:
        - domain: The domain to check
     - returns: True if the domain exists for this CookieManager.
    */
    internal func hasDomain(domain : String) -> Bool
    {
        return base[domain] != nil
    }
    
    
    /**
     Gets cookies for the specified domain in a format friendly to the `Set-Cookie:` https header
     - parameters:
        - domain: The domain to fetch the cookie string for
     - returns: The cookies as a String
    */
    internal func getCookieString(domain : String) -> String
    {
        var x = ""
        
        for cookie in base[domain]!
        {
            x += "\(cookie.0)=\(cookie.1);"
        }
        
        return x
    }
}