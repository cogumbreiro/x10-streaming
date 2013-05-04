import x10.util.ArrayList;

public interface Reader[T] {
    def pop():T;
    def peek(offset:Int):T;
}
