import x10.util.Pair;
/*
 * (C) 2013 - Tiago Cogumbreiro (cogumbreiro@users.sf.net)
 * MIT License http://opensource.org/licenses/MIT
 */
public class DoubleBuffer[T](clock:Clock, reader:DoubleBuffer.Reader[T], writer:DoubleBuffer.Writer[T]) {
    private val buffer:Rail[T];
    private val errors:Rail[Boolean];
    
    public def this(clock:Clock, buffer:Rail[T]) {
        val errors = new Rail[Boolean](1, false);
        property(clock,
                 new Reader[T](clock, buffer, errors),
                 new Writer[T](clock, buffer, errors));
        this.buffer = buffer;
        this.errors = errors;
    }
    public def this(clock:Clock) {T haszero} {
        this(clock, new Rail[T](2, Zero.get[T]()));
    }
    public def this() {T haszero} {
        this(Clock.make());
    }

    public static final class Reader[T](clock:Clock) implements ()=>T {
        private val buffer:Rail[T];
        private val errors:Rail[Boolean];
        private var idx:Int = 0;
        public def this(clock:Clock, buffer:Rail[T], errors:Rail[Boolean]) {
            property(clock);
            this.buffer = buffer;
            this.errors = errors;
        }
        public def get():T {
            clock.advance();
            val result = buffer(idx);
            clock.resume();
            idx += 1;
            idx %= 2;
            return result;
        }
        public def getAndCheck():Pair[Boolean,T] {
            clock.advance();
            val result = new Pair[Boolean,T](errors(idx), buffer(idx));
            clock.resume();
            idx += 1;
            idx %= 2;
            return result;
        }
        public operator this():T {
            return get();
        }
    }
    
    public static final class Writer[T](clock:Clock) implements (T)=>void {
        private val buffer:Rail[T];
        private val errors:Rail[Boolean];
        private var idx:Int = 0;
        public def this(clock:Clock, buffer:Rail[T], errors:Rail[Boolean]) {
            property(clock);
            this.buffer = buffer;
            this.errors = errors;
        }
        public def set(value:T):void {
            buffer(idx) = value;
            clock.resume();
            idx += 1;
            idx %= 2;
            clock.advance();
        }
        public def markError():void {
            errors(idx) = true;
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
            val N = 10;
            async clocked(clock) {
                for (p in 1..N) {
                    db.writer() = p * 2;
                }
            }
            async clocked(clock) {
                for (p in 1..N) {
                    Console.OUT.println(db.reader());
                }
            }
        }
    }    
}
