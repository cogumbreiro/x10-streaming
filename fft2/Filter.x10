import x10.util.concurrent.AtomicBoolean;

public abstract class Filter[I,O](inputCount:Int) {
    private var reader:ClockedReader[I];

    private var output:Stream[O];
    
    public def this() {O haszero} {
        this(1);
    }
    
    public def this(inputCount:Int) {O haszero} {
        this(inputCount, Clock.make());
    }
    
    public def this(inputCount:Int, clock:Clock) {O haszero} {
        this(new Stream[O](clock), inputCount);
    }
    
    public def this(out:Stream[O], inSize:Int) {
        property(out.clock, inSize);
        this.output = out;
    }
    
    public def pop():I {
        return reader.pop();
    }
    
    public def peek(idx:Int):I {
        return reader.peek(idx);
    }
    
    public def push(value:O) {
        output.writer() = value;
    }
    
    public def eof():void {
        output.writer.close();
    }
    
    public def add[T](sink:Filter[O,T]):Filter[O,T] {
        sink.setInput(output.reader);
        sink.asyncLaunch();
        return sink;
    }
    
    public def setOutput(out:Stream[O]) {
        this.output = out;
    }
    
    public def setInput(input:Stream.Reader[I]) {
        this.reader = new ClockedReader[I](reader, inputCount);
    }
    
    protected def asyncLaunch() {
        assert reader != null : "call setInput(reader) first";
        async clocked(bufReader.clock, output.clock) {
            launch();
        }
    }
    
    public def start() {
        // we are waiting for no one, so we only need one clock
        async clocked(output.clock) {
            work();
            eof();
        }
    }
    
    protected def launch() {
        try {
            while(true) {
                work();
            }
        } catch (Stream.EOSException) {}
        eof();
    }
    
    public abstract def work():void;
}

