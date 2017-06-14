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
    fileprivate init()
    {
        
    }
    
    /**
     Attempts to perform login for a Wiki.  Sets cookies if successful.
     - parameters:
        - wiki: The wiki object to use
     - returns: True on success.
    */
    fileprivate class func login(_ wiki : Wiki) -> Bool
    {
        let ub = wiki.makeUB("login")
        
        var dx = ["lgname", wiki.upx.0]
        let r = Req.post(ub.makeURL(), cookiejar: wiki.cookiejar, contenttype: nil, text: URLBuilder.chainParams(dx))
        
        if r.hasError() || !r.resultIs("NeedToken")
        {
            return false;
        }
        
        dx += ["lgpassword", wiki.upx.1, "lgtoken", r.getStringR("token")!]
        return Req.post(ub.makeURL(), cookiejar : wiki.cookiejar, contenttype: nil, text: URLBuilder.chainParams(dx)).resultIs("Success")
    }
    
    /**
     Fetches namespace list and edit token for a wiki.  Sets edit token and namespace handler if successful.
     - parameters: 
        - wiki: The wiki object to use
     - returns: True on success.
     
    */
    fileprivate class func doSetup(_ wiki : Wiki) -> Bool
    {
        let r = Req.get(wiki.makeUB("query", params: "meta", "tokens", "type", "csrf").makeURL(), cookiejar: wiki.cookiejar)
        
        if let x = r.getStringR("csrftoken")
        {
            wiki.token = x
        }
        
        return wiki.token != "+\\"
    }
    
    /**
     Performs authentication and initialization.
     - parameters:
        - wiki: The wiki object to use
     - returns: True on success.
    */
    internal class func doAuth(_ wiki: Wiki) -> Bool
    {
        return login(wiki) && doSetup(wiki)
    }
}
