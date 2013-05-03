abstract class Sink[T](inSize:Int) implements StreamNode {
    var inStream:InStream[T];
    
    def pop(){
        inStream.pop(0);
    }
}
