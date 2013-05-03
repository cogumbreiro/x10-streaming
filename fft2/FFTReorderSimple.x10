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

class FFTReorderSimple[T] extends Filter[T] implements (Clocked)=>void  {
    val totalData:Int;
    def this(n:Int) {
        this.totalData=2*n;
    }
    public operator this(in:Clocked[T]) {
        val inBuffer = new InStream(in, 2 * n);
        for (var i:Int = 0; i < totalData; i+=4)
        {
            push(inBuffer.peek(i));
            push(inBuffer.peek(i + 1));
        }
        for (var i:Int = 2; i < totalData; i+=4)
        {
            push(inBuffer.peek(i));
            push(inBuffer.peek(i+1));
        }
        
        for (i=0;i<n;i++)
        {
            inBuffer.pop();
            inBuffer.pop();
        }
    }
}









