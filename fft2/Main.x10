class Main {
    public static def main(args:Rail[String]):void {
        val source = new FFTTestSource(2);
        val sink = new FloatPrinter[Float]();
        source.add(sink);
        source.launch();
    }
}
