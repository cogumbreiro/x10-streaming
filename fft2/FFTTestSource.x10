/*
void->float filter FFTTestSource(int N) {

  work push 2*N pop 0 {
    int i;
    push(0.0);
    push(0.0);
    push(1.0);
    push(0.0);

    for(i=0; i<2*(N-2); i++)
      push(0.0);
  }
}
*/
public class FFTTestSource extends Source[Float] {
    val N:Int;
    def this(N:Int) { this.N=N;}
    public def work() {
        push(0.0f);
        push(0.0f);
        push(1.0f);
        push(0.0f);
        for (var i:Int=0; i<2*(N-2); i++) {
            push(0.0f);
        }
        eof();
    }
}











