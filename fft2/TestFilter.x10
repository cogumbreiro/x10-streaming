
class TestFilter {
    static class Identity[T] extends Filter[T,T] {
        public def this(out:DoubleBuffer[T], inSize:Int) {
            super(out, inSize);
        }
        
        public def work() {
            push(pop());
        }
    }
    static class Error[T] extends Filter[T,T] {
        public def this(out:DoubleBuffer[T], inSize:Int) {
            super(out, inSize);
        }
        
        public def work() {
            assert false;
        }
    }
    
    val testEOF = () => {
        val inp = new DoubleBuffer[Int]();
        val out = new DoubleBuffer[Int]();
        inp.writer.markError(); 
        val filter = new Error[Int](inp, 1);
        filter.setReader(new ClockedReader[Int](inp.reader, 1));
        filter.launch();
        filter.launch();
    };
    
    val testInOut = () => {
        val inp = new DoubleBuffer[Int]();
        val out = new DoubleBuffer[Int]();
        inp.writer.markError(); 
        val filter = new Error[Int](inp, 1);
        filter.setReader(new ClockedReader[Int](inp.reader, 1));
        inp.writer() = 10;
        inp.writer.markError();
        filter.launch();
        assert out.reader() == 10 : "out.reader() == 10 but out.reader() == " + out.reader();
    };
    
    val allTests = [
        testEOF, testInOut
    ];
    
    public static def main(args:Array[String](1)):void {
        val suite = new TestFilter();
        for (p in suite.allTests) {
            suite.allTests(p)();
        }
    }
}

