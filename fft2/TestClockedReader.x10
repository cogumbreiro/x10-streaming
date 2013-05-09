import x10.util.ArrayList;

public class TestClockedReader {
    val testEOF = () => {
        val buf = new DoubleBuffer[Int]();
        val reader = new ClockedReader[Int](buf.reader, 1);
        buf.writer.markError();
        assert reader.isEOF();
        assert reader.isEOF();
        assert reader.isEOF();
    };
    
    val testWrite = () => {
        val buf = new DoubleBuffer[Int]();
        val reader = new ClockedReader[Int](buf.reader, 1);
        buf.writer() = 1;
        assert ! reader.isEOF();
        assert ! reader.isEOF();
        assert ! reader.isEOF();
    };
    
    val testWriteReadEOF = () => {
        val buf = new DoubleBuffer[Int]();
        val reader = new ClockedReader[Int](buf.reader, 1);
        buf.writer() = 10;
        assert 10 == reader.pop(); // consume
        buf.writer.markError();
        assert reader.isEOF() : "reader.isEOF()";
        assert reader.isEOF() : "reader.isEOF()";
        assert reader.isEOF() : "reader.isEOF()";
    };
    
    val testWriteReadEOF2 = () => {
        val buf = new DoubleBuffer[Int]();
        val reader = new ClockedReader[Int](buf.reader, 1);
        buf.writer() = 1;
        reader.pop(); // consume
        buf.writer() = 1;
        assert ! reader.isEOF() : "reader.isEOF()";
        assert ! reader.isEOF() : "reader.isEOF()";
        assert ! reader.isEOF() : "reader.isEOF()";
    };
    
    val testError1 = () => {
        val buf = new DoubleBuffer[Int]();
        val reader = new ClockedReader[Int](buf.reader, 1);
        buf.writer.markError();
        try {
            reader.pop();
            assert false : "reader.pop()";
        } catch (AssertionError) {
        }
    };
    
    val testError2 = () => {
        val buf = new DoubleBuffer[Int]();
        val reader = new ClockedReader[Int](buf.reader, 1);
        buf.writer.markError();
        try {
            reader.peek(0);
            assert false : "reader.peek(0)";
        } catch (AssertionError) {
        }
    };
    
    val allTests = [
        testEOF, testWrite, testWriteReadEOF, testWriteReadEOF2, testError1,
        testError2
    ];
    
    public static def main(args:Array[String](1)):void {
        val suite = new TestClockedReader();
        for (p in suite.allTests) {
            Console.OUT.print('.');
            suite.allTests(p)(); 
        }
        Console.OUT.println();
    }
    
}
