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
        Console.OUT.println(this + ".pop()");
        //assert ! isEOF() : "ensure we are not at EOF before calling pop";
        peek(0);
        //assert ! isEOF() : "this is an internal error";
        return buffer.removeAt(0);
    }
    
    private def prefetch(count:Int) {
        for (i in 1 .. (count - buffer.size())) {
            buffer.add(dbReader());
        }
    }
    
    public def peek(idx:Int) {
        Console.OUT.println(this + ".peek(" + idx + ")");
        assert (0 <= idx) && (idx < size) : "Index out of bounds";
        //assert ! isEOF();
        prefetch(idx + 1);
        Console.OUT.println(this + ".peek(" + idx + ") == " + buffer.get(idx));
        return buffer.get(idx);
    }
    /*
    public def isEOF() {
        Console.OUT.println(this + ".isEOF()");
        if (!terminated) prefetch(1); // if empty, get one element from dbuffer
        Console.OUT.println(this + ".isEOF() == " + (terminated && buffer.isEmpty()));
        return terminated && buffer.isEmpty();
    }*/
}
