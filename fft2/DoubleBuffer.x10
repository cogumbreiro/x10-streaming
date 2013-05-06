/*
 * (C) 2013 - Tiago Cogumbreiro (cogumbreiro@users.sf.net)
 * MIT License http://opensource.org/licenses/MIT
 */
public class DoubleBuffer[T](clock:Clock, reader:DoubleBuffer.Reader[T], writer:DoubleBuffer.Writer[T]) {
    private val buffer:Array[T](1);
    
    public def this(clock:Clock, buffer:Array[T](1)) {
        property(clock,
                 new Reader[T](clock, buffer),
                 new Writer[T](clock, buffer));
        this.buffer = buffer;
    }
    public def this(clock:Clock) {T haszero} {
        val buffer = new Array[T](2, Zero.get[T]());
        property(clock,
                 new Reader[T](clock, buffer),
                 new Writer[T](clock, buffer));
        this.buffer = buffer;
    }

    public static final class Reader[T] implements ()=>T {
        private val buffer:Array[T](1);
        private var idx:Int = 0;
        private val clock:Clock;
        public def this(clock:Clock, buffer:Array[T](1)) {
            this.buffer = buffer;
            this.clock = clock;
        }
        public def get():T {
            clock.advance();
            val result = buffer(idx);
            clock.resume();
            idx += 1;
            idx %= 2;
            return result;
        }
        public operator this():T {
            return get();
        }
    }
    
    public static final class Writer[T] implements (T)=>void {
        private val buffer:Array[T](1);
        private var idx:Int = 0;
        private val clock:Clock;
        public def this(clock:Clock, buffer:Array[T](1)) {
            this.buffer = buffer;
            this.clock = clock;
        }
        public def set(value:T):void {
            buffer(idx) = value;
            clock.resume();
            idx += 1;
            idx %= 2;
            clock.advance();
        }
        
        public operator this()=(value:T) {
            set(value);
        }
        
        public operator this(value:T):void {
            set(value);
        }
    }
    
    public static def main(args:Array[String](1)):void {
        finish async {
            val clock = Clock.make();
            val db = new DoubleBuffer[Int](clock);
            async clocked(clock) {
                for (p in 1..10) {
                    db.writer() = p;
                }
            }
            async clocked(clock) {
                for (p in 1..10) {
                    Console.OUT.println(db.reader());
                }
            }
        }
    }    
}
