import x10.util.concurrent.AtomicBoolean;

abstract class Filter[I,O](clock:Clock, inputCount:Int) implements StreamNode {
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
        //Console.OUT.println(this + ".push(" + value + ")");
        output.writer() = value;
        //Console.OUT.println(this + ".push(" + value + ") <--- DONE");
    }
    
    public def eof():void {
        //Console.OUT.println(this + ".eof()");
        output.writer.close();
        //Console.OUT.println(this + ".eof() <--- DONE");
    }
    
    public def add[T](sink:Filter[O,T]):Filter[O,T] {
        sink.asyncLaunch(output.reader);
        return sink;
    }
    
    public def setReader(reader:ClockedReader[I]) {
        this.reader = reader;
    }
    
    public def setOutput(out:Stream[O]) {
        this.output = out;
    }
    
    protected def createReader(reader:Stream.Reader[I]) {
        return new ClockedReader[I](reader, inputCount);
    }
    
    private def asyncLaunch(bufReader:Stream.Reader[I]) {
        reader = createReader(bufReader);
        async clocked(bufReader.clock, output.clock) {
            launch();
        }
    }
    
    def start() {
        // we are waiting for no one, so we only need one clock
        async clocked(output.clock) {
            work();
            eof();
        }
    }
    
    def launch() {
        //Console.OUT.println("STARTED " + this);
        try {
            while(true) {
                //Console.OUT.println(this + ".work()");
                work();
            }
        } catch (Stream.EOSException) {}
        //Console.OUT.println("SEND EOF " + this);
        eof();
        //Console.OUT.println("ENDED " + this);
    }
    /*
    def launch() {I == Empty} {
        work();
        eof();
    }*/
}

