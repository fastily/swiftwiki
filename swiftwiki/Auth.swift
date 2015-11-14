import Foundation

/**
 Perform wiki authentication and initialization tasks for a Wiki.
 - author: Fastily
*/
internal class Auth
{
    /**
     Initializers disallowed
    */
    private init()
    {
        
    }
    
    /**
     Attempts to perform login for a Wiki.  Sets cookies if successful.
     - parameters:
        - wiki: The wiki object to use
     - returns: True on success.
    */
    private class func login(wiki : Wiki) -> Bool
    {
        let ub = URLBuilder(wiki.upx.2, action: "login")
        var dx = [("lgname", wiki.upx.0)]
        
        var serverreply = Req.post(ub.makeURL(), cookiejar: wiki.cookiejar, contenttype: nil, text: URLBuilder.chainParams(dx))
        
        dx += [("lgpassword", wiki.upx.1), ("lgtoken", serverreply.getJSONObject("login")?.getString("token")! ?? "")]
        serverreply = Req.post(ub.makeURL(), cookiejar : wiki.cookiejar, contenttype: nil, text: URLBuilder.chainParams(dx))
        
        return !serverreply.hasError
    }
    
    /**
     Fetches namespace list and edit token for a wiki.  Sets edit token and namespace handler if successful.
     - parameters: 
        - wiki: The wiki object to use
     - returns: True on success.
     
    */
    private class func doSetup(wiki : Wiki) -> Bool
    {
        let r = Req.get(wiki.makeUB("query", params: ("meta", "tokens"), ("type", "csrf")).makeURL(), cookiejar: wiki.cookiejar)
        
        if let x = r.getJSONObject("query")?.getJSONObject("tokens")?.getString("csrftoken")
        {
            wiki.token = x
        }
        
        return true
    }
    
    /**
     Performs authentication and initialization.
     - parameters:
        - wiki: The wiki object to use
     - returns: True on success.
    */
    internal class func doAuth(wiki: Wiki) -> Bool
    {
        return login(wiki) && doSetup(wiki)
    }
}