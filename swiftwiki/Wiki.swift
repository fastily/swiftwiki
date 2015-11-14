import Foundation

public class Wiki
{
    internal var cookiejar = CookieManager()
    
    internal var upx : (String, String, String)
    
    internal var token : String = "+\\"
    
    public init(_ user : String, px : String, domain: String)
    {
        upx = (user, px, domain)
        Auth.doAuth(self)
    }
    
    public func edit(title : String, text : String, summary : String) -> Bool
    {
        
        let ub = self.makeUB("edit")
        Req.post(ub.makeURL(), cookiejar: cookiejar, contenttype: Req.urlenc, text: URLBuilder.chainParams(FString.massEnc([("title", title), ("appendtext", text), ("summary", summary), ("token", token)])))
        
        
        return true
    }
    
    
    internal func makeUB(action : String, params : (String, String)...) -> URLBuilder
    {
        let ub = URLBuilder(upx.2, action: action)
        ub.setParams(params)
        return ub
    }
}

//TODO: Need method to urlencode post params, otherwise they'll blow up