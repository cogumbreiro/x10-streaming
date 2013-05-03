class SourceReader[T] {
    var isAlive:Boolean = false;
    val out = new Clocked[T]();
    def push(value:T) {
        out() = value;
        out.next();
    }
}
