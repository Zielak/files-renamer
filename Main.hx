
package ;

import sys.io.File;
import sys.io.FileInput;
import sys.FileSystem;

// 
// ./Main /Users/name/Desktop/files2rename /Users/name/Desktop/newFilenames.txt
// 

class Main 
{
    private static var _input:String;
    private static var _arg:Array<String>;

    private static var _dir:String;
    private static var _namesFile:String;
    private static var _pretend:Bool;


    private static var _namesToRemove:Array<Int>;
    private static var _namesNew:Array<String>;
    private static var _namesOld:Array<String>;
    private static var _extensios:Array<String>;

    private static var _file:FileInput;

    public static function main():Void
    {
        parseArguments();

        getNewNames();

        // Get old names and get rid of rubbish
        getOldNames();

        if(_namesOld.length != _namesNew.length){
            Sys.println("Length missmatch!");
            Sys.println('old names: ${_namesOld.length}, new names: ${_namesNew.length}');
            Sys.exit(3);
        }

        // Get extensions
        getExtensions();
        

        // Rename
        var oldName:String;
        var newName:String;
        for (i in 0..._namesOld.length)
        {
            oldName = _dir+"/"+_namesOld[i];
            newName = _dir+"/"+ _namesNew[i] + "_" + (i+1) + "." + _extensios[i];

            if(!_pretend) FileSystem.rename(oldName, newName);
            Sys.println("Renaming: "+ oldName + " -> " + newName);
        }


        // Done.
        if(!_pretend){
            Sys.println("I think I'm done, go check it.");
        }else{
            Sys.println("I didn't do anything, -pretend was on. Check log above to see what I would do.");
        }
        // _input = Sys.stdin().readLine();
        
    }



    private static function parseArguments():Void
    {
        // ARG 1 - path
        // ARG 2 - filenames

        _arg = Sys.args();
        _dir = _arg[0];
        _namesFile = _arg[1];
        _pretend = (_arg[2] == '-pretend') ? true : false;

        // Should have at least 2 parameters
        if(_arg.length < 2)
        {
            Sys.println("Changes all filenames in directory to names from text file.");
            Sys.println("Number of files should match number of lines in text file.");
            Sys.println("Should have at least 2 parameters.");
            Sys.println("  path       : files directory");
            Sys.println("  filenames  : text file with new filenames");
            Sys.println("  -pretend   : see what I would do, don't change filenames");
            Sys.exit(0);
        }

        // exists?
        if( !sys.FileSystem.exists(_dir) ){
            Sys.println("Directory doesn't exist.");
            Sys.exit(1);
        }
        if( !sys.FileSystem.exists(_namesFile) ){
            Sys.println("Names file doesn't exist.");
            Sys.exit(2);
        }
    }

    private static function getNewNames():Void
    {
        // Get all the new names into array
        _file = File.read( _namesFile, false );

        _namesNew = new Array<String>();
        try
        {
            var str:String = "";
            while( !_file.eof() )
            {
                if(!_file.eof()) str = _file.readLine();
                // Sys.println('parsing: ${str}');
                if(str.length>0)
                {
                    // Sys.println('  added: ${str}');
                    _namesNew.push( str );
                }
            }
        }
        catch(e:haxe.io.Eof)
        {
            Sys.println("Looks like EOF.");
        }

        _file.close();
    }


    private static function getOldNames():Void
    {
        // get old filenames
        _namesOld = FileSystem.readDirectory(_dir);

        // Get rid of rubbish
        _namesToRemove = new Array<Int>();
        for (i in 0..._namesOld.length) {
            // Sys.println('${i} - ${_namesOld[i]}');
            if(_namesOld[i].charAt(0) == '.'){
                _namesToRemove.push(i);
            }
        }

        for(i in 0..._namesToRemove.length){
            _namesOld.splice(_namesToRemove[i],1);
        }


        // Sort it
        _namesOld.sort(function(a:String, b:String):Int
        {
            a = a.toLowerCase();
            b = b.toLowerCase();

            // Strip everything but digits
            var r = ~/([^0-9])/g;

            var anum:Int = Std.parseInt( r.replace(a, '') );
            var bnum:Int = Std.parseInt( r.replace(b, '') );

            // Sys.println('   a: ${a} | anum: ${anum}');
            // Sys.println('   b: ${b} | bnum: ${bnum}');

            if (anum < bnum) return -1;
            if (anum > bnum) return 1;
            return 0;
        });
    }


    private static function getExtensions():Void
    {
        _extensios = new Array<String>();
        var pos:Int;
        for(i in 0..._namesOld.length){
            pos = _namesOld[i].lastIndexOf(".");
            if(pos > 0) _extensios.push( _namesOld[i].substr( pos+1 ) );
        }
    }


}
