import x10.util.ArrayList;

public class MemoryReader[T](size:Int) implements Reader[T] {
    val buffer:Array[T];
    var idx:Int = 0;
    
    def this(buffer:Array[T]) {
        property(buffer.size);
        this.buffer = buffer;
    }
    
    public def pop() {
        val result = buffer(idx);
        idx += 1;
        return result;
    }
    
    public def peek(offset:Int) {
        return buffer(idx + offset);
    }
}
