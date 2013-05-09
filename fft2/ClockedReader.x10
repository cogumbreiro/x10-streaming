import x10.util.ArrayList;

public class ClockedReader[T](size:Int, clock:Clock) implements Reader[T] {
    var buffer:ArrayList[T];
    val dbReader:Stream.Reader[T];
    var terminated:Boolean = false;
    
    public def this(dbReader:Stream.Reader[T], size:Int) {
        property(size, dbReader.clock);
        this.dbReader = dbReader;
        this.buffer = new ArrayList[T](size);
    }
    
    public def pop() {
        peek(0);
        return buffer.removeAt(0);
    }
    
    private def prefetch(count:Int) {
        for (i in 1 .. (count - buffer.size())) {
            buffer.add(dbReader());
        }
    }
    
    public def peek(idx:Int) {
        assert (0 <= idx) && (idx < size) : "Index out of bounds";
        prefetch(idx + 1);
        return buffer.get(idx);
    }
}
