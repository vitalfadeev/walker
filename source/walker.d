module walker;


/** */
auto walkInDeep( Data )( Data data )
{
    import std.range : chain;

    return chain( [ data ], InDeepIterator!Data( data.childs ) );
}


/** */
auto walkInWidth( Data )( Data data )
{
    import std.range : chain;

    return chain( [ data ], InWidthIterator!Data( data.childs ) );
}


/** */
auto walkPlain( Data )( Data data )
{
    //import std.range : chain;

    //return chain( [ data ], PlainIterator!Data( data.childs ) );
    return data.childs;
}


/** */
struct InDeepIterator( Data )
{
    import std.traits : ReturnType;

    alias ReturnType!( Data.childs ) ChildsRange;

    ChildsRange   _range;
    ChildsRange[] _ranges;


    /** */
    this( ChildsRange range )
    {
        _range = range;
    }


    /** */
    auto front()
    {
        import std.range : front;

        return _range.front;
    }


    /** */
    bool empty()
    {
        import std.range : empty;

        return _range.empty;
    }


    /** */
    void popFront()
    {
        import std.range : back;
        import std.range : empty;
        import std.range : popBack;
        import std.range : popFront;

        // in deep
        if ( tryInChild() )
        {
            // ok
        }
        else // plain. next element
        {
            L0:
            _range.popFront();

            if ( _range.empty )
            {
                // go up
                if ( _ranges.empty )
                {
                    // empty. FINISH
                }
                else
                {
                    // up range
                    _range = _ranges.back;

                    // restore point
                    _ranges.popBack();

                    goto L0;
                }
            }
            else
            {
                // ok
            }
        }
    }


    /** */
    bool tryInChild()
    {
        import std.range : empty;

        //
        auto range = front.childs;

        if ( range.empty )
        {
            return false;
        }
        else
        {
            // save current point
            _ranges ~= _range;
            _range   = range;

            return true;
        }
    }
}


/** */
struct InWidthIterator( Data )
{
    import std.traits : ReturnType;

    alias ReturnType!( Data.childs ) ChildsRange;

    ChildsRange   _range;
    ChildsRange[] _ranges;


    /** */
    this( ChildsRange range )
    {
        _range = range;
    }


    /** */
    auto front()
    {
        import std.range : front;

        return _range.front;
    }


    /** */
    bool empty()
    {
        import std.range : empty;

        return _range.empty;
    }


    /** */
    void popFront()
    {
        import std.range : front;
        import std.range : empty;
        import std.range : popFront;

        // save childs before
        _ranges ~= this.front.childs;

        //
        _range.popFront();

        // in deep
        L1:
        if ( _range.empty )
        {
            // restore childs
            if ( _ranges.empty )
            {
                // FINISH
            }
            else
            {
                // restore childs
                _range = _ranges.front;
                _ranges.popFront();

                goto L1;                
            }
        }
    }
}


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
        DirEntry( r".\a\a3", [] ), ] ), 
        DirEntry( r".\b", [
        DirEntry( r".\b\b1", [] ), 
        DirEntry( r".\b\b2", [] ), 
        DirEntry( r".\b\b3", [] ), ] ), 
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
