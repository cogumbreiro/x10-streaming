import x10.util.ArrayList;

public class InStream[T](size:Int, clock:Clock) {
    var buffer:ArrayList[T];
    val clockedValue:Clocked[T];
    
    def this(clockedValue:Clocked[T], size:Int) {
        property(size, clockedValue.clock);
        this.clockedValue = clockedValue;
        this.buffer = new ArrayList[T](size);
    }
    
    def pop() {
        peek(0);
        return buffer.removeAt(0);
    }
    
    def peek(idx:Int) {
        for ([i] in idx..buffer.size()) {
            clockedValue.next();
            buffer.add(clockedValue());
        }
        return buffer.get(idx);
    }
}
