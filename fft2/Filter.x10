public class Filter[T] {
    val out = new Clocked[T]();
    def push(value:T) {
        out() = value;
        out.next();
    }
}
