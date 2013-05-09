class Main {
    public static def main(args:Rail[String]):void {
        val prog = new FFTTestSource(2);
        prog
          .add(new FloatDuplicate())
          .add(new FloatDuplicate())
          /*.add(
            new RRSplitJoin[Float,Float](1, 1).
            split(new FloatDuplicate(), 1).
            split(new FloatNegate(), 1)
          )*/
          .add(new FloatPrinter[Float]());
        prog.start();
        //prog.eof();
    }
}
