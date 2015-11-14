import Foundation

/**
 Represents a reply from the server. A reply from the server is a JSONObject, and this class contains getters for that data as well as some basic error status checking
 
 - author: Fastily
*/
public class Reply
{
    /**
     The JSONObject backing this Reply wrapper
    */
    private var base = [String : AnyObject]()
    
    internal var hasError = false
    
    /**
     Initializer, takes and interprets a JSON reply from the server.
    */
    internal init(_ data : NSData?)
    {
        if let d = data, x = try? NSJSONSerialization.JSONObjectWithData(d, options:NSJSONReadingOptions.MutableContainers) as! [String : AnyObject]
        {
            base = x
            
            if self.has("error")
            {
                hasError = true
            }
            if Settings.debug
            {
                print(base)
            }
        }
    }
    
    private init(_ base : [String : AnyObject])
    {
        self.base = base
    }
    
    private func get(key : String) -> AnyObject?
    {
        return base[key]
    }
    
    internal func getJSONObject(key : String) -> Reply?
    {
        if let x = base[key], y = x as? [String :AnyObject]
        {
            return Reply(y)
        }
        return nil
    }
    
    internal func getString(key : String) -> String?
    {
        if let x = base[key], y = x as? String
        {
            return y
        }
        return nil
    }
    
    internal func has(key : String) -> Bool
    {
        return self.get(key) != nil
    }
    
}
