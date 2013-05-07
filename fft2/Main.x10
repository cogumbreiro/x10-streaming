class Main {
    public static def main(args:Rail[String]):void {
        val source = new FFTTestSource(2);
        val sink = new FloatPrinter[Float]();
        source
          .add(new FloatDuplicate())
           /*
          .add(
            new RRSplitJoin[Float,Float](1, 1).
            split(new FloatDuplicate(), 1).
            split(new FloatNegate(), 1)
          )*/
          .add(sink);
        source.launch();
    }
}
