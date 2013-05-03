/*
float->float filter FFTReorderSimple(int n) {

  int totalData;

  init {
    totalData = 2*n; 
  }

  work push 2*n pop 2*n {
        int i;
        
        for (i = 0; i < totalData; i+=4)
        {
            push(peek(i));
            push(peek(i+1));
        }
        
        for (i = 2; i < totalData; i+=4)
        {
            push(peek(i));
            push(peek(i+1));
        }
        
        for (i=0;i<n;i++)
        {
            pop();
            pop();
        }
    }
}
*/

class FFTReorderSimple[T](n:Int) extends Filter[T,T] {
    val totalData:Int;
    def this(n:Int) {
        super(2*n);
        property(n);
        totalData = 2*n;
    }
    public def work() {
        for (var i:Int = 0; i < totalData; i+=4)
        {
            push(peek(i));
            push(peek(i + 1));
        }
        for (var i:Int = 2; i < totalData; i+=4)
        {
            push(peek(i));
            push(peek(i+1));
        }
        
        for (var i:Int=0;i<n;i++)
        {
            pop();
            pop();
        }
    }
}









