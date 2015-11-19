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
    
    /**
     Takes a JSONObject from the server
     - parameters:
        - _: The serialized JSON object returned from the server.
     
    */
    private init(_ base : [String : AnyObject])
    {
        self.base = base
    }
    
    /**
     Gets the value associated with a key in a JSONObject
     - parameters:
        - key: The key to search for
     - returns: The value, or nil if there is no value for the specified key
    */
    private func get(key : String) -> AnyObject?
    {
        return base[key]
    }
    
    /**
     Gets the JSONObject associated with a key
     - parameters:
        - key: The key to search for
     - returns: The JSONObject, or nil if there is no value for the specified key
    */
    internal func getJSONObject(key : String) -> Reply?
    {
        if let x = base[key], y = x as? [String :AnyObject]
        {
            return Reply(y)
        }
        return nil
    }
    
    /**
     Gets the String associated with a key
     - parameters:
        - key: The key to search for
     - returns: The String, or nil if there was no value for the specified key
    */
    internal func getString(key : String) -> String?
    {
        if let x = base[key], y = x as? String
        {
            return y
        }
        return nil
    }
    
    /**
     Checks if the given key exists (top level) in the JSONObject
     - parameters:
        - key: The key to search for
     - returns: True if we found a given key in this JSONObject
    */
    internal func has(key : String) -> Bool
    {
        return self.get(key) != nil
    }
}
