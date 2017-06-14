import Foundation

/**
 Main class for swiftwiki.  Most users will only need this class.
 - author: Fastily
*/
open class Wiki
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
    
    /**
     Edits a page
     - parameters:
        - title: The title to edit
        - text: The text to set the page to
        - summary: The edit summary to use
     - returns: True on success
    */
    open func edit(_ title : String, text : String, summary : String) -> Bool
    {
        
        let ub = makeUB("edit")
        Req.post(ub.makeURL(), cookiejar: cookiejar, contenttype: Req.urlenc, text: URLBuilder.chainParams(FString.massEnc("title", title, "appendtext", text, "summary", summary, "token", token)))
        
        // TODO: Should return correct success value
        return true
    }
    
    /**
     Creates a template URLBuilder with a custom action &amp; params. PRECONDITION: <code>params</code> must be URLEncoded.
     - parameters:
        - action: The action to use
        - params: The params to use.
     - returns: The template URLBuilder
    */
    internal func makeUB(_ action : String, params : String...) -> URLBuilder
    {
        let ub = URLBuilder(upx.2, action: action)
        ub.setParams(params)
        return ub
    }
}
