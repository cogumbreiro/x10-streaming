abstract class Filter[I,O](clock:Clock, inSize:Int) implements StreamNode {
    var isAlive:Boolean = true;
    var inStream:InStream[I];
    val out:Clocked[O];
    
    public def this() {
        this(1);
    }
    
    public def this(inSize:Int) {
        val tmp = new Clocked[O]();
        property(tmp.clock, inSize);
        this.out = tmp;
    }
    
    public def pop():I {
        return inStream.pop();
    }
    
    public def peek(idx:Int):I {
        return inStream.peek(idx);
    }
    
    public def push(value:O) {
        out() = value;
        out.next();
    }
    
    public def eof():void {
        isAlive = false;
    }
    
    public def add[T](sink:Filter[O,T]):Filter[O,T] {
        sink.inStream = new InStream[O](out, sink.inSize);
        async clocked(clock) {
            while(isAlive) {
                sink.work();
            }
        }
        return sink;
    }
    
    def launch() {
        while(isAlive) {
            work();
        }
    }
}
