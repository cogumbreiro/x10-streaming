import x10.util.ArrayList;

public class ClockedReader[T](size:Int, clock:Clock) implements Reader[T] {
    var buffer:ArrayList[T];
    val dbReader:DoubleBuffer.Reader[T];
    var terminated:Boolean = false;
    
    def this(dbReader:DoubleBuffer.Reader[T], size:Int) {
        property(size, dbReader.clock);
        this.dbReader = dbReader;
        this.buffer = new ArrayList[T](size);
    }
    
    public def pop() {
        assert ! isEOF() : "ensure we are not at EOF before calling pop";
        peek(0);
        assert ! isEOF() : "this is an internal error";
        return buffer.removeAt(0);
    }
    
    private def prefetch(count:Int) {
        for (i in 1 .. (count - buffer.size())) {
            val elem = dbReader.getAndCheck();
            if (elem.first) {
                terminated = true;
                break;
            }
            buffer.add(elem.second);
        }
    }
    
    public def peek(idx:Int) {
        assert (0 <= idx) && (idx < size) : "Index out of bounds";
        assert ! isEOF();
        prefetch(idx + 1);
        return buffer.get(idx);
    }
    
    public def isEOF() {
        if (!terminated) prefetch(1); // if empty, get one element from dbuffer
        return terminated && buffer.isEmpty();
    }
}
