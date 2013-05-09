import x10.util.Pair;
/*
 * (C) 2013 - Tiago Cogumbreiro (cogumbreiro@users.sf.net)
 * MIT License http://opensource.org/licenses/MIT
 */
public struct DoubleBuffer[T](clock:Clock, reader:DoubleBuffer.Reader[T], writer:DoubleBuffer.Writer[T]) {
    private val buffer:Rail[T];
    
    public def this(clock:Clock, buffer:Rail[T]) {
        property(clock,
                 new Reader[T](clock, buffer),
                 new Writer[T](clock, buffer));
        this.buffer = buffer;
    }
    public def this(clock:Clock) {T haszero} {
        this(clock, new Rail[T](2, Zero.get[T]()));
    }
    public def this() {T haszero} {
        this(Clock.make());
    }

    public static final class Reader[T](clock:Clock) implements ()=>T {
        private val buffer:Rail[T];
        private val idx = new CircularInt(2);
        public def this(clock:Clock, buffer:Rail[T]) {
            property(clock);
            this.buffer = buffer;
        }
        public def get():T {
            clock.advance();
            val result = buffer(idx.get());
            clock.resume();
            idx.increment();
            return result;
        }
        public operator this():T {
            return get();
        }
    }
    
    public static final class Writer[T](clock:Clock) {
        private val buffer:Rail[T];
        private val idx = new CircularInt(2);
        public def this(clock:Clock, buffer:Rail[T]) {
            property(clock);
            this.buffer = buffer;
        }
        public def set(value:T):void {
            buffer(idx.get()) = value;
            clock.resume();
            idx.increment();
            clock.advance();
        }
        public operator this()=(value:T) {
            set(value);
        }
    }
    
    public static def main(args:Array[String](1)):void {
        /*
        finish async {
            val clock = Clock.make();
            val db = new DoubleBuffer[Int](clock);
            val N = 10;
            async clocked(clock) {
                for (p in 1..N) {
                    db.writer() = p;
                }
                db.writer.markError();
            }
            async clocked(clock) {
                for (var p:Pair[Boolean,Int] = db.reader.getAndCheck(); ! p.first; p = db.reader.getAndCheck()) {
                    Console.OUT.println(p.second);
                }
            }
        }*/
    }    
}
