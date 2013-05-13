import DoubleBuffer.Cursor;
public struct Stream[T](clock:Clock, reader:Stream.Reader[T], writer:Stream.Writer[T]) {
    public static class EOSException extends Error {}
    
    private static struct Entry[T](lastDatum:Boolean, buffer:Rail[T]){}
    private static type Element[T] = Cell[Entry[T]];
    
    private static def makeElement[T](cacheSize:Int, zero:T) {
        val buffer = new Rail[T](cacheSize, zero);
        return Cell.make[Entry[T]](new Entry[T](false, buffer));
    }
    
    public def this(cacheSize:Int) {T haszero} {
        this(Clock.make(), cacheSize);
    }
    
    public def this(clock:Clock, cacheSize:Int) {T haszero} {
        this(clock, cacheSize, Zero.get[T]());
    }
    
    public def this(clock:Clock, cacheSize:Int, zero:T) {
        val elem1 = makeElement[T](cacheSize, zero);
        val elem2 = makeElement[T](cacheSize, zero);
        val buffer = new DoubleBuffer[Element[T]](clock, elem1, elem2);
        val reader = new Reader[T](clock, buffer.first);
        val writer = new Writer[T](clock, buffer.first);
        property(clock, reader, writer);
    }
    
    public static class Writer[T](clock:Clock) {
        private val cursor:Cursor[Element[T]];
        private var buffer:Rail[T];
        private var eos:Boolean = false;
        private var idx:Int = 0;
        private def this(clock:Clock, cursor:Cursor[Element[T]]) {
            property(clock);
            this.cursor = cursor;
            this.buffer = cursor.get()().buffer;
        }

        public operator this()=(value:T) {
            set(value);
        }
        
        public def set(value:T):void {
            if (eos) throw new EOSException();
            buffer(idx) = value;
            idx += 1;
            if (idx == buffer.size) {
                cursor.advance();
                this.buffer = cursor.get()().buffer;
                idx = 0;
            }
            assert idx < buffer.size; 
        }
        
        public def close():void {
            eos = true;
            assert idx <= buffer.size;
            if (idx < buffer.size) {
                val newBuffer = new Rail[T](idx, (x:Int) => buffer(x));
                cursor.get()() = new Entry[T](true, newBuffer);
            } else {
                cursor.get()() = new Entry[T](true, buffer);
            }
            cursor.advance();
        }
    }
    
    public static class Reader[T](clock:Clock) implements ()=>T {
        private val cursor:Cursor[Element[T]];
        private var buffer:Rail[T];
        private var idx:Int;
        private var eos:Boolean = false;
        
        private def this(clock:Clock, cursor:Cursor[Element[T]]) {
            property(clock);
            this.cursor = cursor;
            this.buffer = cursor.get()().buffer;
            this.idx = buffer.size;
        }
        
        public def get() throws EOSException:T {
            if (eos) {
                throw new EOSException();
            }
            assert idx <= buffer.size;
            if (idx == buffer.size) { // it's empty
                fetch();
            }
            return buffer(idx++);
        }
        
        private def fetch() {
            if (cursor.get()().lastDatum) {
                eos = true;
                throw new EOSException();
            }
            cursor.advance();
            buffer = cursor.get()().buffer;
            idx = 0;
            if (idx == buffer.size) {
                eos = false;
                throw new EOSException();
            }
        }
        
        public operator this():T {
            return get();
        }
    }

    public static def main(args:Array[String](1)):void {
        finish async {
            val clock1 = Clock.make();
            val db1 = new Stream[Int](clock1, 1, 0);
            val clock2 = Clock.make();
            val db2 = new Stream[Int](clock2, 1, 0);
            val N = 100000;
            async clocked(clock1, clock2) {
                for (p in 1..N) {
                    db1.writer() = p;
                    db2.writer() = p;
                }
                db1.writer.close();
                db2.writer.close();
            }
            async clocked(clock1, clock2) {
                try {
                    while (true) {
                        //Console.OUT.println(db.reader());
                        db1.reader() + db2.reader();
                    }
                } catch (Stream.EOSException) {
                }
            }
        }
    }    
}
