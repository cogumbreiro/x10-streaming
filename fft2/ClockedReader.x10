import x10.util.ArrayList;

public class ClockedReader[T](size:Int, clock:Clock) implements Reader[T] {
    var buffer:ArrayList[T];
    val dbReader:DoubleBuffer.Reader[T];
    
    def this(dbReader:DoubleBuffer.Reader[T], size:Int) {
        property(size, dbReader.clock);
        this.dbReader = dbReader;
        this.buffer = new ArrayList[T](size);
    }
    
    public def pop() {
        peek(0);
        return buffer.removeAt(0);
    }
    
    public def peek(idx:Int) {
        for ([i] in idx..buffer.size()) {
            buffer.add(dbReader());
        }
        return buffer.get(idx);
    }
}
