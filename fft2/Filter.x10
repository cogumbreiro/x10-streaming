abstract class Filter[I,O](clock:Clock, inSize:Int) implements StreamNode {
    private var isAlive:Boolean = true;
    private var reader:Reader[I];
    private val out:DoubleBuffer[O];
    
    public def this() {O haszero} {
        this(1);
    }
    
    public def this(inSize:Int) {O haszero} {
        val tmp = new DoubleBuffer[O]();
        property(tmp.clock, inSize);
        this.out = tmp;
    }
    
    public def pop():I {
        return reader.pop();
    }
    
    public def peek(idx:Int):I {
        return reader.peek(idx);
    }
    
    public def push(value:O) {
        out.writer() = value;
    }
    
    public def eof():void {
        isAlive = false;
    }
    
    public def isAlive():Boolean {
        return isAlive;
    }
    
    public def add[T](sink:Filter[O,T]):Filter[O,T] {T haszero} {
        sink.launch(out, this);
        return sink;
    }
    
    public def setReader(reader:Reader[I]) {
        this.reader = reader;
    }
    
    public def launch(inValues:DoubleBuffer[I], parent:StreamNode) {
        reader = new ClockedReader[I](inValues.reader, inSize);
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
