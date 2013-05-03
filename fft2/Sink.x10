abstract class Sink[T](inSize:Int) implements StreamNode {
    var inStream:InStream[T];
    
    def pop():T {
        return inStream.pop();
    }
}
