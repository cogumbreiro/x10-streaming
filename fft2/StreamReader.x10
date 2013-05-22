import StreamWriter.Entry;

public class StreamReader[T](clock:Clock) implements ()=>T {
    private val cursor:DoubleBuffer[Cell[Entry[T]]];
    private var buffer:Rail[T];
    private var idx:Int;
    private var eos:Boolean = false;
    
    public def this(cursor:DoubleBuffer[Cell[Entry[T]]]) {
        property(cursor.clock);
        this.cursor = cursor;
        this.buffer = cursor.get()().buffer;
        this.idx = buffer.size;
    }
    
    private def this(cursor:DoubleBuffer[Cell[Entry[T]]], idx:Int, eos:Boolean) {
        property(cursor.clock);
        this.cursor = cursor;
        this.buffer = cursor.get()().buffer;
        this.idx = idx;
        this.eos = eos;
    }
    
    public def get() throws EOSException:T {
        if (eos) {
            throw new EOSException();
        }
        assert idx <= buffer.size;
        if (idx == buffer.size) { // it's empty
            fetch();
        }
        return buffer(idx++);
    }
    
    private def fetch() {
        if (cursor.get()().isLast) {
            eos = true;
            throw new EOSException();
        }
        cursor.advance();
        buffer = cursor.get()().buffer;
        idx = 0;
        if (idx == buffer.size) {
            eos = false;
            throw new EOSException();
        }
    }
    
    public operator this():T {
        return get();
    }
    
    public def copy():StreamReader[T] {
        return new StreamReader[T](cursor.copy(), idx, eos);
    }
}

