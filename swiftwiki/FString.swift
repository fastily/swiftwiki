import Foundation

/**
 Miscellaneous String related routines I find myself using repeatedly.
 - author: Fastily
*/
open class FString
{
    /**
     Denotes charset to % escape in data/URLs sent to sever
    */
    fileprivate static let escapeCharSet = CharacterSet(charactersIn: "/%&=?$#+-~@<>|\\*,.()[]{}^!").inverted
    
    /**
     No initializers allowed
    */
    fileprivate init()
    {
        
    }
    
    /**
     Encodes a UTF-8 String into a format valid for URLs.
     - parameters:
        - s: The String to encode
     - returns: The URL-encoded string
    */
    open class func enc(_ s : String) -> String
    {
        return s.addingPercentEncoding(withAllowedCharacters: FString.escapeCharSet)!
    }
    
    /**
     URLEncodes a list of Strings
     - parameters:
        - items: The Strings to encode
     - returns: The list of encoded Strings, in the same order they were passed in.
    */
    open class func massEnc(_ items: String...) -> [String]
    {
        var x = [String]()
        for item in items
        {
            x.append(FString.enc(item))
        }
        
        //print(x)
        return x
    }
}
