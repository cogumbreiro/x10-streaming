import StreamWriter.Entry;
import x10.util.Pair;
public struct Stream {
    
    private static def makeElement[T](cacheSize:Int, zero:T) {
        val buffer = new Rail[T](cacheSize, zero);
        return Cell.make[Entry[T]](new Entry[T](false, buffer));
    }
    
    public static def make[T](cacheSize:Int) {T haszero} = make[T](Clock.make(), cacheSize);
    
    public static def make[T](clock:Clock, cacheSize:Int) {T haszero} = make[T] (clock, cacheSize, Zero.get[T]());
    
    public static def make[T](clock:Clock, cacheSize:Int, zero:T) {
        val elem1 = makeElement[T](cacheSize, zero);
        val elem2 = makeElement[T](cacheSize, zero);
        val buffer1 = new DoubleBuffer[Cell[Entry[T]]](clock, elem1, elem2);
        val buffer2 = new DoubleBuffer[Cell[Entry[T]]](clock, elem2, elem1);
        val reader = new StreamReader[T](buffer1);
        val writer = new StreamWriter[T](buffer2);
        return new Pair[StreamWriter[T],StreamReader[T]](writer, reader);
    }
    
    public static type Broadcast[T] = Pair[StreamWriter[T],Rail[StreamReader[T]]];
    public static def makeBroadcast[T](readerCount:Int, cacheSize:Int) {T haszero} = makeBroadcast[T](readerCount, cacheSize, Zero.get[T]());
    public static def makeBroadcast[T](readerCount:Int, cacheSize:Int, zero:T):Broadcast[T] = makeBroadcast[T](readerCount, Clock.make(), cacheSize, zero);
    public static def makeBroadcast[T](readerCount:Int, clock:Clock, cacheSize:Int) {T haszero} = makeBroadcast[T](readerCount, clock, cacheSize, Zero.get[T]());
    public static def makeBroadcast[T](readerCount:Int, clock:Clock, cacheSize:Int, zero:T):Broadcast[T] {
        if (readerCount < 1) {
            throw new IllegalArgumentException();
        }
        val stream = make[T](clock, cacheSize, zero);
        
        val readers = new Rail[StreamReader[T]](readerCount, (x:Int) => x == 0 ? stream.second : stream.second.copy());
        return new Pair[StreamWriter[T], Rail[StreamReader[T]]](stream.first, readers);
    }

    public static def main(args:Array[String](1)):void {
        finish async {
            val T = 3;
            val clock1 = Clock.make("clock1");
            val clock2 = Clock.make("clock2");
            val db1 = makeBroadcast[Int](T, clock1, 2, 0);
            val db2 = makeBroadcast[Int](T, clock2, 2, 0);
            val N = 100000;
            //val N = 10;
            async clocked(clock1, clock2) {
                val writer1 = db1.first;
                val writer2 = db2.first;
                for (p in 1..N) {
                    writer1() = p;
                    writer2() = p;
                    //Console.OUT.println("! " + (p + p));
                }
                writer1.close();
                writer2.close();
            }
            for (p in 0..(T-1)) {
                val reader1 = db1.second(p);
                val reader2 = db2.second(p);
                
                async clocked(clock1, clock2) {
                    try {
                        while (true) {
                            val result:Int = reader1() + reader2();
                            //Console.OUT.println(result);
                        }
                    } catch (EOSException) {
                    }
                }
            }
        }
    }    
}
