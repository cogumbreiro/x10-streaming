/*
float->float filter CombineDFT(int n) {

  // coefficients, real and imaginary interleaved
  float[n] w;

  init {
      float wn_r = (float)cos(2 * 3.141592654 / n);
      float wn_i = (float)sin(-2 * 3.141592654 / n);
      float real = 1;
      float imag = 0;
      float next_real, next_imag;
      for (int i=0; i<n; i+=2) {
	  w[i] = real;
	  w[i+1] = imag;
	  next_real = real * wn_r - imag * wn_i;
	  next_imag = real * wn_i + imag * wn_r;
	  real = next_real;
	  imag = next_imag;
      }
  }

  work push 2*n pop 2*n {
        int i;
	float[2*n] results;

        for (i = 0; i < n; i += 2)
        {
	    // this is a temporary work-around since there seems to be
	    // a bug in field prop that does not propagate nWay into the
	    // array references.  --BFT 9/10/02
	    
	    //int tempN = nWay;
	    //Fixed --jasperln
            
            // removed nWay, just using n  --sitij 9/26/03

	    int i_plus_1 = i+1;

	    float y0_r = peek(i);
            float y0_i = peek(i_plus_1);
            
	    float y1_r = peek(n + i);
            float y1_i = peek(n + i_plus_1);

	    // load into temps to make sure it doesn't got loaded
	    // separately for each load
	    float weight_real = w[i];
	    float weight_imag = w[i_plus_1];

            float y1w_r = y1_r * weight_real - y1_i * weight_imag;
            float y1w_i = y1_r * weight_imag + y1_i * weight_real;

            results[i] = y0_r + y1w_r;
            results[i + 1] = y0_i + y1w_i;

	    results[n + i] = y0_r - y1w_r;
            results[n + i + 1] = y0_i - y1w_i;
        }

        for (i = 0; i < 2 * n; i++)
        {
            pop();
            push(results[i]);
        }
    }

}
*/
public class CombineDFT(n:Int) extends Filter[Float,Float] {
    val w:Array[Float];
    val wn_r:Float;
    val wn_i:Float;
    var real:Float;
    var imag:Float;
    var next_real:Float;
    var next_imag:Float;
    def this(n:Int) {
        super(2*n);
        property(n);
        wn_r = Math.cos(2 * 3.141592654 / n) as Float;
        wn_i = Math.sin(-2 * 3.141592654 / n) as Float;
        real = 1;
        imag = 0;
        w = new Rail[Float](n, 0.0f);
        for (var i:Int=0; i<n; i+=2) {
            w(i) = real;
            w(i+1) = imag;
            next_real = real * wn_r - imag * wn_i;
            next_imag = real * wn_i + imag * wn_r;
            real = next_real;
            imag = next_imag;
        }
    }
  
    public def work() {
        var results:Array[Float] = new Array[Float](2*n, 0.0 as Float);

        for (var i:Int = 0; i < n; i += 2)
        {
	        // this is a temporary work-around since there seems to be
	        // a bug in field prop that does not propagate nWay into the
	        // array references.  --BFT 9/10/02
	        
	        //int tempN = nWay;
	        //Fixed --jasperln
                
            // removed nWay, just using n  --sitij 9/26/03

	        val i_plus_1 = i+1;

	        val y0_r = peek(i);
            val y0_i = peek(i_plus_1);
                
	        val y1_r = peek(n + i);
            val y1_i = peek(n + i_plus_1);

	        // load into temps to make sure it doesn't got loaded
	        // separately for each load
	        val weight_real = w(i);
	        val weight_imag = w(i_plus_1);

            val y1w_r = y1_r * weight_real - y1_i * weight_imag;
            val y1w_i = y1_r * weight_imag + y1_i * weight_real;

            results(i) = y0_r + y1w_r;
            results(i + 1) = y0_i + y1w_i;

	        results(n + i) = y0_r - y1w_r;
            results(n + i + 1) = y0_i - y1w_i;
        }

        for (var i:Int = 0; i < 2 * n; i++)
        {
            pop();
            push(results(i));
        }
  }
}
