import Foundation

/**
 Miscellaneous String related routines I find myself using repeatedly.
 - author: Fastily
*/
public class FString
{
    /**
     Denotes charset to % escape in data/URLs sent to sever
    */
    private static let escapeCharSet = NSCharacterSet(charactersInString: "/%&=?$#+-~@<>|\\*,.()[]{}^!").invertedSet
    
    /**
     No initializers allowed
    */
    private init()
    {
        
    }
    
    /**
     Encodes a UTF-8 String into a format valid for URLs.
     - parameters:
        - s: The String to encode
     - returns: The URL-encoded string
    */
    public class func enc(s : String) -> String
    {
        return s.stringByAddingPercentEncodingWithAllowedCharacters(FString.escapeCharSet)!
    }
    
    /**
     URLEncodes multiple Strings in Tuples at once.
     - parameters:
        - items: The Strings to encode
     - returns: The list of tuples with URL-encoded strings
    */
    public class func massEnc(items: [(String, String)]) -> [(String, String)]
    {
        var x = [(String, String)]()
        for item in items
        {
            x.append((FString.enc(item.0), FString.enc(item.1)))
        }
        
        print(x)
        return x
    }
}