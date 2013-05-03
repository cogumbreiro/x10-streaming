/*
float->float pipeline FFTReorder(int n) {

  for(int i=1; i<(n/2); i*= 2)
    add FFTReorderSimple(n/i);

}
*/

public class FFTReorder(n:Int)  {
    def pipeline[T]():Filter[T,T]{} {
        var filter:Filter[T,T] = null;
        for (var i:Int = 1; i<(n/2); i*= 2) {
            filter = filter.add(new FFTReorderSimple[T](n/i));
        }
        assert filter != null;
        return filter;
    }
}



