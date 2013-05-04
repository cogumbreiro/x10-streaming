abstract class Filter[I,O](clock:Clock, inSize:Int) implements StreamNode {
    private var isAlive:Boolean = true;
    private var inStream:InStream[I];
    private val out:Clocked[O];
    
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
    
    public def isAlive():Boolean {
        return isAlive;
    }
    
    public def add[T](sink:Filter[O,T]):Filter[O,T] {
        sink.launch(out, this);
        return sink;
    }
    
    public def launch(inValues:Clocked[I], parent:StreamNode) {
        inStream = new ClockedInStream[I](inValues, inSize);
        async clocked(inValues.clock) {
            while(parent.isAlive()) {
                work();
            }
            eof();
        }
    }
    
    def launch() {
        while(isAlive) {
            work();
        }
    }
}
