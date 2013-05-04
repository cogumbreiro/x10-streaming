import x10.util.ArrayList;

public interface InStream[T] {
    def pop():T;
    def peek(offset:Int):T;
}
