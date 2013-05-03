/*
float->float pipeline FFTReorder(int n) {

  for(int i=1; i<(n/2); i*= 2)
    add FFTReorderSimple(n/i);

}
*/

public class FFTReorder implements (Clocked)=>void {
    val n:Int;
    def this(n:Int) {this.n = n;}
    public operator this(var in:Clocked[T]) {
        for (i:Int = 1; i<(n/2); i*= 2) {
            val out = Clocked();
            async clocked(in.clock) {
                
            }
            in = Clocked();
        }
    }
   
    
}



