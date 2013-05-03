class Source[T](clock:Clock) {
    var isAlive:Boolean = true;
    val out:Clocked[T];
    
    def this() {
        val tmp = new Clocked[T]();
        property(tmp.clock);
        this.out = tmp;
    }
    
    def push(value:T) {
        out() = value;
        out.next();
    }
    
    def eof():void {
        isAlive = false;
    }
    
    def createInStream(size:Int):InStream[T] {
        return new InStream[T](out, size);
    }
}
