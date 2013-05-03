abstract class Filter[I,O](clock:Clock, inSize:Int) implements StreamNode {
    var isAlive:Boolean = true;
    var inStream:InStream[I];
    val out:Clocked[O];
    
    def pop():I {
        return inStream.pop();
    }
    
    def this() {
        this(1);
    }
    
    def this(inSize:Int) {
        val tmp = new Clocked[O]();
        property(tmp.clock, inSize);
        this.out = tmp;
    }
    
    def push(value:O) {
        out() = value;
        out.next();
    }
    
    def eof():void {
        isAlive = false;
    }
    
    def add[T](sink:Filter[O,T]) {
        sink.inStream = new InStream[O](out, sink.inSize);
        async clocked(clock) {
            while(isAlive) {
                sink.work();
            }
        }
    }
    
    def launch() {
        while(isAlive) {
            work();
        }
    }
}
