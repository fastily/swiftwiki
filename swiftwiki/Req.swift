import Foundation

/**
 The internal semaphore that makes synchronous network calls possible for this file
*/
private var sem = dispatch_semaphore_create(0)

/**
  Class with static methods that make network calls
 
 - author: Fastily
 */
public class Req
{
    
    /**
     Content encoding to use for URLEncoded forms.
    */
    public static let urlenc = "application/x-www-form-urlencoded"
    
    /**
     Initializers not allowed
    */
    private init()
    {
        
    }
    
    /**
     Convinience method to grab cookies from a server reply.
     - parameters:
        - response: The reply from the server
        - url: The URL the reply was recieved from
        - cookiejar: The cookiejar to apply (if applicable) new cookies to
    */
    private class func grabCookies(response : NSHTTPURLResponse, url : NSURL, cookiejar : CookieManager)
    {
        cookiejar.add(url.host!, cookies: NSHTTPCookie.cookiesWithResponseHeaderFields((response.allHeaderFields as? [String : String])!, forURL: response.URL!))
    }
    
    
    /**
     Creates a basic URLRequest template.  Sets HTML headers and applicable cookies.
     - parameters:
        - url: The URL to make a request to
        - cookiejar: The cookiejar to use.  Optional, set nil to disable
     - returns: An NSMUtableRequest with the specified parameters.
    
    */
    private class func makeGenericURLRequest(url : NSURL, cookiejar : CookieManager?) -> NSMutableURLRequest
    {
        let c = NSMutableURLRequest(URL: url)
        c.addValue(Settings.useragent, forHTTPHeaderField: "User-Agent")
        c.addValue("keep-alive", forHTTPHeaderField: "Connection")
        
        if cookiejar != nil && cookiejar!.hasDomain(url.host!)
        {
            c.addValue(cookiejar!.getCookieString(url.host!), forHTTPHeaderField: "Cookie")
        }
        
        return c
    }
    
    /**
     Creates a basic POST request template
     - parameters:
        - url: the URL to POST
        - cookiejar: The cookiejar to use.  Optional, set nil to disable
        - contenttype: The contenttype header to use, set nil to disable
     - returns: An NSMUtableRequest with the specified parameters.
    */
    private class func makePost(url : NSURL, cookiejar : CookieManager?, contenttype : String?) -> NSMutableURLRequest
    {
        let c = Req.makeGenericURLRequest(url, cookiejar: cookiejar)
        
        c.HTTPMethod = "POST"
        if contenttype != nil
        {
            c.addValue(contenttype!, forHTTPHeaderField: "Content-Type")
        }
        
        return c
    }
    
    /**
     Attempts to do a generic POST to a URL
     - parameters:
        - url: The URL to POST
        - cookiejar: The cookiejar to use.  Optional, set nil to disable
        - contenttype: The contenttype header to use, set nil to disable
        - text: The text to post
     - returns The reply from the server, or nil if something went wrong.
    */
    public class func genericPOST(url : NSURL, cookiejar : CookieManager?, contenttype : String?, text : String) -> NSData?
    {
        let c = Req.makePost(url, cookiejar: cookiejar, contenttype: contenttype)
        c.HTTPBody = text.dataUsingEncoding(NSUTF8StringEncoding)
        
        return Req.doReq(c, cookiejar: cookiejar)
    }
    
    
    /**
     Attempts to do a POST for a Wiki.
     
     - parameters:
        - url: The URL request
        - cookiejar: The cookiejar to use
        - contenttype: An optional contenttype
        - text: The text to post
     - returns: A Reply object representing the reply from the server, or an empty Reply object if something went wrong.
    */
    internal class func post(url : NSURL, cookiejar : CookieManager, contenttype: String?, text : String) -> Reply
    {
        return Reply(Req.genericPOST(url, cookiejar: cookiejar, contenttype: contenttype, text: text))
    }
    
    /**
     Performs a generic GET request on a URL
     - parameters:
        - url: The URL to GET
        - cookiejar: The cookiejar to use.  Optional, set nil to disable
     - returns: NSData from the server, or nil if something went wrong
    */
    public class func genericGET(url : NSURL, cookiejar : CookieManager?) -> NSData?
    {
        return Req.doReq(Req.makeGenericURLRequest(url, cookiejar: cookiejar), cookiejar: cookiejar)
    }
    
    /**
     Performs a GET request to a Wiki
     
     - parameters:
        - url: The URL to GET
        - cookiejar: The cookiejar to use
     - returns: A Reply from the server.
    */
    internal class func get(url : NSURL, cookiejar: CookieManager) -> Reply
    {
        return Reply(Req.genericGET(url, cookiejar: cookiejar))
    }
    
    
    /**
     Does a synchronous https request and returns the result
     
     - parameters:
       - req: The url request
     - returns: The JSONObject reply from the server
    */
    
    internal class func doReq(req: NSMutableURLRequest, cookiejar : CookieManager?) -> NSData?
    {
        var reply : NSData?
        NSURLSession.sharedSession().dataTaskWithRequest(req, completionHandler: { data, response, error in
            
            if cookiejar != nil
            {
                Req.grabCookies(response as! NSHTTPURLResponse, url: req.URL!, cookiejar: cookiejar!)
            }
            
            reply = data
            
            dispatch_semaphore_signal(sem)
        }).resume()
        
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER)
        
        return reply
    }
}

//x = String(data: data!, encoding: NSUTF8StringEncoding)!