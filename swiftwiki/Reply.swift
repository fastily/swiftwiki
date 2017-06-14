import Foundation

/**
 Represents a reply from the server. A reply from the server is a JSONObject, and this class contains getters for that data as well as some basic error status checking
 
 - author: Fastily
*/
open class Reply
{
    /**
     Result strings which should not be tagged as errors.
    */
    fileprivate static let whitelist = ["NeedToken", "Success", "Continue"]
    
    /**
     The JSONObject backing this Reply wrapper
    */
    fileprivate var base = [String : AnyObject]()
    
    /**
     The result param of the query/action, if one was returned by the server.
    */
    fileprivate var result : String?
    
    /**
     The error code returned by the server, if one was returned.
    */
    fileprivate var errcode: String?
    
    /**
     Initializer, takes and interprets a JSON reply from the server.
    */
    internal init(_ data : Data?)
    {
        if let d = data, let x = try? JSONSerialization.jsonObject(with: d, options:JSONSerialization.ReadingOptions.mutableContainers) as! [String : AnyObject]
        {
            base = x
            
            result = getStringR("result")
            
            if has("error")
            {
                errcode = getStringR("code")
                print("[ ERROR ]: \(getJSONObjectR("error")?.base)")
            }
            else if result != nil && !Reply.whitelist.contains(result!)
            {
                errcode = result;
                print("[ ERROR ]: RESULT = \(base)")
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
    fileprivate init(_ base : [String : AnyObject])
    {
        self.base = base
    }
    
    /**
     Gets the JSONObject associated with a key
     - parameters:
        - key: The key to search for
     - returns: The JSONObject, or nil if there is no value for the specified key
    */
    internal func getJSONObject(_ key : String) -> Reply?
    {
        if let x = base[key], let y = x as? [String :AnyObject]
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
    internal func getString(_ key : String) -> String?
    {
        if let x = base[key], let y = x as? String
        {
            return y
        }
        return nil
    }
    
    /**
     Gets the JSONArray associated with a key
     - parameters:
        - key: The key to search for
     - returns: The JSONARray, or nil if there was no value for the specified key
    */
    internal func getJSONArray(_ key : String) -> [AnyObject]?
    {
        if let x = base[key], let y = x as? [AnyObject]
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
    internal func has(_ key : String) -> Bool
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
    fileprivate class func getR(_ jo : Reply?, key : String) -> AnyObject?
    {
        if jo == nil //base case
        {
            return nil
        }
        else if let v = jo!.base[key] // simple case
        {
            return v
        }
        
        for k in jo!.base.keys //recurse
        {
            if let x = Reply.getR(jo!.getJSONObject(k), key: key)
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
    internal func getJSONObjectR(_ key : String) -> Reply?
    {
        return Reply.getR(self, key: key) as? Reply
    }
    
    /**
     Recursively search this Reply for a String, and return a String (if any) for the first instance of it.
     - parameters:
        - key: The key to look for
     - returns: A String, or nil if the key with a String doesn't exist.
    */
    internal func getStringR(_ key : String) -> String?
    {
        return Reply.getR(self, key: key) as? String
    }
    
    /**
     Recursively search this Reply for a String, and return a String (if any) for the first instance of it.
     - parameters:
        - key: The key to look for
     - returns: A JSONArray, or nil if the key with a JSONArray doesn't exist.
    */
    internal func getJSONArrayR(_ key : String) -> [AnyObject]?
    {
        return Reply.getR(self, key : key) as? [AnyObject]
    }
    
    /**
     Checks if an error was returned by the server in this Reply.
     - returns: True if there was an error.
    */
    open func hasError() -> Bool
    {
        return errcode != nil
    }
    
    /**
     Determines if this Reply's result code matches the specified code.
     - parameters:
        - code: The code to check against this Reply's result code.
     - returns: True if the specified code matches this Reply's result code.
    */
    open func resultIs(_ code : String) -> Bool
    {
        return code == result
    }
}
