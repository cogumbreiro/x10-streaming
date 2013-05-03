import x10.util.ArrayList;

public class InStream[T](size:Int) {
    var buffer:ArrayList[T];
    val clock:Clocked[T];
    
    def this(clock:Clocked[T], size:Int) {
        property(size);
        this.clock = clock;
        this.buffer = new ArrayList[T](size);
    }
    
    def pop() {
        peek(0);
        return buffer.removeAt(0);
    }
    
    def peek(idx:Int) {
        for ([i] in idx..(buffer.size())) {
            buffer.add(clock());
            clock.next();
        }
        return buffer.get(idx);
    }
}
