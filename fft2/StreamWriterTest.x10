import StreamWriter.Entry;

public class StreamWriterTest {
    public static def assertEquals[T](rail1:Rail[T], rail2:Rail[T]) {
        val min = Math.min(rail1.size, rail2.size);
        for (p in 0..(min - 1)) {
            assert rail1(p) == rail2(p) : rail1 + "(" + p + ") != " + rail2 + "(" + p + ")";
        }
        if (rail1.size != rail2.size) {
            assert rail1.equals(rail2) : rail1.toString() + " != " + rail2.toString();
        }
    }
    
    public static def assertEquals(v1:Any, v2:Any) {
        assert v1.equals(v2) : v1 + " != " + v2;
    }
    
    val testWrite1 = () => {
        val clock = Clock.make();
        
        val rail1 = new Rail[Int](2, 1);
        val rail2 = new Rail[Int](2, 2);
        
        val entry1 = Entry.make[Int](rail1);
        val entry2 = Entry.make[Int](rail2);
        
        val buf1 = Cell.make[Entry[Int]](entry1);
        val buf2 = Cell.make[Entry[Int]](entry2);
        
        val cursor = new DoubleBuffer[Cell[Entry[Int]]](clock, buf1, buf2);
        val writer = new StreamWriter[Int](cursor);
        writer() = 0;
        assertEquals[Int]([0,1], rail1);
        assertEquals[Int]([2 as Int,2 as Int], rail2);
    };

    val testWrite2 = () => {
        val clock = Clock.make();
        
        val rail1 = new Rail[Int](2, 1);
        val rail2 = new Rail[Int](2, 2);
        
        val entry1 = Entry.make[Int](rail1);
        val entry2 = Entry.make[Int](rail2);
        
        val buf1 = Cell.make[Entry[Int]](entry1);
        val buf2 = Cell.make[Entry[Int]](entry2);
        
        val cursor = new DoubleBuffer[Cell[Entry[Int]]](clock, buf1, buf2);
        val writer = new StreamWriter[Int](cursor);
        writer() = 0;
        writer() = 0;
        assertEquals[Int]([0 as Int,0 as Int], rail1);
        assertEquals[Int]([2 as Int,2 as Int], rail2);
    };

    /**
     * The number of elements is bigger than the buffer.
     */
    val testWrite3 = () => {
        val clock = Clock.make();
        
        val rail1 = new Rail[Int](2, 1);
        val rail2 = new Rail[Int](2, 2);
        
        val entry1 = Entry.make[Int](rail1);
        val entry2 = Entry.make[Int](rail2);
        
        val buf1 = Cell.make[Entry[Int]](entry1);
        val buf2 = Cell.make[Entry[Int]](entry2);
        
        val cursor = new DoubleBuffer[Cell[Entry[Int]]](clock, buf1, buf2);
        val writer = new StreamWriter[Int](cursor);
        writer() = 3;
        writer() = 6;
        writer() = 9;
        assertEquals[Int]([3 as Int,6 as Int], rail1);
        assertEquals[Int]([9 as Int,2 as Int], rail2);
    };
    
    /**
     * The number of elements should fill both buffers.
     */
    val testWrite4 = () => {
        val clock = Clock.make();
        
        val rail1 = new Rail[Int](2, 1);
        val rail2 = new Rail[Int](2, 2);
        
        val entry1 = Entry.make[Int](rail1);
        val entry2 = Entry.make[Int](rail2);
        
        val buf1 = Cell.make[Entry[Int]](entry1);
        val buf2 = Cell.make[Entry[Int]](entry2);
        
        val cursor = new DoubleBuffer[Cell[Entry[Int]]](clock, buf1, buf2);
        val writer = new StreamWriter[Int](cursor);
        writer() = 3;
        writer() = 6;
        writer() = 9;
        writer() = 12;
        assertEquals[Int]([3 as Int,6 as Int], rail1);
        assertEquals[Int]([9 as Int,12 as Int], rail2);
    };
    
    /**
     * The number of elements should fill both buffers and overwrites the
     * first buffer again.
     */
    val testWrite5 = () => {
        val clock = Clock.make();
        
        val rail1 = new Rail[Int](2, 1);
        val rail2 = new Rail[Int](2, 2);
        
        val entry1 = Entry.make[Int](rail1);
        val entry2 = Entry.make[Int](rail2);
        
        val buf1 = Cell.make[Entry[Int]](entry1);
        val buf2 = Cell.make[Entry[Int]](entry2);
        
        val cursor = new DoubleBuffer[Cell[Entry[Int]]](clock, buf1, buf2);
        val writer = new StreamWriter[Int](cursor);
        writer() = 3;
        writer() = 6;
        writer() = 9;
        writer() = 12;
        writer() = 15;
        assertEquals[Int]([15 as Int,6 as Int], rail1);
        assertEquals[Int]([9 as Int,12 as Int], rail2);
    };

    val testEOSEmpty = () => {
        val clock = Clock.make();
        
        val rail1 = new Rail[Int](2, 1);
        val rail2 = new Rail[Int](2, 2);
        
        val entry1 = Entry.make[Int](rail1);
        val entry2 = Entry.make[Int](rail2);
        
        val buf1 = Cell.make[Entry[Int]](entry1);
        val buf2 = Cell.make[Entry[Int]](entry2);
        
        val cursor = new DoubleBuffer[Cell[Entry[Int]]](clock, buf1, buf2);
        val writer = new StreamWriter[Int](cursor);
        writer.close();
        assert buf1().isLast;
        assert cursor.get() == buf2 : cursor.get().toString();
        assertEquals(0, buf1().buffer.size);
        assertEquals([1 as Int,1], rail1);
        assertEquals([2 as Int,2], rail2);
   };
    
    val allTests = [
        testWrite1, testWrite2, testWrite3, testWrite4, testWrite5, testEOSEmpty
    ];
    
    public static def main(args:Array[String](1)):void {
        val suite = new StreamWriterTest();
        for (p in suite.allTests) {
            suite.allTests(p)();
            Console.OUT.print('.');
        }
        Console.OUT.println();
    }

}
