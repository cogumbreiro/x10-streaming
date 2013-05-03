public class OutStream[T] {
    val clock:Clocked[T];
    def this(clock:Clocked[T]) {
        this.clock = clock;
    }
    def push(value:T) {
        clock() = value;
        clock.next();
    }
}
