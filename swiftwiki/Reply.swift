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
    
    /**
     Internal flag indicating if we found any preliminary errors.
    */
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
        return base.keys.contains(key)
    }
    
    /**
     Recursively search this Reply for a key, and return an AnyObject (if any) for the first instance of it.
     - parameters:
        - jo: The JSONObject (Reply) to search
        - key: The key to look for
     - returns: The first AnyObject associated with the specified key, or nil if we didn't find the key.
    */
    private class func getR(jo : Reply?, key : String) -> AnyObject?
    {
        
        if jo == nil //base case
        {
            return nil
        }
        
        /*if jo!.has(key) // simple case
        {
            return jo!.base[key]
        }*/
        
        if let v = jo!.base[key] // simple case
        {
            return v
        }
        
        for k in jo!.base.keys //recurse
        {
            let x = Reply.getR(jo!.getJSONObject(k), key : key )
            if x != nil
            {
                return x
            }
        }
        
        return nil
    }
    
    /**
     Recursively search this Reply for a key, and return a JSONObject (if any) for the first instance of it.
     - parameters:
        - key: The key to look for.
     - returns: A JSONObject, or nil if the key with a JSONObject doesn't exist.
    */
    internal func getJSONObjectR(key : String) -> Reply?
    {
        return Reply.getR(self, key: key) as? Reply
    }
    
    /**
     Recursively search this Reply for a String, and return a String (if any) for the first instance of it.
     - parameters:
        - key: The key to look for
     - returns: A String, or nil if the key with a String doesn't exist.
    */
    internal func getStringR(key : String) -> String?
    {
        return Reply.getR(self, key: key) as? String
    }
}
