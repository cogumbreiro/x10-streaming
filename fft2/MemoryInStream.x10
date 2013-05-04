import x10.util.ArrayList;

public class MemoryInStream[T] {
    var buffer:ArrayList[T];
    var idx = 0;
    
    def this(size:Int) {
        property(buffer.size);
        this.clockedValue = clockedValue;
        this.buffer = new ArrayList[T](size);
    }
    
    def setBuffer(buffer:Array[T]) {
        this.size = buffer.size();
        this.buffer = buffer;
    }
    
    def pop() {
        //if (idx >= buffer.size()) {throw new IndexOutOfBoundsException();}
        val result = buffer(idx);
        idx += 1;
        return result;
    }
    
    def peek(offset:Int) {
        //if (idx + offset >= buffer.size()) {throw new IndexOutOfBoundsException();}
        return buffer(idx + offset);
    }
}
