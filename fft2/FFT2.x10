/*
void->void pipeline FFT2() {

  add FFTTestSource(64);
  add FFTKernel2(64);
  add FloatPrinter();
}


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


float->float pipeline FFTReorder(int n) {

  for(int i=1; i<(n/2); i*= 2)
    add FFTReorderSimple(n/i);

}


float->float pipeline FFTKernel1(int n) {

  if(n>2) {
    add splitjoin {
      split roundrobin(2);
      add FFTKernel1(n/2);
      add FFTKernel1(n/2);
      join roundrobin(n);
    }
  }
  add CombineDFT(n);
}


float->float splitjoin FFTKernel2(int n) {

  split roundrobin(2*n);
  for(int i=0; i<2; i++) {
    add pipeline {
      add FFTReorder(n);
      for(int j=2; j<=n; j*=2)
        add CombineDFT(j);
    }
  }
  join roundrobin(2*n);
}
*/











