import Foundation

/**
 Main class for swiftwiki.  Most users will only need this class.
 - author: Fastily
*/
public class Wiki
{
    /**
     The internal cookie manager for this object
    */
    internal var cookiejar = CookieManager()
    
    /**
      User, pwd, domain
    */
    internal var upx : (String, String, String)
    
    /**
     Our edit/csrf token
    */
    internal var token : String = "+\\"
    
    /**
     Initializes a Wiki object, attempts to log the user in and set tokens.
     - parameters: 
        - _ : The user's username on the Wiki
        - px: The user's password
        - domain: The Wiki's domain, in shorthand style (e.g. en.wikipedia.org)
    */
    public init(_ user : String, px : String, domain: String)
    {
        upx = (user, px, domain)
        Auth.doAuth(self)
    }
    
    public func edit(title : String, text : String, summary : String) -> Bool
    {
        
        let ub = self.makeUB("edit")
        Req.post(ub.makeURL(), cookiejar: cookiejar, contenttype: Req.urlenc, text: URLBuilder.chainParams(FString.massEnc("title", title, "appendtext", text, "summary", summary, "token", token)))
        
        
        return true
    }
    
    
    internal func makeUB(action : String, params : (String, String)...) -> URLBuilder
    {
        let ub = URLBuilder(upx.2, action: action)
        ub.setParams(params)
        return ub
    }
}