# walker
walking on tree: in deep, in width, plain

```
///
unittest
{
    import std.algorithm : map;
    import std.stdio     : writeln;
    import std.path      : dirName;
    import std.array     : array;
    import std.array     : join;
    import walker        : walkInDeep;
    import walker        : walkInWidth;
    import walker        : walkPlain;


    struct DirEntry
    {
        string name;
        DirEntry[] _childs;

        auto childs()
        {
            return _childs;
        }
    }


    auto data = 
        DirEntry( r".", [ 
        DirEntry( r".\a", [
        DirEntry( r".\a\a1", [] ), 
        DirEntry( r".\a\a2", [] ), 
        DirEntry( r".\a\a3", [] ), 
        ] ), 
        DirEntry( r".\b", [
        DirEntry( r".\b\b1", [] ), 
        DirEntry( r".\b\b2", [] ), 
        DirEntry( r".\b\b3", [] ), 
        ] ), 
        DirEntry( r".\c", [
        DirEntry( r".\c\c1", [] ), 
        DirEntry( r".\c\c2", [] ), 
        DirEntry( r".\c\c3", [] ), 
        ] ), 
    ] );


    // in depth
    auto iter = walkInDeep( data );
    assert( iter.map!"a.name".array == [ 
        r".", 
        r".\a", 
        r".\a\a1", 
        r".\a\a2", 
        r".\a\a3", 
        r".\b", 
        r".\b\b1", 
        r".\b\b2", 
        r".\b\b3", 
        r".\c", 
        r".\c\c1", 
        r".\c\c2", 
        r".\c\c3"
    ] );

    // in width
    auto iter2 = walkInWidth( data );
    assert( iter2.map!"a.name".array == [ 
        r".", 
        r".\a", 
        r".\b", 
        r".\c", 
        r".\a\a1", 
        r".\a\a2", 
        r".\a\a3", 
        r".\b\b1", 
        r".\b\b2", 
        r".\b\b3", 
        r".\c\c1", 
        r".\c\c2", 
        r".\c\c3"
    ] );

    // plain
    auto iter3 = walkPlain( data );
    assert( iter3.map!"a.name".array == [ 
        r".\a", 
        r".\b", 
        r".\c", 
    ] );
}
```
