public class StreamWriter[T](clock:Clock) {
    public static struct Entry[T](isLast:Boolean, buffer:Rail[T]){
        public static def make[T](buffer:Rail[T]) = new Entry[T](false, buffer);
        public static def makeLast[T](buffer:Rail[T]) = new Entry[T](true, buffer);
    }
    
    private val cursor:DoubleBuffer[Cell[Entry[T]]];
    private var buffer:Rail[T];
    private var eos:Boolean = false;
    private var idx:Int = 0;
    
    public def this(cursor:DoubleBuffer[Cell[Entry[T]]]) {
        property(cursor.clock);
        this.cursor = cursor;
        this.buffer = cursor.get()().buffer;
    }

    public operator this()=(value:T) {
        set(value);
    }
    
    public def set(value:T):void {
        if (eos) throw new EOSException();
        buffer(idx) = value;
        idx += 1;
        if (idx == buffer.size) {
            cursor.advance();
            this.buffer = cursor.get()().buffer;
            idx = 0;
        }
        assert idx < buffer.size; 
    }
    
    public def close():void {
        eos = true;
        assert idx <= buffer.size;
        if (idx < buffer.size) {
            val newBuffer = new Rail[T](idx, (x:Int) => buffer(x));
            cursor.get()() = Entry.makeLast[T](newBuffer);
        } else {
            cursor.get()() = Entry.makeLast[T](buffer);
        }
        cursor.advance();
    }
}

