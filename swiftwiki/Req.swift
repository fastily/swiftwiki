import Foundation

/**
 The internal semaphore that makes synchronous network calls possible for this file
*/
private var sem = DispatchSemaphore(value: 0)

/**
  Class with static methods that make network calls
 
 - author: Fastily
 */
open class Req
{
    
    /**
     Content encoding to use for URLEncoded forms.
    */
    open static let urlenc = "application/x-www-form-urlencoded"
    
    /**
     Initializers not allowed
    */
    fileprivate init()
    {
        
    }
    
    /**
     Convinience method to grab cookies from a server reply.
     - parameters:
        - response: The reply from the server
        - url: The URL the reply was recieved from
        - cookiejar: The cookiejar to apply (if applicable) new cookies to
    */
    fileprivate class func grabCookies(_ response : HTTPURLResponse, url : URL, cookiejar : CookieManager)
    {
        cookiejar.add(url.host!, cookies: HTTPCookie.cookies(withResponseHeaderFields: (response.allHeaderFields as? [String : String])!, for: response.url!))
    }
    
    
    /**
     Creates a basic URLRequest template.  Sets HTML headers and applicable cookies.
     - parameters:
        - url: The URL to make a request to
        - cookiejar: The cookiejar to use.  Optional, set nil to disable
     - returns: An NSMUtableRequest with the specified parameters.
    
    */
    fileprivate class func makeGenericURLRequest(_ url : URL, cookiejar : CookieManager?) -> NSMutableURLRequest
    {
        let c = NSMutableURLRequest(url: url)
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
    fileprivate class func makePost(_ url : URL, cookiejar : CookieManager?, contenttype : String?) -> NSMutableURLRequest
    {
        let c = Req.makeGenericURLRequest(url, cookiejar: cookiejar)
        
        c.httpMethod = "POST"
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
    open class func genericPOST(_ url : URL, cookiejar : CookieManager?, contenttype : String?, text : String) -> Data?
    {
        let c = Req.makePost(url, cookiejar: cookiejar, contenttype: contenttype)
        c.httpBody = text.data(using: String.Encoding.utf8)
        
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
    internal class func post(_ url : URL, cookiejar : CookieManager, contenttype: String?, text : String) -> Reply
    {
        return Reply(Req.genericPOST(url, cookiejar: cookiejar, contenttype: contenttype, text: text) as! NSData)
    }
    
    /**
     Performs a generic GET request on a URL
     - parameters:
        - url: The URL to GET
        - cookiejar: The cookiejar to use.  Optional, set nil to disable
     - returns: NSData from the server, or nil if something went wrong
    */
    open class func genericGET(_ url : URL, cookiejar : CookieManager?) -> Data?
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
    internal class func get(_ url : URL, cookiejar: CookieManager) -> Reply
    {
        return Reply(Req.genericGET(url, cookiejar: cookiejar) as! NSData)
    }
    
    
    /**
     Does a synchronous https request and returns the result
     
     - parameters:
       - req: The url request
     - returns: The JSONObject reply from the server
    */
    
    internal class func doReq(_ req: NSMutableURLRequest, cookiejar : CookieManager?) -> Data?
    {
        var reply : Data?
        URLSession.shared.dataTask(with: req, completionHandler: { data, response, error in
            
            if let cjar = cookiejar
            {
                Req.grabCookies(response as! HTTPURLResponse, url: req.url!, cookiejar: cjar)
            }
            
            reply = data
            
            sem.signal()
        }).resume()
        
        sem.wait(timeout: DispatchTime.distantFuture)
        
        return reply
    }
}

//x = String(data: data!, encoding: NSUTF8StringEncoding)!
