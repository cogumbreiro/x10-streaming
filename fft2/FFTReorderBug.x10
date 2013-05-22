/*
float->float pipeline FFTReorder(int n) {

  for(int i=1; i<(n/2); i*= 2)
    add FFTReorderSimple(n/i);

}
*/

public class FFTReorder[T](n:Int) implements [T](Filter[T,T])=>void {
    public operator this():Filter[T,T] {
        var filter:Filter[T,T];
        for (i:Int = 1; i<(n/2); i*= 2) {
            val curr = new FFFTReorderSimple(n/i);
            filter.add(curr);
            filter = curr;
        }
        return filter;
    }
   
    
}



