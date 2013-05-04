import x10.util.ArrayList;

public class ClockedInStream[T](size:Int, clock:Clock) implements InStream[T] {
    var buffer:ArrayList[T];
    val clockedValue:Clocked[T];
    
    def this(clockedValue:Clocked[T], size:Int) {
        property(size, clockedValue.clock);
        this.clockedValue = clockedValue;
        this.buffer = new ArrayList[T](size);
    }
    
    public def pop() {
        peek(0);
        return buffer.removeAt(0);
    }
    
    public def peek(idx:Int) {
        for ([i] in idx..buffer.size()) {
            clockedValue.next();
            buffer.add(clockedValue());
        }
        return buffer.get(idx);
    }
}
