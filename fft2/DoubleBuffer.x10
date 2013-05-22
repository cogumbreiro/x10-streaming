////import x10.util.Pair;
/*
 * (C) 2013 - Tiago Cogumbreiro (cogumbreiro@users.sf.net)
 * MIT License http://opensource.org/licenses/MIT
 */
public class DoubleBuffer[T](clock:Clock) implements () => T {
    
    private var currBuffer:T;
    private var nextBuffer:T;
    
    public def this(clock:Clock, currBuffer:T, nextBuffer:T) {
        property(clock);
        this.currBuffer = currBuffer;
        this.nextBuffer = nextBuffer;
    }
    
    public def get():T {
        return currBuffer;
    }
    
    public def advance():void {
        clock.advance();
        val result = currBuffer;
        currBuffer = nextBuffer;
        nextBuffer = result;
    }
    
    public operator this():T {
        return get();
    }
    
    public def copy() {
        return new DoubleBuffer[T](clock, currBuffer, nextBuffer);
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
