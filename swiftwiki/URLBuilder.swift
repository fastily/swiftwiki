import Foundation

/**
 Builds a URL with the specified domain. Retains state and is easily modifiable, so it can be used to make multiple,
 similar queries.
 
 - author: Fastily
*/
public class URLBuilder
{
    /**
     The base of the URL, constructed with the domain
    */
    private var base : String
    
    /**
      The parameter list to append to the URL.
     */
    private var pl  = [String:String]()
    
    /**
     Initializer, takes the domain name we'll be working with.
     
     - parameters:
        - domain: The domain name to use, in shorthand (e.g. 'commons.wikimedia.org')
        - action: Sets the action param to use in the final URL. (e.g. query, edit, delete)
    */
    internal init(_ domain : String, action: String)
    {
        base = Settings.comPro + domain + "/w/api.php?format=json&action=" + action
    }

    
    /**
     Sets the params of this object. Note that subsequent calls of this method will not overwrite keys-value pairs that are not named in the passed in parameters.
     
     - parameters:
        - params: The parameters, (key,value) to set object's state with.
    */
    internal func setParams(params : [(String, String)]) -> Void
    {
        for p in params
        {
            pl[p.0] = p.1
        }
    }
    
    /**
     Makes a URL using the current state of the object.
     
     - returns: A URL based off the state of the object
    */
    internal func makeURL() -> NSURL
    {
        var x = [String]()
        
        for (k, v) in pl
        {
            x.append(k)
            x.append(v)
        }
        
        return NSURL(string: base + URLBuilder.chainParams(x))!
    }
    
    /**
      Chains parameters for use in a URL. For example, `["title", "foo", "cmcontinue", "derp"]` results in "`&title=foo&cmcontinue=derp`"
      
     - parameters:
        - params: The array of parameters to chain.
     - returns: The chained properties as a String.
    */
    internal class func chainParams(params : [String]) -> String
    {
        var x = ""
        
        //print(params)
        for var i = 0; i < params.count; i+=2
        {
            x += "&\(params[i])=\(params[i+1])"
        }
        
        return x
    }
}